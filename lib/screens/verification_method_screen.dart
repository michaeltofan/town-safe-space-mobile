import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/verification_card.dart';
import 'access_granted_screen.dart';

class VerificationMethodScreen extends StatefulWidget {
  const VerificationMethodScreen({
    super.key,
    required this.country,
    required this.city,
    required this.neighborhood,
  });

  final String country;
  final String city;
  final String neighborhood;

  @override
  State<VerificationMethodScreen> createState() =>
      _VerificationMethodScreenState();
}

class _VerificationMethodScreenState extends State<VerificationMethodScreen> {
  String? _selected;

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
                'How would you like to verify?',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 28),
              VerificationCard(
                title: 'Government ID',
                subtitle: 'Fast & secure',
                icon: Icons.badge_outlined,
                selected: _selected == 'id',
                onTap: () => setState(() => _selected = 'id'),
              ),
              const SizedBox(height: 14),
              VerificationCard(
                title: 'Utility Bill',
                subtitle: 'Address confirmation',
                icon: Icons.receipt_long_outlined,
                selected: _selected == 'utility',
                onTap: () => setState(() => _selected = 'utility'),
              ),
              const SizedBox(height: 14),
              VerificationCard(
                title: 'Local Institution',
                subtitle: 'e.g. University, Employer',
                icon: Icons.account_balance_outlined,
                selected: _selected == 'institution',
                onTap: () => setState(() => _selected = 'institution'),
              ),
              const Spacer(),
              const Text(
                'We only verify. We don’t store documents.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.sansFallback,
                  fontSize: 13,
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Continue',
                onPressed: _selected == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => AccessGrantedScreen(
                              city: widget.city,
                              neighborhood: widget.neighborhood,
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
