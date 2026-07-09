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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                color: AppColors.text,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              const SizedBox(height: 12),
              Text(
                'Where do you live?',
                style: AppTheme.serif(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'We’ll connect you to your real local community.',
                style: AppTheme.sans(
                  fontSize: 15,
                  color: AppColors.mutedText,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              CommunityDropdown(
                label: 'Country',
                value: _country,
                items: const ['Italy'],
                onChanged: (value) => setState(() => _country = value),
              ),
              const SizedBox(height: 12),
              CommunityDropdown(
                label: 'City',
                value: _city,
                items: const ['Milano'],
                onChanged: (value) => setState(() => _city = value),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'You can change later in your profile.',
                  style: AppTheme.sans(
                    fontSize: 12,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
