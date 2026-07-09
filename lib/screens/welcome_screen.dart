import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'find_community_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
          child: Column(
            children: [
              const SizedBox(height: 28),
              Text(
                'TOWN',
                textAlign: TextAlign.center,
                style: AppTheme.serif(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 7,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Real communities.\nReal stories.\nNo noise.',
                textAlign: TextAlign.center,
                style: AppTheme.sans(
                  fontSize: 16,
                  color: AppColors.mutedText,
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              const Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: _CityPlaceholder(),
                ),
              ),
              const SizedBox(height: 18),
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
              const SizedBox(height: 4),
              PrimaryButton(
                label: 'Learn more',
                isSecondary: true,
                onPressed: () => _showLearnMore(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showLearnMore(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Come back to your town',
                style: AppTheme.serif(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Text(
                'Town is a global civic app with local-only access. '
                'You join the real community where you live — no worldwide feed, '
                'no viral noise, no anonymous ghost accounts.',
                style: AppTheme.sans(
                  fontSize: 15,
                  color: AppColors.mutedText,
                  height: 1.55,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Soft editorial city illustration — balanced for a phone canvas.
class _CityPlaceholder extends StatelessWidget {
  const _CityPlaceholder();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight.clamp(180.0, 300.0);
        final width = constraints.maxWidth.clamp(0.0, 320.0);
        final height = (width * 1.05).clamp(180.0, maxH);

        return SizedBox(
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF3EADF),
                  Color(0xFFE4D7C5),
                  Color(0xFFCDB89F),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Color(0x66FFFFFF),
                        Color(0x00FFFFFF),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.48,
                    widthFactor: 1,
                    child: CustomPaint(
                      painter: _SoftSkylinePainter(),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.07),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.card.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      'Your local community',
                      style: AppTheme.sans(
                        fontSize: 12,
                        color: AppColors.mutedText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SoftSkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8F7A64).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.55)
      ..lineTo(size.width * 0.12, size.height * 0.55)
      ..lineTo(size.width * 0.12, size.height * 0.28)
      ..lineTo(size.width * 0.22, size.height * 0.28)
      ..lineTo(size.width * 0.22, size.height * 0.42)
      ..lineTo(size.width * 0.34, size.height * 0.42)
      ..lineTo(size.width * 0.34, size.height * 0.18)
      ..lineTo(size.width * 0.46, size.height * 0.18)
      ..lineTo(size.width * 0.46, size.height * 0.36)
      ..lineTo(size.width * 0.58, size.height * 0.36)
      ..lineTo(size.width * 0.58, size.height * 0.22)
      ..lineTo(size.width * 0.70, size.height * 0.22)
      ..lineTo(size.width * 0.70, size.height * 0.48)
      ..lineTo(size.width * 0.84, size.height * 0.48)
      ..lineTo(size.width * 0.84, size.height * 0.30)
      ..lineTo(size.width, size.height * 0.30)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final front = Paint()
      ..color = const Color(0xFF6F5B48).withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    final frontPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.55,
        size.width * 0.7,
        size.height * 0.68,
      )
      ..lineTo(size.width, size.height * 0.62)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(frontPath, front);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
