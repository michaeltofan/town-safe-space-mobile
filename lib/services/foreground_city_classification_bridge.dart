import 'package:town_safe_space_mobile/services/city_boundary_classification_service.dart';
import 'package:town_safe_space_mobile/services/foreground_position_reader.dart';

/// Typed failure for the internal foreground classification bridge.
///
/// Never carries latitude, longitude, accuracy values, device location
/// objects, raw GeoJSON, or lower-level exception strings that include inputs.
enum ForegroundCityClassificationBridgeFailure {
  locationServicesDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  timeout,
  positionReadFailed,
  unsupportedCity,
  boundaryAssetFailed,
  classificationFailed,
  busy,
}

/// Safe bridge failure raised before a privacy-safe classification result is
/// available. Messages never include coordinates or device location objects.
class ForegroundCityClassificationBridgeException implements Exception {
  const ForegroundCityClassificationBridgeException(
    this.failure, [
    this.message = 'Bridge operation failed.',
  ]);

  final ForegroundCityClassificationBridgeFailure failure;
  final String message;

  @override
  String toString() =>
      'ForegroundCityClassificationBridgeException($failure): $message';
}

/// Smallest injectable abstraction for one transient foreground coordinate
/// sample. Implementations must discard raw coordinates when [use] returns.
abstract class OneTimeForegroundCoordinateReader {
  Future<T> readCoordinatesOnce<T>(
    Future<T> Function({
      required double longitude,
      required double latitude,
      required double accuracy,
    }) use,
  );
}

/// Adapter over [ForegroundPositionReader.readCoordinatesOnce].
class ForegroundPositionCoordinateReader
    implements OneTimeForegroundCoordinateReader {
  const ForegroundPositionCoordinateReader([
    this._reader = const ForegroundPositionReader(),
  ]);

  final ForegroundPositionReader _reader;

  @override
  Future<T> readCoordinatesOnce<T>(
    Future<T> Function({
      required double longitude,
      required double latitude,
      required double accuracy,
    }) use,
  ) {
    return _reader.readCoordinatesOnce(use);
  }
}

/// Internal bridge: one transient foreground location sample → city
/// classification.
///
/// Disconnected from screens and navigation. Returns only
/// [CityBoundaryClassificationResult]. Does not persist, transmit, log, or
/// display results. Does not request permission.
class ForegroundCityClassificationBridge {
  ForegroundCityClassificationBridge({
    OneTimeForegroundCoordinateReader? coordinateReader,
    CityBoundaryClassificationService? classificationService,
  })  : _coordinateReader =
            coordinateReader ?? const ForegroundPositionCoordinateReader(),
        _classificationService =
            classificationService ?? CityBoundaryClassificationService();

  final OneTimeForegroundCoordinateReader _coordinateReader;
  final CityBoundaryClassificationService _classificationService;

  bool _busy = false;

  /// Performs exactly one foreground position read, classifies against
  /// [selectedCity], and returns only the privacy-safe result.
  ///
  /// [selectedCity] must be an explicit canonical identifier (`Milano` or
  /// `Munich`). City is never inferred from coordinates.
  Future<CityBoundaryClassificationResult> readAndClassifyOnce({
    required String selectedCity,
  }) async {
    if (_busy) {
      throw const ForegroundCityClassificationBridgeException(
        ForegroundCityClassificationBridgeFailure.busy,
        'Classification already in progress.',
      );
    }

    _busy = true;
    try {
      // Reject unsupported cities before any position read.
      try {
        CityBoundaryClassificationService.assetPathForCity(selectedCity);
      } on CityBoundaryClassificationException {
        throw const ForegroundCityClassificationBridgeException(
          ForegroundCityClassificationBridgeFailure.unsupportedCity,
          'Unsupported city.',
        );
      }

      return await _coordinateReader.readCoordinatesOnce(
        ({
          required double longitude,
          required double latitude,
          required double accuracy,
        }) async {
          try {
            return await _classificationService.classifyCoordinatesTransiently(
              selectedCity: selectedCity,
              longitude: longitude,
              latitude: latitude,
              accuracyMeters: accuracy,
            );
          } on CityBoundaryClassificationException catch (e) {
            throw _mapClassificationFailure(e);
          }
        },
      );
    } on ForegroundCityClassificationBridgeException {
      rethrow;
    } on ForegroundCoordinateReadException catch (e) {
      throw _mapCoordinateReadFailure(e);
    } on CityBoundaryClassificationException catch (e) {
      throw _mapClassificationFailure(e);
    } finally {
      _busy = false;
    }
  }

  static ForegroundCityClassificationBridgeException _mapCoordinateReadFailure(
    ForegroundCoordinateReadException error,
  ) {
    switch (error.failure) {
      case ForegroundCoordinateReadFailure.locationServicesDisabled:
        return const ForegroundCityClassificationBridgeException(
          ForegroundCityClassificationBridgeFailure.locationServicesDisabled,
          'Location services are disabled.',
        );
      case ForegroundCoordinateReadFailure.permissionDenied:
        return const ForegroundCityClassificationBridgeException(
          ForegroundCityClassificationBridgeFailure.permissionDenied,
          'Location permission not granted.',
        );
      case ForegroundCoordinateReadFailure.permissionPermanentlyDenied:
        return const ForegroundCityClassificationBridgeException(
          ForegroundCityClassificationBridgeFailure.permissionPermanentlyDenied,
          'Location permission permanently denied.',
        );
      case ForegroundCoordinateReadFailure.timeout:
        return const ForegroundCityClassificationBridgeException(
          ForegroundCityClassificationBridgeFailure.timeout,
          'Location request timed out.',
        );
      case ForegroundCoordinateReadFailure.positionReadFailed:
        return const ForegroundCityClassificationBridgeException(
          ForegroundCityClassificationBridgeFailure.positionReadFailed,
          'Location request failed.',
        );
    }
  }

  static ForegroundCityClassificationBridgeException _mapClassificationFailure(
    CityBoundaryClassificationException error,
  ) {
    final String message = error.message;
    if (message == 'Unsupported city.') {
      return const ForegroundCityClassificationBridgeException(
        ForegroundCityClassificationBridgeFailure.unsupportedCity,
        'Unsupported city.',
      );
    }
    if (message == 'Invalid accuracy value.' ||
        message == 'Classification failed.') {
      return const ForegroundCityClassificationBridgeException(
        ForegroundCityClassificationBridgeFailure.classificationFailed,
        'Classification failed.',
      );
    }
    // Boundary asset load / metadata / geometry parse failures.
    return const ForegroundCityClassificationBridgeException(
      ForegroundCityClassificationBridgeFailure.boundaryAssetFailed,
      'Boundary asset failure.',
    );
  }
}
