import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../geometry/point_in_polygon_engine.dart';
import '../owner_preview.dart';
import '../services/city_boundary_classification_service.dart';
import '../services/foreground_city_classification_bridge.dart';
import '../services/foreground_position_reader.dart';
import '../services/location_permission_service.dart';
import 'town_feed_screen.dart';

/// Explicit internal UI states for location verification.
///
/// Never shown as enum names to users.
enum LocationVerificationUiState {
  idle,
  requestingPermission,
  readingAndClassifying,
  confirmedGood,
  confirmedLimited,
  uncertain,
  outsideSelectedCity,
  servicesDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  timeout,
  technicalError,
}

/// Location Confirmation screen.
///
/// Checks/requests foreground permission, then calls
/// [ForegroundCityClassificationBridge.readAndClassifyOnce] exactly once per
/// attempt. Maps safe results and typed failures to visible UI states.
/// Remains on this screen after all outcomes. Never retains or displays raw
/// coordinates.
class LocationConfirmationScreen extends StatefulWidget {
  LocationConfirmationScreen({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
    this.permissionService = const LocationPermissionService(),
    ForegroundCityClassificationBridge? classificationBridge,
    bool? ownerJourneyMode,
    Uri? uri,
    bool? isWeb,
  }) : classificationBridge =
           classificationBridge ?? ForegroundCityClassificationBridge(),
       ownerJourneyMode =
           ownerJourneyMode ??
           isOwnerJourneyMode(uri: uri ?? Uri.base, isWeb: isWeb ?? kIsWeb);

  /// Canonical country from Select City (`Italy` or `Germany`).
  final String selectedCountry;

  /// Canonical city id (`Milano` or `Munich`).
  final String selectedCity;

  /// Injectable permission helper for tests.
  final LocationPermissionService permissionService;

  /// Injectable classification bridge for tests.
  final ForegroundCityClassificationBridge classificationBridge;

  /// Path-scoped owner journey mode. Production detects `/owner-journey-v1/`
  /// via [isOwnerJourneyMode]. Tests inject an explicit value.
  final bool ownerJourneyMode;

  @override
  State<LocationConfirmationScreen> createState() =>
      _LocationConfirmationScreenState();
}

class _LocationConfirmationScreenState
    extends State<LocationConfirmationScreen> {
  static const Color _background = Color(0xFF000000);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _lightGrey = Color(0xFFB0B0B0);
  static const Color _gold = Color(0xFFE8C547);

  static const double _maxContentWidth = 410;

  LocationVerificationUiState _uiState = LocationVerificationUiState.idle;
  int? _accuracyMeters;
  PointContainment? _resultContainment;
  bool _changeCityVisible = false;
  bool _isBusy = false;

  bool get _isProgressState =>
      _uiState == LocationVerificationUiState.requestingPermission ||
      _uiState == LocationVerificationUiState.readingAndClassifying;

  _LocationConfirmationCopy get _copy {
    assert(
      (widget.selectedCountry == 'Italy' && widget.selectedCity == 'Milano') ||
          (widget.selectedCountry == 'Germany' &&
              widget.selectedCity == 'Munich'),
      'Unsupported country/city pair: ${widget.selectedCountry} / ${widget.selectedCity}',
    );
    if (widget.selectedCountry == 'Italy') {
      return const _LocationConfirmationCopy.italian();
    }
    return const _LocationConfirmationCopy.german();
  }

  String get _cityDisplayName {
    if (widget.selectedCountry == 'Italy') {
      if (widget.selectedCity == 'Milano') {
        return 'Milano';
      }
      if (widget.selectedCity == 'Munich') {
        return 'Monaco di Baviera';
      }
    } else {
      if (widget.selectedCity == 'Munich') {
        return 'München';
      }
      if (widget.selectedCity == 'Milano') {
        return 'Mailand';
      }
    }
    return widget.selectedCity;
  }

  /// Display-only accuracy for the shared confirmed-good copy in owner
  /// journey mode. Not a GPS reading and not persisted.
  static const int _ownerJourneyDisplayAccuracyMeters = 25;

  Future<void> _onVerifyLocation() async {
    if (_isBusy) {
      return;
    }

    // Owner journey mode: simulate a successful local verification without
    // requesting permission, reading GPS, classifying boundaries, or calling
    // any backend. Normal production path below remains unchanged.
    if (widget.ownerJourneyMode) {
      setState(() {
        _isBusy = false;
        _uiState = LocationVerificationUiState.confirmedGood;
        _accuracyMeters = _ownerJourneyDisplayAccuracyMeters;
        _resultContainment = PointContainment.inside;
        _changeCityVisible = false;
      });
      return;
    }

    setState(() {
      _isBusy = true;
      _uiState = LocationVerificationUiState.requestingPermission;
      _accuracyMeters = null;
      _resultContainment = null;
      _changeCityVisible = false;
    });

    try {
      final ForegroundLocationState permission = await widget.permissionService
          .ensureForegroundPermission();
      if (!mounted) {
        return;
      }

      if (permission != ForegroundLocationState.granted) {
        setState(() {
          _uiState = _mapPermissionState(permission);
          _changeCityVisible = false;
        });
        return;
      }

      setState(() {
        _uiState = LocationVerificationUiState.readingAndClassifying;
      });

      try {
        final CityBoundaryClassificationResult result = await widget
            .classificationBridge
            .readAndClassifyOnce(selectedCity: widget.selectedCity);
        if (!mounted) {
          return;
        }
        setState(() {
          _applySuccessResult(result);
        });
      } on ForegroundCityClassificationBridgeException catch (error) {
        if (!mounted) {
          return;
        }
        if (error.failure == ForegroundCityClassificationBridgeFailure.busy) {
          // Do not surface busy as an error, do not reset to idle, and do not
          // clear progress UI. Preserve requestingPermission /
          // readingAndClassifying; finally clears _isBusy.
          return;
        }
        setState(() {
          _applyBridgeFailure(error.failure);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  LocationVerificationUiState _mapPermissionState(
    ForegroundLocationState permission,
  ) {
    switch (permission) {
      case ForegroundLocationState.serviceDisabled:
        return LocationVerificationUiState.servicesDisabled;
      case ForegroundLocationState.denied:
        return LocationVerificationUiState.permissionDenied;
      case ForegroundLocationState.permanentlyDenied:
        return LocationVerificationUiState.permissionPermanentlyDenied;
      case ForegroundLocationState.granted:
        return LocationVerificationUiState.idle;
    }
  }

  void _applySuccessResult(CityBoundaryClassificationResult result) {
    // Retain only safe UI fields — never classifiedAt, coordinates, or the
    // full result object beyond this method.
    final PointContainment containment = result.containment;
    final int accuracyMeters = result.accuracyMeters;
    _accuracyMeters = accuracyMeters;
    _resultContainment = containment;

    final bool good =
        accuracyMeters <= ForegroundAccuracyThresholds.goodMaxMeters;
    final bool limited =
        accuracyMeters > ForegroundAccuracyThresholds.goodMaxMeters &&
        accuracyMeters <= ForegroundAccuracyThresholds.limitedMaxMeters;

    if (containment == PointContainment.boundary) {
      _uiState = LocationVerificationUiState.uncertain;
      _changeCityVisible = true;
      return;
    }

    if (containment == PointContainment.inside) {
      if (good) {
        _uiState = LocationVerificationUiState.confirmedGood;
        _changeCityVisible = false;
        return;
      }
      if (limited) {
        _uiState = LocationVerificationUiState.confirmedLimited;
        _changeCityVisible = false;
        return;
      }
      // inside + insufficient
      _uiState = LocationVerificationUiState.uncertain;
      _changeCityVisible = false;
      return;
    }

    // outside
    if (good || limited) {
      _uiState = LocationVerificationUiState.outsideSelectedCity;
      _changeCityVisible = true;
      return;
    }
    // outside + insufficient → uncertain (not definitive outside)
    _uiState = LocationVerificationUiState.uncertain;
    _changeCityVisible = true;
  }

  void _applyBridgeFailure(ForegroundCityClassificationBridgeFailure failure) {
    _accuracyMeters = null;
    _resultContainment = null;
    switch (failure) {
      case ForegroundCityClassificationBridgeFailure.locationServicesDisabled:
        _uiState = LocationVerificationUiState.servicesDisabled;
        _changeCityVisible = false;
      case ForegroundCityClassificationBridgeFailure.permissionDenied:
        _uiState = LocationVerificationUiState.permissionDenied;
        _changeCityVisible = false;
      case ForegroundCityClassificationBridgeFailure
          .permissionPermanentlyDenied:
        _uiState = LocationVerificationUiState.permissionPermanentlyDenied;
        _changeCityVisible = false;
      case ForegroundCityClassificationBridgeFailure.timeout:
        _uiState = LocationVerificationUiState.timeout;
        _changeCityVisible = true;
      case ForegroundCityClassificationBridgeFailure.positionReadFailed ||
          ForegroundCityClassificationBridgeFailure.boundaryAssetFailed ||
          ForegroundCityClassificationBridgeFailure.classificationFailed ||
          ForegroundCityClassificationBridgeFailure.unsupportedCity:
        _uiState = LocationVerificationUiState.technicalError;
        _changeCityVisible = true;
      case ForegroundCityClassificationBridgeFailure.busy:
        // Handled by caller; should not reach here.
        _uiState = LocationVerificationUiState.idle;
        _changeCityVisible = false;
    }
  }

  Future<void> _onOpenAppSettings() async {
    await widget.permissionService.openAppSettings();
  }

  Future<void> _onOpenLocationSettings() async {
    await widget.permissionService.openLocationSettings();
  }

  void _onChangeCity() {
    Navigator.of(context).pop();
  }

  void _onNotNow() {
    Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
  }

  void _onBack() {
    Navigator.of(context).pop();
  }

  _StatusContent? _statusContent(_LocationConfirmationCopy copy) {
    final String city = _cityDisplayName;
    final int? accuracy = _accuracyMeters;

    switch (_uiState) {
      case LocationVerificationUiState.idle:
        return null;
      case LocationVerificationUiState.requestingPermission:
        return _StatusContent(body: copy.checkingPermission);
      case LocationVerificationUiState.readingAndClassifying:
        return _StatusContent(body: copy.readingAndClassifying);
      case LocationVerificationUiState.confirmedGood:
        return _StatusContent(
          title: copy.confirmedTitle,
          body: copy.confirmedGoodBody(city, accuracy!),
        );
      case LocationVerificationUiState.confirmedLimited:
        return _StatusContent(
          title: copy.confirmedTitle,
          body: copy.confirmedLimitedBody(city, accuracy!),
          guidance: copy.limitedRetryGuidance,
        );
      case LocationVerificationUiState.uncertain:
        if (_resultContainment == PointContainment.inside) {
          return _StatusContent(
            title: copy.notConfirmedTitle,
            body: copy.insideInsufficientBody(city),
          );
        }
        if (_resultContainment == PointContainment.outside) {
          return _StatusContent(
            title: copy.notConfirmedTitle,
            body: copy.outsideInsufficientBody(city),
          );
        }
        return _StatusContent(
          title: copy.notConfirmedTitle,
          body: copy.boundaryUncertainBody(city),
        );
      case LocationVerificationUiState.outsideSelectedCity:
        final bool limited =
            accuracy != null &&
            accuracy > ForegroundAccuracyThresholds.goodMaxMeters &&
            accuracy <= ForegroundAccuracyThresholds.limitedMaxMeters;
        return _StatusContent(
          title: copy.mismatchTitle,
          body: limited
              ? copy.outsideLimitedBody(city, accuracy)
              : copy.outsideGoodBody(city),
        );
      case LocationVerificationUiState.servicesDisabled:
        return _StatusContent(
          title: copy.servicesDisabledTitle,
          body: copy.servicesDisabledBody,
        );
      case LocationVerificationUiState.permissionDenied:
        return _StatusContent(
          title: copy.permissionDeniedTitle,
          body: copy.permissionDeniedBody,
        );
      case LocationVerificationUiState.permissionPermanentlyDenied:
        return _StatusContent(
          title: copy.permissionPermanentlyDeniedTitle,
          body: copy.permissionPermanentlyDeniedBody,
        );
      case LocationVerificationUiState.timeout:
        return _StatusContent(title: copy.timeoutTitle, body: copy.timeoutBody);
      case LocationVerificationUiState.technicalError:
        return _StatusContent(
          title: copy.technicalErrorTitle,
          body: copy.technicalErrorBody,
        );
    }
  }

  String? _primaryLabel(_LocationConfirmationCopy copy) {
    if (_isProgressState) {
      // While in-flight, the filled button shows a spinner (no label).
      // After settle without leaving progress (bridge busy), keep progress
      // copy and allow a coherent re-verify without flashing idle.
      return _isBusy ? null : copy.primaryIdle;
    }
    switch (_uiState) {
      case LocationVerificationUiState.idle:
        return copy.primaryIdle;
      case LocationVerificationUiState.confirmedGood:
        return null;
      case LocationVerificationUiState.confirmedLimited:
      case LocationVerificationUiState.uncertain:
      case LocationVerificationUiState.outsideSelectedCity:
      case LocationVerificationUiState.permissionDenied:
      case LocationVerificationUiState.timeout:
      case LocationVerificationUiState.technicalError:
        return copy.tryAgain;
      case LocationVerificationUiState.servicesDisabled:
        return copy.openLocationSettings;
      case LocationVerificationUiState.permissionPermanentlyDenied:
        return copy.openAppSettings;
      case LocationVerificationUiState.requestingPermission:
      case LocationVerificationUiState.readingAndClassifying:
        return null;
    }
  }

  VoidCallback? _primaryCallback() {
    if (_isBusy) {
      return null;
    }
    switch (_uiState) {
      case LocationVerificationUiState.confirmedGood:
        return null;
      case LocationVerificationUiState.servicesDisabled:
        return _onOpenLocationSettings;
      case LocationVerificationUiState.permissionPermanentlyDenied:
        return _onOpenAppSettings;
      case LocationVerificationUiState.idle:
      case LocationVerificationUiState.confirmedLimited:
      case LocationVerificationUiState.uncertain:
      case LocationVerificationUiState.outsideSelectedCity:
      case LocationVerificationUiState.permissionDenied:
      case LocationVerificationUiState.timeout:
      case LocationVerificationUiState.technicalError:
      case LocationVerificationUiState.requestingPermission:
      case LocationVerificationUiState.readingAndClassifying:
        // Progress cases are only actionable after settle (e.g. bridge busy).
        return _onVerifyLocation;
    }
  }

  bool get _showPrimaryButton =>
      _isProgressState || _primaryLabel(_copy) != null;

  /// Eligible local-access success states for the Feed V1 prototype entry.
  ///
  /// Does not imply paid access, entitlement persistence, or authentication.
  bool get _canContinueToTown =>
      _uiState == LocationVerificationUiState.confirmedGood ||
      _uiState == LocationVerificationUiState.confirmedLimited;

  void _onContinueToTown() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TownFeedScreen(
          selectedCountry: widget.selectedCountry,
          selectedCity: widget.selectedCity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _LocationConfirmationCopy copy = _copy;
    final _StatusContent? status = _statusContent(copy);
    final String? primaryLabel = _primaryLabel(copy);
    final bool notNowEnabled = !_isBusy;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: _onBack,
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                              ),
                              color: _white,
                              iconSize: 18,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              tooltip: copy.backTooltip,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            copy.title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              height: 1.15,
                              color: _white,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            copy.introduction(_cityDisplayName),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              letterSpacing: 0.1,
                              color: _lightGrey,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _InfoCard(copy: copy),
                          if (status != null) ...[
                            const SizedBox(height: 24),
                            if (status.title != null) ...[
                              Text(
                                status.title!,
                                key: const Key('location_result_title'),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                  letterSpacing: 0.05,
                                  color: _white,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            Text(
                              status.body,
                              key: const Key('location_permission_status'),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.45,
                                letterSpacing: 0.05,
                                color: _white,
                              ),
                            ),
                            if (status.guidance != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                status.guidance!,
                                key: const Key('location_optional_guidance'),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.45,
                                  letterSpacing: 0.05,
                                  color: _lightGrey,
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_canContinueToTown && !_isBusy) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        key: const Key('continue_to_town'),
                        onPressed: _onContinueToTown,
                        style: FilledButton.styleFrom(
                          backgroundColor: _gold,
                          foregroundColor: _background,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        child: Text(copy.continueToTown),
                      ),
                    ),
                  ],
                  if (_showPrimaryButton) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        key: const Key('location_primary_action'),
                        onPressed: _primaryCallback(),
                        style: FilledButton.styleFrom(
                          backgroundColor: _canContinueToTown
                              ? const Color(0xFF2A2A2A)
                              : _gold,
                          foregroundColor: _canContinueToTown
                              ? _white
                              : _background,
                          disabledBackgroundColor: _gold.withValues(
                            alpha: 0.45,
                          ),
                          disabledForegroundColor: _background,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        child: _isBusy
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: _background,
                                ),
                              )
                            : Text(primaryLabel ?? ''),
                      ),
                    ),
                  ],
                  if (_changeCityVisible && !_isBusy) ...[
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        key: const Key('location_change_city'),
                        onPressed: _onChangeCity,
                        style: TextButton.styleFrom(
                          foregroundColor: _gold,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                        child: Text(copy.changeCity),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      key: const Key('location_not_now'),
                      onPressed: notNowEnabled ? _onNotNow : null,
                      style: TextButton.styleFrom(
                        foregroundColor: _gold,
                        disabledForegroundColor: _gold.withValues(alpha: 0.4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                      child: Text(copy.notNow),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusContent {
  const _StatusContent({this.title, required this.body, this.guidance});

  final String? title;
  final String body;
  final String? guidance;
}

class _LocationConfirmationCopy {
  const _LocationConfirmationCopy({
    required this.title,
    required this.introductionTemplate,
    required this.cardTitle,
    required this.cardText,
    required this.point1,
    required this.point2,
    required this.point3,
    required this.primaryIdle,
    required this.notNow,
    required this.backTooltip,
    required this.changeCity,
    required this.tryAgain,
    required this.openAppSettings,
    required this.openLocationSettings,
    required this.checkingPermission,
    required this.readingAndClassifying,
    required this.confirmedTitle,
    required this.confirmedGoodBodyTemplate,
    required this.confirmedLimitedBodyTemplate,
    required this.limitedRetryGuidance,
    required this.notConfirmedTitle,
    required this.insideInsufficientBodyTemplate,
    required this.mismatchTitle,
    required this.outsideGoodBodyTemplate,
    required this.outsideLimitedBodyTemplate,
    required this.outsideInsufficientBodyTemplate,
    required this.boundaryUncertainBodyTemplate,
    required this.servicesDisabledTitle,
    required this.servicesDisabledBody,
    required this.permissionDeniedTitle,
    required this.permissionDeniedBody,
    required this.permissionPermanentlyDeniedTitle,
    required this.permissionPermanentlyDeniedBody,
    required this.timeoutTitle,
    required this.timeoutBody,
    required this.technicalErrorTitle,
    required this.technicalErrorBody,
    required this.continueToTown,
  });

  const _LocationConfirmationCopy.italian()
    : title = 'Conferma la tua posizione',
      introductionTemplate =
          'Per mantenere TOWN una comunità reale e locale, verifichiamo che ti trovi a {city}.',
      cardTitle = 'Perché è richiesta la posizione?',
      cardText = 'Ci aiuta a mantenere TOWN locale, sicuro e affidabile.',
      point1 =
          'Usiamo la tua posizione solo una volta, in primo piano, per questa verifica.',
      point2 = 'Non memorizziamo né trasmettiamo le tue coordinate.',
      point3 = 'Non monitoriamo la tua posizione in background.',
      primaryIdle = 'Verifica posizione',
      notNow = 'Non ora',
      backTooltip = 'Indietro',
      changeCity = 'Cambia città',
      tryAgain = 'Riprova',
      openAppSettings = 'Apri le impostazioni dell’app',
      openLocationSettings = 'Apri le impostazioni di localizzazione',
      checkingPermission = 'Controllo dell’autorizzazione…',
      readingAndClassifying = 'Verifica della posizione in corso…',
      confirmedTitle = 'Posizione verificata',
      confirmedGoodBodyTemplate =
          'La verifica indica che ti trovi a {city}. Precisione: circa {accuracy} m.',
      confirmedLimitedBodyTemplate =
          'La verifica indica che ti trovi a {city}. Precisione limitata: circa {accuracy} m.',
      limitedRetryGuidance = 'Puoi riprovare per una misura più precisa.',
      notConfirmedTitle = 'Posizione non confermata',
      insideInsufficientBodyTemplate =
          'La precisione non è sufficiente per confermare che ti trovi a {city}. Riprova in uno spazio aperto.',
      mismatchTitle = 'Posizione non corrispondente',
      outsideGoodBodyTemplate =
          'La lettura non corrisponde a {city}. Puoi riprovare o cambiare città.',
      outsideLimitedBodyTemplate =
          'La lettura non corrisponde a {city}. Precisione limitata: circa {accuracy} m. Puoi riprovare o cambiare città.',
      outsideInsufficientBodyTemplate =
          'Non possiamo confermare con certezza la tua posizione rispetto a {city}. Riprova in uno spazio aperto.',
      boundaryUncertainBodyTemplate =
          'Non siamo riusciti a confermare con certezza che ti trovi a {city}. Riprova.',
      servicesDisabledTitle = 'Localizzazione disattivata',
      servicesDisabledBody =
          'Attiva i servizi di localizzazione per completare la verifica.',
      permissionDeniedTitle = 'Autorizzazione richiesta',
      permissionDeniedBody =
          'TOWN usa la posizione solo per questa verifica una tantum.',
      permissionPermanentlyDeniedTitle = 'Autorizzazione necessaria',
      permissionPermanentlyDeniedBody =
          'Abilita l’accesso alla posizione nelle impostazioni dell’app.',
      timeoutTitle = 'Tempo scaduto',
      timeoutBody =
          'Non siamo riusciti a rilevare la posizione in tempo. Riprova.',
      technicalErrorTitle = 'Qualcosa non ha funzionato',
      technicalErrorBody =
          'Non siamo riusciti a completare la verifica. Riprova.',
      continueToTown = 'Continue to TOWN';

  const _LocationConfirmationCopy.german()
    : title = 'Bestätige deinen Standort',
      introductionTemplate =
          'Damit TOWN eine echte lokale Gemeinschaft bleibt, prüfen wir, ob du dich in {city} befindest.',
      cardTitle = 'Warum wird dein Standort benötigt?',
      cardText = 'Damit TOWN lokal, sicher und vertrauenswürdig bleibt.',
      point1 =
          'Wir nutzen deinen Standort nur einmalig im Vordergrund für diese Prüfung.',
      point2 = 'Wir speichern und übermitteln deine Koordinaten nicht.',
      point3 = 'Wir verfolgen deinen Standort nicht im Hintergrund.',
      primaryIdle = 'Standort prüfen',
      notNow = 'Nicht jetzt',
      backTooltip = 'Zurück',
      changeCity = 'Stadt ändern',
      tryAgain = 'Erneut versuchen',
      openAppSettings = 'App-Einstellungen öffnen',
      openLocationSettings = 'Ortungseinstellungen öffnen',
      checkingPermission = 'Berechtigung wird geprüft…',
      readingAndClassifying = 'Standort wird geprüft…',
      confirmedTitle = 'Standort bestätigt',
      confirmedGoodBodyTemplate =
          'Die Prüfung zeigt, dass du dich in {city} befindest. Ungefähre Genauigkeit: {accuracy} m.',
      confirmedLimitedBodyTemplate =
          'Die Prüfung zeigt, dass du dich in {city} befindest. Eingeschränkte Genauigkeit: ungefähr {accuracy} m.',
      limitedRetryGuidance =
          'Du kannst es für eine präzisere Messung erneut versuchen.',
      notConfirmedTitle = 'Standort nicht bestätigt',
      insideInsufficientBodyTemplate =
          'Die Genauigkeit reicht nicht aus, um zu bestätigen, dass du dich in {city} befindest. Versuche es erneut im Freien.',
      mismatchTitle = 'Standort stimmt nicht überein',
      outsideGoodBodyTemplate =
          'Die Standortprüfung stimmt nicht mit {city} überein. Du kannst es erneut versuchen oder die Stadt ändern.',
      outsideLimitedBodyTemplate =
          'Die Standortprüfung stimmt nicht mit {city} überein. Die Genauigkeit ist eingeschränkt: ungefähr {accuracy} m. Du kannst es erneut versuchen oder die Stadt ändern.',
      outsideInsufficientBodyTemplate =
          'Wir können deine Position im Vergleich zu {city} nicht sicher bestätigen. Versuche es erneut im Freien.',
      boundaryUncertainBodyTemplate =
          'Wir konnten nicht sicher bestätigen, dass du dich in {city} befindest. Versuche es erneut.',
      servicesDisabledTitle = 'Ortung deaktiviert',
      servicesDisabledBody =
          'Aktiviere die Ortungsdienste, um die Prüfung abzuschließen.',
      permissionDeniedTitle = 'Berechtigung erforderlich',
      permissionDeniedBody =
          'TOWN nutzt den Standort nur für diese einmalige Prüfung.',
      permissionPermanentlyDeniedTitle = 'Berechtigung erforderlich',
      permissionPermanentlyDeniedBody =
          'Aktiviere den Standortzugriff in den App-Einstellungen.',
      timeoutTitle = 'Zeitüberschreitung',
      timeoutBody =
          'Der Standort konnte nicht rechtzeitig ermittelt werden. Versuche es erneut.',
      technicalErrorTitle = 'Etwas ist schiefgelaufen',
      technicalErrorBody =
          'Die Prüfung konnte nicht abgeschlossen werden. Versuche es erneut.',
      continueToTown = 'Continue to TOWN';

  final String title;
  final String introductionTemplate;
  final String cardTitle;
  final String cardText;
  final String point1;
  final String point2;
  final String point3;
  final String primaryIdle;
  final String notNow;
  final String backTooltip;
  final String changeCity;
  final String tryAgain;
  final String openAppSettings;
  final String openLocationSettings;
  final String checkingPermission;
  final String readingAndClassifying;
  final String confirmedTitle;
  final String confirmedGoodBodyTemplate;
  final String confirmedLimitedBodyTemplate;
  final String limitedRetryGuidance;
  final String notConfirmedTitle;
  final String insideInsufficientBodyTemplate;
  final String mismatchTitle;
  final String outsideGoodBodyTemplate;
  final String outsideLimitedBodyTemplate;
  final String outsideInsufficientBodyTemplate;
  final String boundaryUncertainBodyTemplate;
  final String servicesDisabledTitle;
  final String servicesDisabledBody;
  final String permissionDeniedTitle;
  final String permissionDeniedBody;
  final String permissionPermanentlyDeniedTitle;
  final String permissionPermanentlyDeniedBody;
  final String timeoutTitle;
  final String timeoutBody;
  final String technicalErrorTitle;
  final String technicalErrorBody;
  final String continueToTown;

  String introduction(String city) =>
      introductionTemplate.replaceAll('{city}', city);

  String confirmedGoodBody(String city, int accuracyMeters) =>
      confirmedGoodBodyTemplate
          .replaceAll('{city}', city)
          .replaceAll('{accuracy}', '$accuracyMeters');

  String confirmedLimitedBody(String city, int accuracyMeters) =>
      confirmedLimitedBodyTemplate
          .replaceAll('{city}', city)
          .replaceAll('{accuracy}', '$accuracyMeters');

  String insideInsufficientBody(String city) =>
      insideInsufficientBodyTemplate.replaceAll('{city}', city);

  String outsideGoodBody(String city) =>
      outsideGoodBodyTemplate.replaceAll('{city}', city);

  String outsideLimitedBody(String city, int accuracyMeters) =>
      outsideLimitedBodyTemplate
          .replaceAll('{city}', city)
          .replaceAll('{accuracy}', '$accuracyMeters');

  String outsideInsufficientBody(String city) =>
      outsideInsufficientBodyTemplate.replaceAll('{city}', city);

  String boundaryUncertainBody(String city) =>
      boundaryUncertainBodyTemplate.replaceAll('{city}', city);
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.copy});

  final _LocationConfirmationCopy copy;

  static const Color _card = Color(0xFF1A1A1A);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _lightGrey = Color(0xFFB0B0B0);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _LocationIconBadge(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        copy.cardTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.05,
                          height: 1.3,
                          color: _white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        copy.cardText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          letterSpacing: 0.05,
                          color: _lightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _PrivacyPoint(text: copy.point1),
            const SizedBox(height: 16),
            _PrivacyPoint(text: copy.point2),
            const SizedBox(height: 16),
            _PrivacyPoint(text: copy.point3),
          ],
        ),
      ),
    );
  }
}

class _LocationIconBadge extends StatelessWidget {
  const _LocationIconBadge();

  static const Color _gold = Color(0xFFE8C547);
  static const Color _iconWell = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _iconWell,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _gold.withValues(alpha: 0.35), width: 1),
      ),
      child: const Icon(Icons.add_location_alt_rounded, color: _gold, size: 22),
    );
  }
}

class _PrivacyPoint extends StatelessWidget {
  const _PrivacyPoint({required this.text});

  final String text;

  static const Color _white = Color(0xFFFFFFFF);
  static const Color _gold = Color(0xFFE8C547);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(Icons.remove_red_eye_outlined, color: _gold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.45,
              letterSpacing: 0.05,
              color: _white,
            ),
          ),
        ),
      ],
    );
  }
}
