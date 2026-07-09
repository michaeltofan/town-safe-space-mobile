import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'find_community_screen.dart';

/// WelcomeScreen rebuilt against 01_welcome_screen.png only.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final w = constraints.maxWidth;
            final side = (w * 0.10).clamp(28.0, 40.0);
            final buttonWidth = (w * 0.82).clamp(260.0, 340.0);

            return Column(
              children: [
                SizedBox(height: h * 0.08),

                // Title
                const Text(
                  'TOWN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontFamilyFallback: [
                      'Times New Roman',
                      'Times',
                      'serif',
                    ],
                    fontSize: 42,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 6,
                    height: 1.0,
                    color: Color(0xFF2B1F12),
                  ),
                ),

                const SizedBox(height: 14),

                // Subtitle — calm sans, three centered lines
                const Text(
                  'Real communities.\nReal stories.\nNo noise.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontFamilyFallback: [
                      'Helvetica',
                      'Arial',
                      'sans-serif',
                    ],
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF5C534A),
                  ),
                ),

                // Soft-fade street illustration (edges dissolve into canvas)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: side * 0.35),
                    child: const _SoftFadeStreetIllustration(),
                  ),
                ),

                // CTAs — equal width, ~82% of phone width
                SizedBox(
                  width: buttonWidth,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const FindCommunityScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B1F12),
                      foregroundColor: const Color(0xFFFFFCF6),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      'Welcome',
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontFamilyFallback: [
                          'Helvetica',
                          'Arial',
                          'sans-serif',
                        ],
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFCF6),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: buttonWidth,
                  height: 48,
                  child: TextButton(
                    onPressed: () => _showLearnMore(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFEFE9E1),
                      foregroundColor: const Color(0xFF2B1F12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontFamilyFallback: [
                          'Helvetica',
                          'Arial',
                          'sans-serif',
                        ],
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2B1F12),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.04),
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
        return const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Come back to your town',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontFamilyFallback: ['Times New Roman', 'Times', 'serif'],
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF24221F),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Town is a global civic app with local-only access. '
                'You join the real community where you live — no worldwide feed, '
                'no viral noise, no anonymous ghost accounts.',
                style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontFamilyFallback: ['Helvetica', 'Arial', 'sans-serif'],
                  fontSize: 15,
                  height: 1.55,
                  color: Color(0xFF6F675D),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Soft sepia street scene with edges fading into #F8F3EA — no hard card border.
class _SoftFadeStreetIllustration extends StatelessWidget {
  const _SoftFadeStreetIllustration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(painter: _SepiaStreetPainter()),
            // Top fade into canvas
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF8F3EA),
                    Color(0x00F8F3EA),
                  ],
                  stops: [0.0, 0.22],
                ),
              ),
            ),
            // Bottom fade into canvas
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFFF8F3EA),
                    Color(0x00F8F3EA),
                  ],
                  stops: [0.0, 0.28],
                ),
              ),
            ),
            // Side fades for soft vignette edges
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFFF8F3EA).withValues(alpha: 0.85),
                    const Color(0x00F8F3EA),
                    const Color(0x00F8F3EA),
                    const Color(0xFFF8F3EA).withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.12, 0.88, 1.0],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SepiaStreetPainter extends CustomPainter {
  const _SepiaStreetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Soft watercolor wash
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.15),
          Offset(0, h * 0.9),
          const [
            Color(0xFFEFE3D0),
            Color(0xFFD9C4A6),
            Color(0xFFC4A888),
            Color(0xFFB09070),
          ],
          [0.0, 0.35, 0.7, 1.0],
        ),
    );

    // Distant sky glow
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.18),
      w * 0.45,
      Paint()
        ..color = const Color(0xFFFFF4E2).withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28),
    );

    // Left ornate building row
    _drawBuildingBlock(
      canvas,
      Rect.fromLTWH(w * 0.02, h * 0.22, w * 0.28, h * 0.55),
      const Color(0xFF8A7058),
      floors: 5,
      bays: 3,
    );
    _drawBuildingBlock(
      canvas,
      Rect.fromLTWH(w * 0.22, h * 0.18, w * 0.16, h * 0.56),
      const Color(0xFF7A614C),
      floors: 6,
      bays: 2,
    );

    // Center vanishing street corridor suggestion
    final corridor = Path()
      ..moveTo(w * 0.38, h * 0.72)
      ..lineTo(w * 0.48, h * 0.28)
      ..lineTo(w * 0.52, h * 0.28)
      ..lineTo(w * 0.62, h * 0.72)
      ..close();
    canvas.drawPath(
      corridor,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(w * 0.5, h * 0.28),
          Offset(w * 0.5, h * 0.72),
          [
            const Color(0xFFC8B49A).withValues(alpha: 0.35),
            const Color(0xFF9A8068).withValues(alpha: 0.55),
          ],
        ),
    );

    // Right buildings
    _drawBuildingBlock(
      canvas,
      Rect.fromLTWH(w * 0.62, h * 0.18, w * 0.16, h * 0.56),
      const Color(0xFF7A614C),
      floors: 6,
      bays: 2,
    );
    _drawBuildingBlock(
      canvas,
      Rect.fromLTWH(w * 0.70, h * 0.24, w * 0.28, h * 0.52),
      const Color(0xFF8A7058),
      floors: 5,
      bays: 3,
    );

    // Leafy tree masses (soft watercolor blobs)
    _drawTree(canvas, Offset(w * 0.14, h * 0.42), w * 0.18, h * 0.28);
    _drawTree(canvas, Offset(w * 0.86, h * 0.40), w * 0.17, h * 0.26);
    _drawTree(canvas, Offset(w * 0.30, h * 0.36), w * 0.12, h * 0.18);
    _drawTree(canvas, Offset(w * 0.70, h * 0.35), w * 0.12, h * 0.18);

    // Street plane with perspective
    final street = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.74)
      ..quadraticBezierTo(w * 0.5, h * 0.58, w, h * 0.74)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      street,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.58),
          Offset(0, h),
          [
            const Color(0xFFB89A78).withValues(alpha: 0.45),
            const Color(0xFF8A6E54).withValues(alpha: 0.7),
          ],
        ),
    );

    // Soft sketch lines for street perspective
    final sketch = Paint()
      ..color = const Color(0xFF5A4638).withValues(alpha: 0.12)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;
    for (var i = 1; i <= 4; i++) {
      final t = i / 5;
      canvas.drawLine(
        Offset(w * t * 0.9, h * (0.68 + t * 0.03)),
        Offset(w * 0.5, h * 0.58),
        sketch,
      );
    }

    // Soft overall sepia wash
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFC4A888).withValues(alpha: 0.08),
    );
  }

  void _drawBuildingBlock(
    Canvas canvas,
    Rect rect,
    Color color, {
    required int floors,
    required int bays,
  }) {
    // Soft watercolor body
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()
        ..color = color.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()..color = color.withValues(alpha: 0.62),
    );

    // Window grid — soft sketch feel
    final light = Paint()..color = const Color(0xFFF2E6D4).withValues(alpha: 0.22);
    final dark = Paint()..color = const Color(0xFF3A2E24).withValues(alpha: 0.18);
    final padX = rect.width * 0.14;
    final padY = rect.height * 0.1;
    final cellW = (rect.width - padX * 2) / bays;
    final cellH = (rect.height - padY * 2) / floors;

    for (var r = 0; r < floors; r++) {
      for (var c = 0; c < bays; c++) {
        final wx = rect.left + padX + c * cellW + cellW * 0.22;
        final wy = rect.top + padY + r * cellH + cellH * 0.2;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(wx, wy, cellW * 0.42, cellH * 0.45),
            const Radius.circular(1),
          ),
          (r + c).isEven ? light : dark,
        );
      }
    }
  }

  void _drawTree(Canvas canvas, Offset center, double width, double height) {
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height),
      Paint()
        ..color = const Color(0xFF5A6B48).withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, height * 0.05),
        width: width * 0.75,
        height: height * 0.7,
      ),
      Paint()..color = const Color(0xFF4A5A3C).withValues(alpha: 0.2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
