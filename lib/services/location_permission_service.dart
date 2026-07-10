import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Foreground location permission / service outcomes.
///
/// This stage never reads coordinates.
enum ForegroundLocationState {
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
}

/// Thin helper around geolocator permission and service checks only.
///
/// Intentionally does not read device coordinates or subscribe to
/// position updates in this stage.
class LocationPermissionService {
  const LocationPermissionService();

  /// Checks location services, then current permission, requesting
  /// foreground permission when it has not been granted yet.
  Future<ForegroundLocationState> ensureForegroundPermission() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return ForegroundLocationState.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (_isGranted(permission)) {
      return ForegroundLocationState.granted;
    }

    if (permission == LocationPermission.deniedForever) {
      return ForegroundLocationState.permanentlyDenied;
    }

    // Request only when permission is not yet granted / permanently denied.
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
    }

    return mapPermissionAfterRequest(permission);
  }

  /// Opens the app settings page. Returns false when unsupported (e.g. web).
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } on Object {
      return false;
    }
  }

  /// Opens device location settings. Returns false when unsupported (e.g. web).
  Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } on Object {
      return false;
    }
  }

  /// Maps a [LocationPermission] returned after a request attempt.
  ///
  /// Mapping:
  /// - whileInUse / always → granted (never requests Always)
  /// - deniedForever → permanentlyDenied
  /// - denied / unableToDetermine → denied
  @visibleForTesting
  ForegroundLocationState mapPermissionAfterRequest(
    LocationPermission permission,
  ) {
    if (_isGranted(permission)) {
      return ForegroundLocationState.granted;
    }
    if (permission == LocationPermission.deniedForever) {
      return ForegroundLocationState.permanentlyDenied;
    }
    // denied and unableToDetermine both surface as a normal denial after
    // the request result. Do not infer a restricted state.
    return ForegroundLocationState.denied;
  }

  static bool _isGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}
