import 'package:flutter/material.dart';

/// Screen 02B — Select City.
///
/// Visual prototype: single-select city for the country chosen on Screen 02A.
/// Selecting a city immediately switches the interface to the official language
/// of that country/city pair. Continue does not navigate further yet.
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
      id: 'Milano',
      imageAsset: 'assets/cities/milano.png',
      imageLabel: 'Milano landmark',
    ),
    'Germany': _CityData(
      id: 'Munich',
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

  /// Canonical city id (`Milano` / `Munich`), independent of display language.
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

  _SelectCityCopy get _copy {
    if (_selectedCity == null) {
      return _SelectCityCopy.english(widget.selectedCountry);
    }
    return _SelectCityCopy.official(
      country: widget.selectedCountry,
      cityId: _selectedCity!,
    );
  }

  @override
  void initState() {
    super.initState();
    // Keep country flag + city thumbnail ready across the language switch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final _CountryVisual country = _countryVisual;
      final _CityData city = _availableCity;
      precacheImage(AssetImage(country.flagAsset), context);
      precacheImage(AssetImage(city.imageAsset), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedCity != null;
    final _CityData city = _availableCity;
    final _CountryVisual country = _countryVisual;
    final _SelectCityCopy copy = _copy;

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
                          const SizedBox(height: 10),
                          Text(
                            copy.supportingText,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              letterSpacing: 0.1,
                              color: _lightGrey,
                            ),
                          ),
                          const SizedBox(height: 22),
                          _LanguageNoticeCard(notice: copy.notice),
                          const SizedBox(height: 28),
                          Text(
                            copy.countrySectionLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              color: _lightGrey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SelectedCountryRow(
                            countryName: copy.countryName,
                            changeLabel: copy.changeLabel,
                            flagAsset: country.flagAsset,
                            flagLabel: country.flagLabel,
                            onChange: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            copy.citySectionLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              color: _lightGrey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _CityOption(
                            label: copy.cityName,
                            imageAsset: city.imageAsset,
                            imageLabel: city.imageLabel,
                            selected: _selectedCity == city.id,
                            onTap: () {
                              setState(() => _selectedCity = city.id);
                            },
                          ),
                          const SizedBox(height: 12),
                          _LockedCitiesRow(label: copy.lockedCitiesLabel),
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
                      child: Text(copy.continueLabel),
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

/// Interface copy for Screen 02B.
///
/// English before city selection; official language of the selected
/// country/city pair immediately after selection. No manual language choice.
class _SelectCityCopy {
  const _SelectCityCopy({
    required this.title,
    required this.supportingText,
    required this.notice,
    required this.countrySectionLabel,
    required this.countryName,
    required this.changeLabel,
    required this.citySectionLabel,
    required this.cityName,
    required this.lockedCitiesLabel,
    required this.continueLabel,
  });

  final String title;
  final String supportingText;
  final String notice;
  final String countrySectionLabel;
  final String countryName;
  final String changeLabel;
  final String citySectionLabel;
  final String cityName;
  final String lockedCitiesLabel;
  final String continueLabel;

  factory _SelectCityCopy.english(String country) {
    return _SelectCityCopy(
      title: 'Select your city',
      supportingText: 'Choose your city to continue.',
      notice:
          'TOWN is available only in the official language of the selected country and city.',
      countrySectionLabel: 'Country',
      countryName: country,
      changeLabel: 'Change',
      citySectionLabel: 'Select city',
      cityName: country == 'Germany' ? 'Munich' : 'Milano',
      lockedCitiesLabel: 'Other cities coming soon',
      continueLabel: 'Continue',
    );
  }

  factory _SelectCityCopy.official({
    required String country,
    required String cityId,
  }) {
    assert(
      (country == 'Italy' && cityId == 'Milano') ||
          (country == 'Germany' && cityId == 'Munich'),
      'Unsupported country/city pair: $country / $cityId',
    );

    if (country == 'Italy') {
      return const _SelectCityCopy(
        title: 'Seleziona la tua città',
        supportingText: 'Scegli la tua città per continuare.',
        notice:
            'TOWN è disponibile solo nella lingua ufficiale del paese e della città selezionati.',
        countrySectionLabel: 'Paese',
        countryName: 'Italia',
        changeLabel: 'Cambia',
        citySectionLabel: 'Seleziona città',
        cityName: 'Milano',
        lockedCitiesLabel: 'Altre città in arrivo',
        continueLabel: 'Continua',
      );
    }

    return const _SelectCityCopy(
      title: 'Wähle deine Stadt',
      supportingText: 'Wähle deine Stadt, um fortzufahren.',
      notice:
          'TOWN ist nur in der Amtssprache des ausgewählten Landes und der ausgewählten Stadt verfügbar.',
      countrySectionLabel: 'Land',
      countryName: 'Deutschland',
      changeLabel: 'Ändern',
      citySectionLabel: 'Stadt auswählen',
      cityName: 'München',
      lockedCitiesLabel: 'Weitere Städte folgen',
      continueLabel: 'Weiter',
    );
  }
}

class _CityData {
  const _CityData({
    required this.id,
    required this.imageAsset,
    required this.imageLabel,
  });

  final String id;
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
  const _LanguageNoticeCard({required this.notice});

  final String notice;

  static const Color _card = Color(0xFF1A1A1A);
  static const Color _white = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _GoldInfoIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notice,
                style: const TextStyle(
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
    required this.changeLabel,
    required this.flagAsset,
    required this.flagLabel,
    required this.onChange,
  });

  final String countryName;
  final String changeLabel;
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
                key: ValueKey<String>('flag-$flagAsset'),
                width: 34,
                height: 24,
                fit: BoxFit.cover,
                gaplessPlayback: true,
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
              child: Text(changeLabel),
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
                  key: ValueKey<String>('city-$imageAsset'),
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
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
  const _LockedCitiesRow({required this.label});

  final String label;

  static const Color _card = Color(0xFF1A1A1A);
  static const Color _lightGrey = Color(0xFFB0B0B0);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  color: _lightGrey,
                ),
              ),
            ),
            const Icon(
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
