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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppColors.text,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ),
              const Spacer(flex: 1),
              SizedBox(
                height: 140,
                width: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(160, 140),
                      painter: _SoftLeavesPainter(),
                    ),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.softWarm,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'One-time verification',
                textAlign: TextAlign.center,
                style: AppTheme.serif(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 14),
              Text(
                'We verify that you belong to this community.\n'
                'We do not store your exact location.',
                textAlign: TextAlign.center,
                style: AppTheme.sans(
                  fontSize: 15,
                  color: AppColors.mutedText,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 28),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    _BulletRow(label: 'Quick & secure'),
                    SizedBox(height: 12),
                    _BulletRow(label: 'Private'),
                    SizedBox(height: 12),
                    _BulletRow(label: 'One-time only'),
                  ],
                ),
              ),
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
              const SizedBox(height: 16),
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
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.check_rounded, size: 14, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTheme.sans(
            fontSize: 15,
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SoftLeavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final leaf = Paint()
      ..color = const Color(0xFFB7A48A).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    void oval(double cx, double cy, double w, double h, double rot) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(rot);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: w, height: h), leaf);
      canvas.restore();
    }

    oval(size.width * 0.18, size.height * 0.42, 34, 16, -0.7);
    oval(size.width * 0.22, size.height * 0.58, 28, 13, -0.3);
    oval(size.width * 0.82, size.height * 0.38, 36, 16, 0.7);
    oval(size.width * 0.78, size.height * 0.55, 30, 14, 0.35);
    oval(size.width * 0.5, size.height * 0.12, 26, 12, 0.1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
