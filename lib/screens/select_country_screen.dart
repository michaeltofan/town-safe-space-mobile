import 'package:flutter/material.dart';

/// Screen 02A — Select Country.
///
/// Visual prototype: single-select country choice before city selection.
/// Continue does not navigate yet (Select City is not built).
class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  static const Color _background = Color(0xFF000000);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _lightGrey = Color(0xFFB0B0B0);
  static const Color _gold = Color(0xFFE8C547);
  static const Color _disabledButton = Color(0xFF2A2A2A);
  static const Color _disabledLabel = Color(0xFF6B6B6B);

  static const double _maxContentWidth = 410;

  static const List<_CountryData> _countries = [
    _CountryData(
      name: 'Italy',
      flagAsset: 'assets/flags/italy.png',
      flagLabel: 'Flag of Italy',
    ),
    _CountryData(
      name: 'Germany',
      flagAsset: 'assets/flags/germany.png',
      flagLabel: 'Flag of Germany',
    ),
  ];

  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedCountry != null;

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
                          const Text(
                            'Where is your TOWN?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              height: 1.15,
                              color: _white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Select your country to continue.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              letterSpacing: 0.1,
                              color: _lightGrey,
                            ),
                          ),
                          const SizedBox(height: 22),
                          const _LanguageNoticeCard(),
                          const SizedBox(height: 28),
                          const Text(
                            'Country',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              color: _lightGrey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          for (final _CountryData country in _countries) ...[
                            _CountryOption(
                              label: country.name,
                              flagAsset: country.flagAsset,
                              flagLabel: country.flagLabel,
                              selected: _selectedCountry == country.name,
                              onTap: () {
                                setState(() => _selectedCountry = country.name);
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: canContinue ? () {} : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: _gold,
                        foregroundColor: _background,
                        disabledBackgroundColor: _disabledButton,
                        disabledForegroundColor: _disabledLabel,
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
                      child: const Text('Continue'),
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

class _LanguageNoticeCard extends StatelessWidget {
  const _LanguageNoticeCard();

  static const Color _card = Color(0xFF1A1A1A);
  static const Color _white = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(14, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GoldInfoIcon(),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'TOWN is available only in the official language of the selected country and city.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                  letterSpacing: 0.05,
                  color: _white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoldInfoIcon extends StatelessWidget {
  const _GoldInfoIcon();

  static const Color _gold = Color(0xFFE8C547);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: _gold,
        shape: BoxShape.circle,
      ),
      child: const Text(
        'i',
        style: TextStyle(
          color: _black,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _CountryData {
  const _CountryData({
    required this.name,
    required this.flagAsset,
    required this.flagLabel,
  });

  final String name;
  final String flagAsset;
  final String flagLabel;
}

class _CountryOption extends StatelessWidget {
  const _CountryOption({
    required this.label,
    required this.flagAsset,
    required this.flagLabel,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String flagAsset;
  final String flagLabel;
  final bool selected;
  final VoidCallback onTap;

  static const Color _card = Color(0xFF1A1A1A);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _gold = Color(0xFFE8C547);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  flagAsset,
                  width: 34,
                  height: 24,
                  fit: BoxFit.cover,
                  semanticLabel: flagLabel,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.15,
                    color: _white,
                  ),
                ),
              ),
              if (selected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: _gold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Color(0xFF000000),
                  ),
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _white.withValues(alpha: 0.55), width: 1.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
