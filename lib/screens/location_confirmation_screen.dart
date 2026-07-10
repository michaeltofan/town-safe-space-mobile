import 'package:flutter/material.dart';

import '../services/foreground_position_reader.dart';
import '../services/location_permission_service.dart';

/// Location Confirmation rationale screen.
///
/// Checks/requests foreground permission, then performs exactly one
/// foreground position read. Does not verify city membership, store
/// coordinates, or navigate away.
class LocationConfirmationScreen extends StatefulWidget {
  const LocationConfirmationScreen({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
    this.permissionService = const LocationPermissionService(),
    this.positionReader = const ForegroundPositionReader(),
  });

  /// Canonical country from Select City (`Italy` or `Germany`).
  final String selectedCountry;

  /// Canonical city id (`Milano` or `Munich`).
  final String selectedCity;

  /// Injectable permission helper for tests.
  final LocationPermissionService permissionService;

  /// Injectable one-time position reader for tests.
  final ForegroundPositionReader positionReader;

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

  ForegroundLocationState? _permissionState;
  ForegroundPositionReadResult? _readResult;
  ForegroundPositionReadState _flowState = ForegroundPositionReadState.idle;
  bool _isBusy = false;

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

  Future<void> _onConfirmPosition() async {
    if (_isBusy) {
      return;
    }
    setState(() {
      _isBusy = true;
      _flowState = ForegroundPositionReadState.requestingPermission;
      _permissionState = null;
      _readResult = null;
    });

    try {
      final ForegroundLocationState permission =
          await widget.permissionService.ensureForegroundPermission();
      if (!mounted) {
        return;
      }

      if (permission != ForegroundLocationState.granted) {
        setState(() {
          _permissionState = permission;
          _flowState = ForegroundPositionReadState.idle;
        });
        return;
      }

      setState(() {
        _permissionState = ForegroundLocationState.granted;
        _flowState = ForegroundPositionReadState.reading;
      });

      final ForegroundPositionReadResult result =
          await widget.positionReader.readOnce();
      if (!mounted) {
        return;
      }

      // Map mid-read service/permission loss onto existing permission UI.
      if (result.state == ForegroundPositionReadState.serviceDisabled) {
        setState(() {
          _permissionState = ForegroundLocationState.serviceDisabled;
          _readResult = null;
          _flowState = ForegroundPositionReadState.idle;
        });
        return;
      }
      if (result.state == ForegroundPositionReadState.permissionLost) {
        setState(() {
          _permissionState = ForegroundLocationState.denied;
          _readResult = null;
          _flowState = ForegroundPositionReadState.idle;
        });
        return;
      }

      setState(() {
        _readResult = result;
        _flowState = result.state;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _onOpenAppSettings() async {
    await widget.permissionService.openAppSettings();
  }

  Future<void> _onOpenLocationSettings() async {
    await widget.permissionService.openLocationSettings();
  }

  List<String> _statusLines(_LocationConfirmationCopy copy) {
    if (_flowState == ForegroundPositionReadState.reading) {
      return <String>[copy.reading];
    }

    final ForegroundPositionReadResult? read = _readResult;
    if (read != null) {
      switch (read.state) {
        case ForegroundPositionReadState.successGood:
          return <String>[
            copy.successGood(read.accuracyMeters!),
            copy.notVerified,
          ];
        case ForegroundPositionReadState.successLimited:
          return <String>[
            copy.successLimited(read.accuracyMeters!),
            copy.notVerified,
          ];
        case ForegroundPositionReadState.insufficientAccuracy:
          return <String>[
            copy.insufficient(read.accuracyMeters!),
            copy.notVerified,
          ];
        case ForegroundPositionReadState.timeout:
          return <String>[copy.timeout];
        case ForegroundPositionReadState.error:
          return <String>[copy.genericError];
        case ForegroundPositionReadState.idle:
        case ForegroundPositionReadState.requestingPermission:
        case ForegroundPositionReadState.reading:
        case ForegroundPositionReadState.permissionLost:
        case ForegroundPositionReadState.serviceDisabled:
          break;
      }
    }

    switch (_permissionState) {
      case null:
        return const <String>[];
      case ForegroundLocationState.serviceDisabled:
        return <String>[copy.serviceDisabled];
      case ForegroundLocationState.denied:
        return <String>[copy.denied];
      case ForegroundLocationState.permanentlyDenied:
        return <String>[copy.permanentlyDenied];
      case ForegroundLocationState.granted:
        // Granted alone is transitional; reading follows immediately.
        return const <String>[];
    }
  }

  bool get _showPermissionTryAgain =>
      _permissionState == ForegroundLocationState.denied &&
      _readResult == null &&
      _flowState == ForegroundPositionReadState.idle;

  bool get _showOpenSettings =>
      _permissionState == ForegroundLocationState.permanentlyDenied &&
      _readResult == null;

  bool get _showOpenLocationSettings =>
      _permissionState == ForegroundLocationState.serviceDisabled &&
      _readResult == null;

  bool get _showReadRetry =>
      _readResult != null && (_readResult!.canRetry);

  @override
  Widget build(BuildContext context) {
    final _LocationConfirmationCopy copy = _copy;
    final List<String> statusLines = _statusLines(copy);
    final bool showStatus = statusLines.isNotEmpty ||
        _flowState == ForegroundPositionReadState.reading;

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
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded),
                              color: _white,
                              iconSize: 18,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              tooltip: 'Back',
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
                            copy.introduction,
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
                        ],
                      ),
                    ),
                  ),
                  if (showStatus) ...[
                    const SizedBox(height: 12),
                    ...statusLines.map(
                      (String line) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          line,
                          key: statusLines.first == line
                              ? const Key('location_permission_status')
                              : null,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                            letterSpacing: 0.05,
                            color: _white,
                          ),
                        ),
                      ),
                    ),
                    if (_showPermissionTryAgain || _showReadRetry) ...[
                      const SizedBox(height: 2),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          key: const Key('location_try_again'),
                          onPressed: _isBusy ? null : _onConfirmPosition,
                          style: TextButton.styleFrom(
                            foregroundColor: _gold,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(copy.tryAgain),
                        ),
                      ),
                    ],
                    if (_showOpenSettings) ...[
                      const SizedBox(height: 2),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          key: const Key('location_open_settings'),
                          onPressed: _onOpenAppSettings,
                          style: TextButton.styleFrom(
                            foregroundColor: _gold,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(copy.openSettings),
                        ),
                      ),
                    ],
                    if (_showOpenLocationSettings) ...[
                      const SizedBox(height: 2),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          key: const Key('location_open_location_settings'),
                          onPressed: _onOpenLocationSettings,
                          style: TextButton.styleFrom(
                            foregroundColor: _gold,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(copy.openLocationSettings),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: _isBusy ? null : _onConfirmPosition,
                      style: FilledButton.styleFrom(
                        backgroundColor: _gold,
                        foregroundColor: _background,
                        disabledBackgroundColor: _gold.withValues(alpha: 0.45),
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
                          : Text(copy.primaryButton),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      // Visual only — no account or membership flow.
                      onPressed: () {},
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
                      child: Text(copy.secondaryAction),
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

class _LocationConfirmationCopy {
  const _LocationConfirmationCopy({
    required this.title,
    required this.introduction,
    required this.cardTitle,
    required this.cardText,
    required this.point1,
    required this.point2,
    required this.primaryButton,
    required this.secondaryAction,
    required this.serviceDisabled,
    required this.denied,
    required this.permanentlyDenied,
    required this.granted,
    required this.tryAgain,
    required this.openSettings,
    required this.openLocationSettings,
    required this.reading,
    required this.successGoodTemplate,
    required this.successLimitedTemplate,
    required this.insufficientTemplate,
    required this.notVerified,
    required this.timeout,
    required this.genericError,
  });

  const _LocationConfirmationCopy.italian()
      : title = 'Conferma la tua posizione',
        introduction =
            'Per mantenere TOWN una comunità reale e locale, dobbiamo verificare che ti trovi a Milano.',
        cardTitle = 'Perché è richiesta la posizione?',
        cardText = 'Ci aiuta a mantenere TOWN locale, sicuro e affidabile.',
        point1 =
            'Utilizziamo la tua posizione solo durante la registrazione.',
        point2 = 'Non monitoriamo la tua posizione in background.',
        primaryButton = 'Conferma posizione',
        secondaryAction = 'Non ora',
        serviceDisabled = 'Servizi di localizzazione disattivati.',
        denied = 'Autorizzazione alla posizione negata.',
        permanentlyDenied =
            'Autorizzazione negata in modo permanente. Apri le impostazioni per modificarla.',
        granted = 'Autorizzazione alla posizione concessa.',
        tryAgain = 'Riprova',
        openSettings = 'Apri le impostazioni',
        openLocationSettings = 'Apri impostazioni di localizzazione',
        reading = 'Lettura della posizione in corso…',
        successGoodTemplate =
            'Posizione rilevata con una precisione di circa {accuracy} m.',
        successLimitedTemplate =
            'Posizione rilevata, ma la precisione è limitata: circa {accuracy} m.',
        insufficientTemplate =
            'La posizione è stata rilevata con una precisione insufficiente: circa {accuracy} m. Riprova in uno spazio aperto.',
        notVerified = 'La città non è ancora stata verificata.',
        timeout = 'Impossibile rilevare la posizione in tempo. Riprova.',
        genericError =
            'Non è stato possibile rilevare la posizione. Riprova.';

  const _LocationConfirmationCopy.german()
      : title = 'Bestätige deinen Standort',
        introduction =
            'Damit TOWN eine echte lokale Gemeinschaft bleibt, müssen wir bestätigen, dass du dich in München befindest.',
        cardTitle = 'Warum wird dein Standort benötigt?',
        cardText = 'Damit TOWN lokal, sicher und vertrauenswürdig bleibt.',
        point1 =
            'Wir verwenden deinen Standort nur während der Registrierung.',
        point2 =
            'Wir verfolgen deinen Standort nicht im Hintergrund.',
        primaryButton = 'Standort bestätigen',
        secondaryAction = 'Nicht jetzt',
        serviceDisabled = 'Ortungsdienste sind deaktiviert.',
        denied = 'Standortberechtigung wurde verweigert.',
        permanentlyDenied =
            'Standortberechtigung wurde dauerhaft verweigert. Öffne die Einstellungen, um sie zu ändern.',
        granted = 'Standortberechtigung wurde erteilt.',
        tryAgain = 'Erneut versuchen',
        openSettings = 'Einstellungen öffnen',
        openLocationSettings = 'Ortungseinstellungen öffnen',
        reading = 'Standort wird ermittelt…',
        successGoodTemplate =
            'Standort mit einer Genauigkeit von ungefähr {accuracy} m ermittelt.',
        successLimitedTemplate =
            'Standort ermittelt, aber die Genauigkeit ist eingeschränkt: ungefähr {accuracy} m.',
        insufficientTemplate =
            'Der Standort wurde nur mit unzureichender Genauigkeit ermittelt: ungefähr {accuracy} m. Versuche es erneut im Freien.',
        notVerified = 'Die Stadt wurde noch nicht verifiziert.',
        timeout =
            'Der Standort konnte nicht rechtzeitig ermittelt werden. Versuche es erneut.',
        genericError =
            'Der Standort konnte nicht ermittelt werden. Versuche es erneut.';

  final String title;
  final String introduction;
  final String cardTitle;
  final String cardText;
  final String point1;
  final String point2;
  final String primaryButton;
  final String secondaryAction;
  final String serviceDisabled;
  final String denied;
  final String permanentlyDenied;
  final String granted;
  final String tryAgain;
  final String openSettings;
  final String openLocationSettings;
  final String reading;
  final String successGoodTemplate;
  final String successLimitedTemplate;
  final String insufficientTemplate;
  final String notVerified;
  final String timeout;
  final String genericError;

  String successGood(int accuracyMeters) =>
      successGoodTemplate.replaceAll('{accuracy}', '$accuracyMeters');

  String successLimited(int accuracyMeters) =>
      successLimitedTemplate.replaceAll('{accuracy}', '$accuracyMeters');

  String insufficient(int accuracyMeters) =>
      insufficientTemplate.replaceAll('{accuracy}', '$accuracyMeters');
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
      child: const Icon(
        Icons.add_location_alt_rounded,
        color: _gold,
        size: 22,
      ),
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
          child: Icon(
            Icons.remove_red_eye_outlined,
            color: _gold,
            size: 18,
          ),
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
