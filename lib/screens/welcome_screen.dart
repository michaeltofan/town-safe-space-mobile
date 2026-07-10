import 'package:flutter/material.dart';

import 'select_country_screen.dart';

/// Welcome / Manifest screen for TOWN.
///
/// Visual prototype — Welcome opens Select Country; Learn more stays inert.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _ivory = Color(0xFFFDFBF7);
  static const Color _charcoal = Color(0xFF1E140F);
  static const Color _bodyText = Color(0xFF2C241C);
  static const Color _secondaryButton = Color(0xFFF2EBE1);
  static const Color _footerText = Color(0xFF8A7F74);

  /// Phone-width content column for mobile-first layout on any viewport.
  static const double _maxContentWidth = 410;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ivory,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'TOWN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                      color: _charcoal,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Real communities.\nReal stories.\nNo noise.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.55,
                      color: _bodyText,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Expanded(
                    child: Center(
                      child: _WelcomeIllustration(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TOWN accepts accounts only with registration, confirmed location, and an active membership.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                      color: _footerText,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SelectCountryScreen(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _charcoal,
                        foregroundColor: _ivory,
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
                      child: const Text('Welcome'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: _secondaryButton,
                        foregroundColor: _charcoal,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                      child: const Text('Learn more'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'A local civic space for thoughtful neighbourhood stories.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: _footerText,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Approved street illustration from the Screen 01 visual reference.
class _WelcomeIllustration extends StatelessWidget {
  const _WelcomeIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/welcome_screen.png',
      fit: BoxFit.contain,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
      semanticLabel: 'Calm European street illustration',
    );
  }
}
