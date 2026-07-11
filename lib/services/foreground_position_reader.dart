import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Temporary product thresholds for one-time registration feedback only.
///
/// These are **not** city-boundary verification rules.
///
/// - good: accuracy <= [goodMaxMeters]
/// - limited: accuracy > [goodMaxMeters] and <= [limitedMaxMeters]
/// - insufficient: accuracy > [limitedMaxMeters]
abstract final class ForegroundAccuracyThresholds {
  static const double goodMaxMeters = 50;
  static const double limitedMaxMeters = 150;
}

/// Explicit timeout for the single foreground position request.
const Duration kForegroundPositionTimeout = Duration(seconds: 15);

/// One-time foreground position-read outcomes.
///
/// Does not include city-verification state.
enum ForegroundPositionReadState {
  idle,
  requestingPermission,
  reading,
  successGood,
  successLimited,
  insufficientAccuracy,
  timeout,
  error,
  permissionLost,
  serviceDisabled,
}

/// Retained UI-safe result of a one-time position read.
///
/// Contains only classification and rounded accuracy in metres.
/// Never retains latitude or longitude.
class ForegroundPositionReadResult {
  const ForegroundPositionReadResult({
    required this.state,
    this.accuracyMeters,
  });

  final ForegroundPositionReadState state;

  /// Rounded horizontal accuracy in metres, when a reading was obtained.
  final int? accuracyMeters;

  bool get isTerminalSuccess =>
      state == ForegroundPositionReadState.successGood ||
      state == ForegroundPositionReadState.successLimited ||
      state == ForegroundPositionReadState.insufficientAccuracy;

  bool get canRetry =>
      state == ForegroundPositionReadState.timeout ||
      state == ForegroundPositionReadState.error ||
      state == ForegroundPositionReadState.insufficientAccuracy ||
      state == ForegroundPositionReadState.permissionLost ||
      state == ForegroundPositionReadState.serviceDisabled;
}

/// Failure during a one-time transient coordinate read.
///
/// Messages never include latitude, longitude, device location objects, or
/// accuracy values.
enum ForegroundCoordinateReadFailure {
  locationServicesDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  timeout,
  positionReadFailed,
}

/// Typed failure for [ForegroundPositionReader.readCoordinatesOnce].
class ForegroundCoordinateReadException implements Exception {
  const ForegroundCoordinateReadException(
    this.failure, [
    this.message = 'Coordinate read failed.',
  ]);

  final ForegroundCoordinateReadFailure failure;
  final String message;

  @override
  String toString() => 'ForegroundCoordinateReadException($failure): $message';
}

/// Reads exactly one current device position for foreground registration.
///
/// Uses [Geolocator.getCurrentPosition] only. Does not use position streams
/// or last-known position. Coordinates exist only transiently while
/// classifying accuracy, then are discarded.
class ForegroundPositionReader {
  const ForegroundPositionReader();

  /// Performs one foreground position request with [kForegroundPositionTimeout].
  Future<ForegroundPositionReadResult> readOnce() async {
    try {
      return await _withCurrentPositionOnce((Position position) async {
        // Read accuracy only; discard the Position (and its coordinates) after.
        final int accuracyMeters = position.accuracy.round();
        return classifyAccuracyMeters(accuracyMeters);
      });
    } on ForegroundCoordinateReadException catch (e) {
      switch (e.failure) {
        case ForegroundCoordinateReadFailure.locationServicesDisabled:
          return const ForegroundPositionReadResult(
            state: ForegroundPositionReadState.serviceDisabled,
          );
        case ForegroundCoordinateReadFailure.permissionDenied:
        case ForegroundCoordinateReadFailure.permissionPermanentlyDenied:
          return const ForegroundPositionReadResult(
            state: ForegroundPositionReadState.permissionLost,
          );
        case ForegroundCoordinateReadFailure.timeout:
          return const ForegroundPositionReadResult(
            state: ForegroundPositionReadState.timeout,
          );
        case ForegroundCoordinateReadFailure.positionReadFailed:
          return const ForegroundPositionReadResult(
            state: ForegroundPositionReadState.error,
          );
      }
    } on TimeoutException {
      return const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.timeout,
      );
    } on Object {
      // Do not expose raw exception text to the user.
      return const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.error,
      );
    }
  }

  /// Performs exactly one [Geolocator.getCurrentPosition] and passes only
  /// longitude, latitude, and accuracy into [use].
  ///
  /// The raw [Position] exists only as a local variable for this call and is
  /// discarded when [use] completes. Does not request permission.
  Future<T> readCoordinatesOnce<T>(
    Future<T> Function({
      required double longitude,
      required double latitude,
      required double accuracy,
    }) use,
  ) {
    return _withCurrentPositionOnce((Position position) {
      return use(
        longitude: position.longitude,
        latitude: position.latitude,
        accuracy: position.accuracy,
      );
    });
  }

  /// Single shared production call site for [Geolocator.getCurrentPosition].
  ///
  /// Prerequisite and position-read failures are wrapped as
  /// [ForegroundCoordinateReadException]. Failures raised by [use] propagate
  /// unchanged so callers can keep classification / bridge errors distinct.
  Future<T> _withCurrentPositionOnce<T>(
    Future<T> Function(Position position) use,
  ) async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const ForegroundCoordinateReadException(
        ForegroundCoordinateReadFailure.locationServicesDisabled,
        'Location services are disabled.',
      );
    }

    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw const ForegroundCoordinateReadException(
        ForegroundCoordinateReadFailure.permissionPermanentlyDenied,
        'Location permission permanently denied.',
      );
    }
    if (!_isGranted(permission)) {
      throw const ForegroundCoordinateReadException(
        ForegroundCoordinateReadFailure.permissionDenied,
        'Location permission not granted.',
      );
    }

    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          // One-time registration check — not navigation-grade tracking.
          accuracy: LocationAccuracy.high,
          timeLimit: kForegroundPositionTimeout,
        ),
      );
    } on TimeoutException {
      throw const ForegroundCoordinateReadException(
        ForegroundCoordinateReadFailure.timeout,
        'Location request timed out.',
      );
    } on Object {
      throw const ForegroundCoordinateReadException(
        ForegroundCoordinateReadFailure.positionReadFailed,
        'Location request failed.',
      );
    }

    return await use(position);
  }

  /// Classifies a rounded accuracy value using [ForegroundAccuracyThresholds].
  @visibleForTesting
  static ForegroundPositionReadResult classifyAccuracyMeters(
    int accuracyMeters,
  ) {
    if (accuracyMeters <= ForegroundAccuracyThresholds.goodMaxMeters) {
      return ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: accuracyMeters,
      );
    }
    if (accuracyMeters <= ForegroundAccuracyThresholds.limitedMaxMeters) {
      return ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successLimited,
        accuracyMeters: accuracyMeters,
      );
    }
    return ForegroundPositionReadResult(
      state: ForegroundPositionReadState.insufficientAccuracy,
      accuracyMeters: accuracyMeters,
    );
  }

  static bool _isGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}
