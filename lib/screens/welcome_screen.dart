import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'find_community_screen.dart';

/// Storyboard-aligned welcome: brand, manifesto, soft city card, pill CTAs.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Text(
                'TOWN',
                textAlign: TextAlign.center,
                style: AppTheme.serif(
                  fontSize: 46,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 8,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Real communities.\nReal stories.\nNo noise.',
                textAlign: TextAlign.center,
                style: AppTheme.sans(
                  fontSize: 17,
                  color: AppColors.mutedText,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(flex: 2),
              const _CityImageCard(),
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
              const SizedBox(height: 2),
              PrimaryButton(
                label: 'Learn more',
                isSecondary: true,
                onPressed: () => _showLearnMore(context),
              ),
              const SizedBox(height: 8),
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

/// Soft horizontal city placeholder — warm European street mood.
class _CityImageCard extends StatelessWidget {
  const _CityImageCard();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.55,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEDE3D4),
                    Color(0xFFD8C4A8),
                    Color(0xFFB89A78),
                    Color(0xFF8F7358),
                  ],
                  stops: [0.0, 0.35, 0.7, 1.0],
                ),
              ),
            ),
            // Soft light haze
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.2, -0.6),
                  radius: 1.1,
                  colors: [
                    Colors.white.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Street / building suggestion
            CustomPaint(painter: _StreetScenePainter()),
            // Soft focus vignette
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.18),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreetScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final building = Paint()
      ..color = const Color(0xFF6A5544).withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    // Left facade
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.06, size.height * 0.28, size.width * 0.22, size.height * 0.72),
        const Radius.circular(4),
      ),
      building,
    );

    // Center tower
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.34, size.height * 0.12, size.width * 0.18, size.height * 0.88),
        const Radius.circular(4),
      ),
      building,
    );

    // Right block
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.62, size.height * 0.34, size.width * 0.28, size.height * 0.66),
        const Radius.circular(4),
      ),
      building,
    );

    // Soft street plane
    final street = Paint()
      ..color = const Color(0xFF5A4638).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final streetPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.68,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(streetPath, street);

    // Window hints
    final window = Paint()
      ..color = const Color(0xFFFFF8EE).withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.38,
            size.height * (0.22 + i * 0.14),
            size.width * 0.04,
            size.height * 0.06,
          ),
          const Radius.circular(2),
        ),
        window,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.46,
            size.height * (0.22 + i * 0.14),
            size.width * 0.04,
            size.height * 0.06,
          ),
          const Radius.circular(2),
        ),
        window,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
