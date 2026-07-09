import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/community_dropdown.dart';
import '../widgets/primary_button.dart';
import 'verification_intro_screen.dart';

class FindCommunityScreen extends StatefulWidget {
  const FindCommunityScreen({super.key});

  @override
  State<FindCommunityScreen> createState() => _FindCommunityScreenState();
}

class _FindCommunityScreenState extends State<FindCommunityScreen> {
  String? _country = 'Italy';
  String? _city = 'Milano';
  String? _neighborhood = 'Brera';

  bool get _canContinue =>
      _country != null && _city != null && _neighborhood != null;

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
              const SizedBox(height: 28),
              Text(
                'Where do you live?',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'We’ll connect you to your real local community.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.mutedText,
                    ),
              ),
              const SizedBox(height: 36),
              CommunityDropdown(
                label: 'Country',
                value: _country,
                items: const ['Italy'],
                onChanged: (value) => setState(() => _country = value),
              ),
              const SizedBox(height: 16),
              CommunityDropdown(
                label: 'City',
                value: _city,
                items: const ['Milano'],
                onChanged: (value) => setState(() => _city = value),
              ),
              const SizedBox(height: 16),
              CommunityDropdown(
                label: 'Neighborhood',
                value: _neighborhood,
                items: const ['Brera'],
                onChanged: (value) => setState(() => _neighborhood = value),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Continue',
                onPressed: _canContinue
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => VerificationIntroScreen(
                              country: _country!,
                              city: _city!,
                              neighborhood: _neighborhood!,
                            ),
                          ),
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'You can change later in your profile.',
                  style: TextStyle(
                    fontFamily: AppTheme.sansFallback,
                    fontSize: 13,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
