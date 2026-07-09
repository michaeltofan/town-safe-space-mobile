import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'main_navigation_screen.dart';

class AccessGrantedScreen extends StatelessWidget {
  const AccessGrantedScreen({
    super.key,
    required this.city,
    required this.neighborhood,
  });

  final String city;
  final String neighborhood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: AppColors.softWarm,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'You’re in!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'You now have access to $neighborhood, $city.\n'
                'Welcome to your community.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.mutedText,
                      height: 1.6,
                    ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Go to Feed',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => MainNavigationScreen(
                        city: city,
                        neighborhood: neighborhood,
                      ),
                    ),
                    (_) => false,
                  );
                },
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
