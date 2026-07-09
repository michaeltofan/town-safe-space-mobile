import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'find_community_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'TOWN',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 18),
              Text(
                'Real communities.\nReal stories.\nNo noise.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.mutedText,
                      height: 1.6,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 36),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE8DFD0),
                      Color(0xFFC4B5A0),
                      Color(0xFF8A7460),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.location_city_rounded,
                    size: 56,
                    color: AppColors.card,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Welcome',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const FindCommunityScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Learn more',
                isSecondary: true,
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: AppColors.card,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Come back to your town',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Town is a global civic app with local-only access. '
                              'You join the real community where you live — no worldwide feed, '
                              'no viral noise, no anonymous ghost accounts.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.mutedText,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
