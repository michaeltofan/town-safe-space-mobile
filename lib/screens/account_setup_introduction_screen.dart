import 'package:flutter/material.dart';

import '../models/town_feed_copy.dart';
import 'account_creation_screen.dart';

/// Account Setup Introduction v1 — entry to Account Creation V1.
///
/// Explains why a personal account is required. The primary action opens the
/// single Account Creation screen and does not create an account, authenticate,
/// collect personal data, start payment, verify location, create entitlement,
/// or change membership state.
class AccountSetupIntroductionScreen extends StatelessWidget {
  const AccountSetupIntroductionScreen({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
    required this.copy,
  }) : assert(
         (selectedCountry == 'Italy' && selectedCity == 'Milano') ||
             (selectedCountry == 'Germany' && selectedCity == 'Munich'),
         'Unsupported country/city pair: $selectedCountry / $selectedCity',
       );

  /// Canonical country (`Italy` or `Germany`).
  final String selectedCountry;

  /// Canonical city id (`Milano` or `Munich`).
  final String selectedCity;

  /// Official-language chrome for this country.
  final TownFeedCopy copy;

  static const Color background = Color(0xFF0A0A0A);
  static const Color accent = Color(0xFFE8772E);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5);
  static const Color inkMuted = Color(0x99F5F5F5);

  void _onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onStart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AccountCreationScreen(
          selectedCountry: selectedCountry,
          selectedCity: selectedCity,
          copy: copy,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final double padX = (MediaQuery.sizeOf(context).width * 0.045).clamp(
      16.0,
      21.6,
    );

    return Scaffold(
      key: const Key('account_setup_intro_screen'),
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            padX + safe.left,
            8,
            padX + safe.right,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  key: const Key('account_setup_intro_back'),
                  onPressed: () => _onBack(context),
                  icon: const Icon(Icons.arrow_back, color: ink),
                  tooltip: copy.accountSetupIntroSecondaryBack,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        copy.accountSetupIntroLabel,
                        key: const Key('account_setup_intro_label'),
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: inkMuted,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        copy.accountSetupIntroHeadline,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 28,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        copy.accountSetupIntroBody,
                        style: const TextStyle(
                          fontSize: 16.5,
                          height: 1.4,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        copy.accountSetupIntroWhyTitle,
                        key: const Key('account_setup_intro_why'),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        copy.accountSetupIntroWhyBody,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        copy.accountSetupIntroWhyBodySecond,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        copy.accountSetupIntroVerificationTitle,
                        key: const Key('account_setup_intro_verification'),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        copy.accountSetupIntroVerification1,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        copy.accountSetupIntroVerification2,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        copy.accountSetupIntroVerification3,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        copy.accountSetupIntroPrivacyTitle,
                        key: const Key('account_setup_intro_privacy'),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        copy.accountSetupIntroPrivacyBody,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        copy.accountSetupIntroPrivacyBodySecond,
                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 52,
                child: FilledButton(
                  key: const Key('account_setup_intro_start'),
                  onPressed: () => _onStart(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: const Color(0xFF111111),
                    elevation: 0,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  child: Text(copy.accountSetupIntroStart),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  key: const Key('account_setup_intro_secondary_back'),
                  onPressed: () => _onBack(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ink,
                    side: const BorderSide(
                      color: Color(0x2EFFFFFF),
                      width: 1,
                    ),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(copy.accountSetupIntroSecondaryBack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
