import 'package:flutter/material.dart';

import 'select_country_screen.dart';

/// Welcome / Manifest screen for TOWN.
///
/// Welcome opens Select Country. Learn more opens an in-place bottom sheet
/// and does not navigate away from this screen.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _ivory = Color(0xFFFDFBF7);
  static const Color _charcoal = Color(0xFF1E140F);
  static const Color _bodyText = Color(0xFF2C241C);
  static const Color _secondaryButton = Color(0xFFF2EBE1);
  static const Color _footerText = Color(0xFF8A7F74);

  /// Phone-width content column for mobile-first layout on any viewport.
  static const double _maxContentWidth = 410;

  static const String learnMoreTitle = 'What is TOWN?';

  static const String learnMoreBody =
      'TOWN is local civic infrastructure for real people, useful information, and community.\n'
      '\n'
      'It helps people access and share relevant information about the city they live in.\n'
      '\n'
      'TOWN is not social media. It has no global feed, no follower race, and no advertising-driven engagement.';

  static const String learnMoreCloseLabel = 'Close';

  Future<void> _openLearnMore(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
              top: 24,
              bottom: 20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: _maxContentWidth,
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            learnMoreTitle,
                            key: const Key('learn_more_title'),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              height: 1.2,
                              color: _charcoal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            learnMoreBody,
                            key: const Key('learn_more_body'),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.55,
                              letterSpacing: 0.1,
                              color: _bodyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      key: const Key('learn_more_close'),
                      onPressed: () => Navigator.of(sheetContext).pop(),
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
                      child: const Text(learnMoreCloseLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
                  const Expanded(child: Center(child: _WelcomeIllustration())),
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
                      key: const Key('learn_more_button'),
                      onPressed: () => _openLearnMore(context),
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
