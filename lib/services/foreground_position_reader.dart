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
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const ForegroundPositionReadResult(
          state: ForegroundPositionReadState.serviceDisabled,
        );
      }

      final LocationPermission permission = await Geolocator.checkPermission();
      if (!_isGranted(permission)) {
        return const ForegroundPositionReadResult(
          state: ForegroundPositionReadState.permissionLost,
        );
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          // One-time registration check — not navigation-grade tracking.
          accuracy: LocationAccuracy.high,
          timeLimit: kForegroundPositionTimeout,
        ),
      );

      // Read accuracy only; discard the Position (and its coordinates) after.
      final int accuracyMeters = position.accuracy.round();
      return classifyAccuracyMeters(accuracyMeters);
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
