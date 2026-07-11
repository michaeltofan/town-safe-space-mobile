import 'package:flutter/services.dart';
import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';
import 'package:town_safe_space_mobile/services/boundary_asset_loader.dart';

/// Privacy-safe in-memory result of local city-boundary classification.
///
/// Retains only:
/// - [city] (selected city identifier)
/// - [containment] (inside / outside / boundary)
/// - [accuracyMeters] (rounded horizontal accuracy)
/// - [classifiedAt] (UTC completion time)
///
/// Never retains latitude, longitude, device location objects, geometry, or
/// raw coordinate arrays. Not persisted, transmitted, or logged.
class CityBoundaryClassificationResult {
  const CityBoundaryClassificationResult({
    required this.city,
    required this.containment,
    required this.accuracyMeters,
    required this.classifiedAt,
  });

  /// Canonical selected city identifier (`Milano` or `Munich`).
  final String city;

  /// Geometric containment only — not an access decision.
  final PointContainment containment;

  /// Rounded horizontal accuracy in metres.
  final int accuracyMeters;

  /// UTC timestamp when local classification completed.
  final DateTime classifiedAt;
}

/// Local failure during city-boundary classification.
///
/// Messages never include latitude, longitude, device location objects, or
/// raw GeoJSON.
class CityBoundaryClassificationException implements Exception {
  const CityBoundaryClassificationException(this.message);

  final String message;

  @override
  String toString() => 'CityBoundaryClassificationException: $message';
}

/// Orchestrates offline local classification of a transient point against the
/// selected city's local boundary asset.
///
/// Coordinates exist only as method parameters / local variables during a
/// single [classifyCoordinatesTransiently] call and are discarded on return.
/// This service does not read GPS, request permissions, persist results,
/// transmit data, log coordinates, or drive UI.
class CityBoundaryClassificationService {
  CityBoundaryClassificationService({
    AssetBundle? bundle,
    BoundaryAssetLoader assetLoader = const BoundaryAssetLoader(),
    BoundaryGeometryParser geometryParser = const BoundaryGeometryParser(),
    PointInPolygonEngine engine = const PointInPolygonEngine(),
    DateTime Function()? clock,
  })  : _bundle = bundle,
        _assetLoader = assetLoader,
        _geometryParser = geometryParser,
        _engine = engine,
        _clock = clock ?? (() => DateTime.now().toUtc());

  final AssetBundle? _bundle;
  final BoundaryAssetLoader _assetLoader;
  final BoundaryGeometryParser _geometryParser;
  final PointInPolygonEngine _engine;
  final DateTime Function() _clock;

  AssetBundle get _resolvedBundle => _bundle ?? rootBundle;

  /// Explicit fixed mapping from canonical city id to local asset path.
  static const Map<String, String> cityAssetPaths = <String, String>{
    'Milano': BoundaryAssetPaths.milano,
    'Munich': BoundaryAssetPaths.munich,
  };

  /// Metadata `city` property expected inside each local asset.
  static const Map<String, String> cityMetadataIds = <String, String>{
    'Milano': 'milano',
    'Munich': 'munich',
  };

  /// Returns the local asset path for [selectedCity].
  ///
  /// Throws [CityBoundaryClassificationException] for unsupported cities.
  static String assetPathForCity(String selectedCity) {
    final String? path = cityAssetPaths[selectedCity];
    if (path == null) {
      throw const CityBoundaryClassificationException(
        'Unsupported city.',
      );
    }
    return path;
  }

  /// Classifies a transient longitude/latitude against the selected city's
  /// local boundary asset.
  ///
  /// [longitude], [latitude], and [accuracyMeters] are method parameters only.
  /// They are not stored on the service, not placed in the result, and not
  /// logged. [accuracyMeters] is rounded with the same `.round()` behaviour
  /// used by the foreground position reader.
  Future<CityBoundaryClassificationResult> classifyCoordinatesTransiently({
    required String selectedCity,
    required double longitude,
    required double latitude,
    required double accuracyMeters,
  }) async {
    final String assetPath = assetPathForCity(selectedCity);
    final String expectedMetadataCity = cityMetadataIds[selectedCity]!;

    final String text;
    try {
      text = await _resolvedBundle.loadString(assetPath);
    } on Object {
      throw const CityBoundaryClassificationException(
        'Failed to load boundary asset for selected city.',
      );
    }

    final BoundaryAssetMetadata metadata;
    try {
      metadata = _assetLoader.decodeAndValidate(text);
    } on BoundaryAssetException catch (e) {
      throw CityBoundaryClassificationException(e.message);
    } on Object {
      throw const CityBoundaryClassificationException(
        'Malformed boundary metadata.',
      );
    }

    if (metadata.city != expectedMetadataCity) {
      throw const CityBoundaryClassificationException(
        'Boundary metadata city does not match selected city.',
      );
    }

    final BoundaryGeometry geometry;
    try {
      geometry = _geometryParser.parseFeatureCollectionJson(text);
    } on GeometryParseException {
      throw const CityBoundaryClassificationException(
        'Failed to parse boundary geometry.',
      );
    } on Object {
      throw const CityBoundaryClassificationException(
        'Failed to parse boundary geometry.',
      );
    }

    final PointContainment containment;
    try {
      final GeoPoint point = GeoPoint(
        longitude: longitude,
        latitude: latitude,
      );
      containment = _engine.classify(geometry: geometry, point: point);
    } on Object {
      throw const CityBoundaryClassificationException(
        'Classification failed.',
      );
    }

    return CityBoundaryClassificationResult(
      city: selectedCity,
      containment: containment,
      accuracyMeters: accuracyMeters.round(),
      classifiedAt: _clock(),
    );
  }
}
