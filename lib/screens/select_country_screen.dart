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
  static const Color _background = Color(0xFF12100E);
  static const Color _ivory = Color(0xFFFDFBF7);
  static const Color _muted = Color(0xFF9A9086);
  static const Color _disabledButton = Color(0xFF3A342E);
  static const Color _disabledLabel = Color(0xFF7A7268);

  static const double _maxContentWidth = 410;

  static const List<String> _countries = ['Italy', 'Germany'];

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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: _ivory,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      tooltip: 'Back',
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Where is your TOWN?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      height: 1.15,
                      color: _ivory,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Select your country to continue.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                      letterSpacing: 0.15,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'TOWN is available only in the official language of the selected country and city.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0.1,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 36),
                  for (final String country in _countries) ...[
                    _CountryOption(
                      label: country,
                      selected: _selectedCountry == country,
                      onTap: () {
                        setState(() => _selectedCountry = country);
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: canContinue ? () {} : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: _ivory,
                        foregroundColor: _background,
                        disabledBackgroundColor: _disabledButton,
                        disabledForegroundColor: _disabledLabel,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryOption extends StatelessWidget {
  const _CountryOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const Color _surface = Color(0xFF1C1814);
  static const Color _surfaceSelected = Color(0xFF2A241E);
  static const Color _ivory = Color(0xFFFDFBF7);
  static const Color _muted = Color(0xFF9A9086);
  static const Color _border = Color(0xFF3A322A);
  static const Color _borderSelected = Color(0xFFD9D0C4);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _surfaceSelected : _surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: selected ? _borderSelected : _border,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.2,
                    color: selected ? _ivory : _muted,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                size: 22,
                color: selected ? _ivory : _muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
