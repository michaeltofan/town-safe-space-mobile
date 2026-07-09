import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'find_community_screen.dart';

/// Strict storyboard Welcome: brand upper third, street card lower,
/// Welcome pill overlapping the image, Learn more beneath.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final w = constraints.maxWidth;

            // Storyboard proportions on a ~390×844 canvas.
            final titleTop = h * 0.11;
            final imageTop = h * 0.42;
            final imageHeight = h * 0.34;
            final buttonBottom = 28.0;
            final horizontal = 28.0;
            final imageWidth = w - horizontal * 2;

            return Stack(
              children: [
                // Brand block — upper third
                Positioned(
                  top: titleTop,
                  left: horizontal,
                  right: horizontal,
                  child: Column(
                    children: [
                      Text(
                        'TOWN',
                        textAlign: TextAlign.center,
                        style: AppTheme.serif(
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 6.5,
                          height: 1.0,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Real communities.\nReal stories.\nNo noise.',
                        textAlign: TextAlign.center,
                        style: AppTheme.serif(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.55,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Soft Milano street card — lower half
                Positioned(
                  top: imageTop,
                  left: horizontal,
                  width: imageWidth,
                  height: imageHeight,
                  child: const _MilanoStreetCard(),
                ),

                // CTAs — over / just below the image, storyboard placement
                Positioned(
                  left: horizontal,
                  right: horizontal,
                  bottom: buttonBottom,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Slight overlap onto the image area
                      Transform.translate(
                        offset: Offset(0, -(h * 0.02)),
                        child: _WelcomePill(
                          label: 'Welcome',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const FindCommunityScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      _LearnMorePill(
                        onPressed: () => _showLearnMore(context),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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

class _WelcomePill extends StatelessWidget {
  const _WelcomePill({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.card,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.sans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.card,
          ),
        ),
      ),
    );
  }
}

class _LearnMorePill extends StatelessWidget {
  const _LearnMorePill({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          backgroundColor: AppColors.card.withValues(alpha: 0.55),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(
          'Learn more',
          style: AppTheme.sans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.mutedText,
          ),
        ),
      ),
    );
  }
}

/// Soft-focus European street photo placeholder — warm, editorial, not iconic.
class _MilanoStreetCard extends StatelessWidget {
  const _MilanoStreetCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base warm photographic wash
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8DCC8),
                  Color(0xFFD2BFA5),
                  Color(0xFFB89A7A),
                  Color(0xFF8A6E55),
                ],
                stops: [0.0, 0.35, 0.68, 1.0],
              ),
            ),
          ),
          // Late-afternoon light
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.15, -0.55),
                radius: 1.15,
                colors: [
                  const Color(0xFFFFF1D8).withValues(alpha: 0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Detailed street scene
          const CustomPaint(painter: _MilanoStreetPainter()),
          // Soft photographic haze
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: 0.06),
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
          // Photographic vignette
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.05,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.22),
                ],
                stops: const [0.45, 1.0],
              ),
            ),
          ),
          // Bottom soft fade into canvas mood
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.16),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilanoStreetPainter extends CustomPainter {
  const _MilanoStreetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Distant warm sky haze band
    final sky = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, h * 0.42),
        [
          const Color(0xFFF4E8D6),
          const Color(0xFFE2D0B6),
        ],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.42), sky);

    // Left building row (closer facade)
    _drawFacade(
      canvas,
      rect: Rect.fromLTWH(-w * 0.02, h * 0.18, w * 0.34, h * 0.7),
      color: const Color(0xFF7A6350),
      windowCols: 3,
      windowRows: 5,
    );

    // Mid-left narrower building
    _drawFacade(
      canvas,
      rect: Rect.fromLTWH(w * 0.26, h * 0.12, w * 0.18, h * 0.72),
      color: const Color(0xFF6B5544),
      windowCols: 2,
      windowRows: 6,
    );

    // Center distant tower / church-like mass
    final tower = Paint()..color = const Color(0xFF5E4A3B).withValues(alpha: 0.72);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.44, h * 0.08, w * 0.14, h * 0.7),
        const Radius.circular(3),
      ),
      tower,
    );
    // Tower top
    final spire = Path()
      ..moveTo(w * 0.44, h * 0.08)
      ..lineTo(w * 0.51, h * 0.01)
      ..lineTo(w * 0.58, h * 0.08)
      ..close();
    canvas.drawPath(spire, tower);

    // Right buildings
    _drawFacade(
      canvas,
      rect: Rect.fromLTWH(w * 0.58, h * 0.16, w * 0.22, h * 0.68),
      color: const Color(0xFF745C49),
      windowCols: 2,
      windowRows: 5,
    );
    _drawFacade(
      canvas,
      rect: Rect.fromLTWH(w * 0.76, h * 0.22, w * 0.28, h * 0.66),
      color: const Color(0xFF826854),
      windowCols: 3,
      windowRows: 4,
    );

    // Soft awnings
    final awning = Paint()..color = const Color(0xFF4A382C).withValues(alpha: 0.35);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.04, h * 0.58, w * 0.2, h * 0.045),
        const Radius.circular(3),
      ),
      awning,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.62, h * 0.56, w * 0.16, h * 0.04),
        const Radius.circular(3),
      ),
      awning,
    );

    // Cobblestone street perspective
    final street = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.5, h * 0.62, w, h * 0.76)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      street,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.62),
          Offset(0, h),
          [
            const Color(0xFF9A8168).withValues(alpha: 0.55),
            const Color(0xFF6E5744).withValues(alpha: 0.75),
          ],
        ),
    );

    // Perspective lines on street
    final linePaint = Paint()
      ..color = const Color(0xFF4A3A2E).withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (var i = 1; i <= 5; i++) {
      final t = i / 6;
      canvas.drawLine(
        Offset(w * t, h * (0.72 + t * 0.04)),
        Offset(w * (0.35 + t * 0.3), h),
        linePaint,
      );
    }

    // Soft tree silhouettes left/right
    final foliage = Paint()..color = const Color(0xFF3F342C).withValues(alpha: 0.28);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.08, h * 0.52),
        width: w * 0.22,
        height: h * 0.28,
      ),
      foliage,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.92, h * 0.5),
        width: w * 0.2,
        height: h * 0.26,
      ),
      foliage,
    );

    // Tiny warm window glows (late light)
    final glow = Paint()..color = const Color(0xFFFFE2B0).withValues(alpha: 0.35);
    for (var i = 0; i < 6; i++) {
      final x = w * (0.3 + (i % 3) * 0.06);
      final y = h * (0.28 + (i ~/ 3) * 0.12);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, w * 0.025, h * 0.035),
          const Radius.circular(1.5),
        ),
        glow,
      );
    }

    // Soft atmospheric haze mid-distance
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.35, w, h * 0.25),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.35),
          Offset(0, h * 0.6),
          [
            Colors.white.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
    );
  }

  void _drawFacade(
    Canvas canvas, {
    required Rect rect,
    required Color color,
    required int windowCols,
    required int windowRows,
  }) {
    final body = Paint()..color = color.withValues(alpha: 0.78);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      body,
    );

    // Slight lighter face edge
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.top, rect.width * 0.08, rect.height),
      Paint()..color = Colors.white.withValues(alpha: 0.06),
    );

    final window = Paint()..color = const Color(0xFFE8D9C4).withValues(alpha: 0.18);
    final darkWindow = Paint()..color = const Color(0xFF2C241C).withValues(alpha: 0.22);

    final padX = rect.width * 0.14;
    final padY = rect.height * 0.12;
    final usableW = rect.width - padX * 2;
    final usableH = rect.height - padY * 2;
    final cellW = usableW / windowCols;
    final cellH = usableH / windowRows;

    for (var r = 0; r < windowRows; r++) {
      for (var c = 0; c < windowCols; c++) {
        final wx = rect.left + padX + c * cellW + cellW * 0.22;
        final wy = rect.top + padY + r * cellH + cellH * 0.2;
        final ww = cellW * 0.45;
        final wh = cellH * 0.45;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(wx, wy, ww, wh),
            const Radius.circular(1.5),
          ),
          (r + c).isEven ? window : darkWindow,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
