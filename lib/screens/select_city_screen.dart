import 'package:flutter/material.dart';

/// Screen 02B — Select City.
///
/// Visual prototype: single-select city for the country chosen on Screen 02A.
/// Continue does not navigate further yet.
class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({
    super.key,
    required this.selectedCountry,
  });

  /// Country name passed from Screen 02A (`Italy` or `Germany`).
  final String selectedCountry;

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  static const Color _background = Color(0xFF000000);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _lightGrey = Color(0xFFB0B0B0);
  static const Color _gold = Color(0xFFE8C547);
  static const Color _disabledButton = Color(0xFF2A2A2A);
  static const Color _disabledLabel = Color(0xFF6B6B6B);

  static const double _maxContentWidth = 410;

  static const Map<String, _CityData> _cityByCountry = {
    'Italy': _CityData(
      name: 'Milano',
      imageAsset: 'assets/cities/milano.png',
      imageLabel: 'Milano landmark',
    ),
    'Germany': _CityData(
      name: 'Munich',
      imageAsset: 'assets/cities/munich.png',
      imageLabel: 'Munich landmark',
    ),
  };

  static const Map<String, _CountryVisual> _countryVisuals = {
    'Italy': _CountryVisual(
      flagAsset: 'assets/flags/italy.png',
      flagLabel: 'Flag of Italy',
    ),
    'Germany': _CountryVisual(
      flagAsset: 'assets/flags/germany.png',
      flagLabel: 'Flag of Germany',
    ),
  };

  String? _selectedCity;

  _CityData get _availableCity {
    final _CityData? city = _cityByCountry[widget.selectedCountry];
    assert(city != null, 'Unsupported country: ${widget.selectedCountry}');
    return city!;
  }

  _CountryVisual get _countryVisual {
    final _CountryVisual? visual = _countryVisuals[widget.selectedCountry];
    assert(visual != null, 'Unsupported country: ${widget.selectedCountry}');
    return visual!;
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedCity != null;
    final _CityData city = _availableCity;
    final _CountryVisual country = _countryVisual;

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
                            'Select your city',
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
                            'Choose your city to continue.',
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
                          _SelectedCountryRow(
                            countryName: widget.selectedCountry,
                            flagAsset: country.flagAsset,
                            flagLabel: country.flagLabel,
                            onChange: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Select city',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              color: _lightGrey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _CityOption(
                            label: city.name,
                            imageAsset: city.imageAsset,
                            imageLabel: city.imageLabel,
                            selected: _selectedCity == city.name,
                            onTap: () {
                              setState(() => _selectedCity = city.name);
                            },
                          ),
                          const SizedBox(height: 12),
                          const _LockedCitiesRow(),
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

class _CityData {
  const _CityData({
    required this.name,
    required this.imageAsset,
    required this.imageLabel,
  });

  final String name;
  final String imageAsset;
  final String imageLabel;
}

class _CountryVisual {
  const _CountryVisual({
    required this.flagAsset,
    required this.flagLabel,
  });

  final String flagAsset;
  final String flagLabel;
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

class _SelectedCountryRow extends StatelessWidget {
  const _SelectedCountryRow({
    required this.countryName,
    required this.flagAsset,
    required this.flagLabel,
    required this.onChange,
  });

  final String countryName;
  final String flagAsset;
  final String flagLabel;
  final VoidCallback onChange;

  static const Color _card = Color(0xFF1A1A1A);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _gold = Color(0xFFE8C547);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
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
                countryName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                  color: _white,
                ),
              ),
            ),
            TextButton(
              onPressed: onChange,
              style: TextButton.styleFrom(
                foregroundColor: _gold,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityOption extends StatelessWidget {
  const _CityOption({
    required this.label,
    required this.imageAsset,
    required this.imageLabel,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String imageAsset;
  final String imageLabel;
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageAsset,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  semanticLabel: imageLabel,
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
                    border: Border.all(
                      color: _white.withValues(alpha: 0.55),
                      width: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LockedCitiesRow extends StatelessWidget {
  const _LockedCitiesRow();

  static const Color _card = Color(0xFF1A1A1A);
  static const Color _lightGrey = Color(0xFFB0B0B0);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Other cities coming soon',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  color: _lightGrey,
                ),
              ),
            ),
            Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: _lightGrey,
            ),
          ],
        ),
      ),
    );
  }
}
