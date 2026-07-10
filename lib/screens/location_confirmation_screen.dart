import 'package:flutter/material.dart';

/// Location Confirmation rationale screen.
///
/// Explains why location is required before any native permission request.
/// Visual/navigational prototype only — no GPS, permissions, or maps.
class LocationConfirmationScreen extends StatelessWidget {
  const LocationConfirmationScreen({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
  });

  /// Canonical country from Select City (`Italy` or `Germany`).
  final String selectedCountry;

  /// Canonical city id (`Milano` or `Munich`).
  final String selectedCity;

  static const Color _background = Color(0xFF000000);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _lightGrey = Color(0xFFB0B0B0);
  static const Color _gold = Color(0xFFE8C547);

  static const double _maxContentWidth = 410;

  _LocationConfirmationCopy get _copy {
    assert(
      (selectedCountry == 'Italy' && selectedCity == 'Milano') ||
          (selectedCountry == 'Germany' && selectedCity == 'Munich'),
      'Unsupported country/city pair: $selectedCountry / $selectedCity',
    );
    if (selectedCountry == 'Italy') {
      return const _LocationConfirmationCopy.italian();
    }
    return const _LocationConfirmationCopy.german();
  }

  @override
  Widget build(BuildContext context) {
    final _LocationConfirmationCopy copy = _copy;

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
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      // Visual only — no permission request or navigation.
                      onPressed: () {},
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
                      child: Text(copy.primaryButton),
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
        secondaryAction = 'Non ora';

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
        secondaryAction = 'Nicht jetzt';

  final String title;
  final String introduction;
  final String cardTitle;
  final String cardText;
  final String point1;
  final String point2;
  final String primaryButton;
  final String secondaryAction;
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
