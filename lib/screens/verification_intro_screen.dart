import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'verification_method_screen.dart';

class VerificationIntroScreen extends StatelessWidget {
  const VerificationIntroScreen({
    super.key,
    required this.country,
    required this.city,
    required this.neighborhood,
  });

  final String country;
  final String city;
  final String neighborhood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: AppColors.text,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(flex: 1),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
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
                    Icons.verified_user_outlined,
                    size: 44,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Center(
                child: Text(
                  'One-time verification',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We verify that you belong to this community.\n'
                'We do not store your exact location.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.mutedText,
                      height: 1.6,
                    ),
              ),
              const SizedBox(height: 36),
              const _BulletRow(label: 'Quick & secure'),
              const SizedBox(height: 14),
              const _BulletRow(label: 'Private'),
              const SizedBox(height: 14),
              const _BulletRow(label: 'One-time only'),
              const Spacer(flex: 2),
              PrimaryButton(
                label: 'Continue',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => VerificationMethodScreen(
                        country: country,
                        city: city,
                        neighborhood: neighborhood,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTheme.sansFallback,
            fontSize: 16,
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
