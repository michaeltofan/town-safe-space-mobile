import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'find_community_screen.dart';

/// Welcome screen rebuilt to match storyboard phone “1. Welcome Screen”.
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
            final side = (w * 0.085).clamp(22.0, 32.0);

            // Storyboard composition on a tall phone canvas.
            final titleTop = h * 0.095;
            final imageTop = h * 0.385;
            final imageHeight = (h * 0.305).clamp(170.0, 236.0);
            // Welcome sits on the lower edge of the street card.
            final welcomeTop = imageTop + imageHeight - 26;

            return Stack(
              children: [
                // 1) Title + subtitle — upper third
                Positioned(
                  top: titleTop,
                  left: side,
                  right: side,
                  child: Column(
                    children: [
                      Text(
                        'TOWN',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontFamilyFallback: [
                            'Times New Roman',
                            'Times',
                            'serif',
                          ],
                          fontSize: 44,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 7,
                          height: 1.0,
                          color: Color(0xFF24221F),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.55,
                          color: Color(0xFF6F675D),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2) Soft local street card — lower-middle
                Positioned(
                  top: imageTop,
                  left: side,
                  right: side,
                  height: imageHeight,
                  child: const _StreetPhotoCard(),
                ),

                // 3) Buttons — Welcome overlaps image bottom; Learn more below
                Positioned(
                  top: welcomeTop,
                  left: side,
                  right: side,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFCF6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          onPressed: () => _showLearnMore(context),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFEDE6DA),
                            foregroundColor: const Color(0xFF6F675D),
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
                              color: Color(0xFF6F675D),
                            ),
                          ),
                        ),
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

/// Soft warm European street card — photo-like, not an icon.
class _StreetPhotoCard extends StatelessWidget {
  const _StreetPhotoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Warm golden-hour base
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF0E4D0),
                  Color(0xFFDCC7A8),
                  Color(0xFFC4A484),
                  Color(0xFF9A7A5A),
                ],
                stops: [0.0, 0.32, 0.65, 1.0],
              ),
            ),
          ),
          // Soft afternoon light
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.7),
                radius: 1.2,
                colors: [
                  const Color(0xFFFFF3DD).withValues(alpha: 0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const CustomPaint(painter: _LocalStreetPainter()),
          // Soft vignette
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.18),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          // Bottom edge softness
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.12),
                ],
                stops: const [0.65, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalStreetPainter extends CustomPainter {
  const _LocalStreetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sky band
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.38),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, h * 0.38),
          const [Color(0xFFF6EBDA), Color(0xFFE5D3B8)],
        ),
    );

    // Left building mass
    _building(
      canvas,
      Rect.fromLTWH(-w * 0.04, h * 0.16, w * 0.36, h * 0.72),
      const Color(0xFF7A614C),
      cols: 3,
      rows: 5,
    );

    // Mid-left
    _building(
      canvas,
      Rect.fromLTWH(w * 0.26, h * 0.10, w * 0.18, h * 0.74),
      const Color(0xFF6A5341),
      cols: 2,
      rows: 6,
    );

    // Distant center mass
    final center = Paint()..color = const Color(0xFF5A4638).withValues(alpha: 0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.45, h * 0.08, w * 0.12, h * 0.68),
        const Radius.circular(2),
      ),
      center,
    );

    // Right buildings
    _building(
      canvas,
      Rect.fromLTWH(w * 0.58, h * 0.14, w * 0.22, h * 0.7),
      const Color(0xFF745C48),
      cols: 2,
      rows: 5,
    );
    _building(
      canvas,
      Rect.fromLTWH(w * 0.78, h * 0.20, w * 0.28, h * 0.68),
      const Color(0xFF836954),
      cols: 3,
      rows: 4,
    );

    // Soft trees / vertical foliage
    final leaf = Paint()..color = const Color(0xFF3E342B).withValues(alpha: 0.28);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.1, h * 0.5), width: w * 0.2, height: h * 0.3),
      leaf,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.9, h * 0.48), width: w * 0.18, height: h * 0.28),
      leaf,
    );

    // Street perspective plane
    final street = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.5, h * 0.60, w, h * 0.76)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      street,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.6),
          Offset(0, h),
          [
            const Color(0xFFA3886C).withValues(alpha: 0.55),
            const Color(0xFF6E5743).withValues(alpha: 0.8),
          ],
        ),
    );

    // Subtle perspective lines
    final line = Paint()
      ..color = const Color(0xFF3F3228).withValues(alpha: 0.1)
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final t = i / 5;
      canvas.drawLine(
        Offset(w * t, h * (0.7 + 0.02 * t)),
        Offset(w * 0.5, h),
        line,
      );
    }

    // Soft atmospheric mid haze
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.3, w, h * 0.28),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.3),
          Offset(0, h * 0.58),
          [
            Colors.white.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
    );
  }

  void _building(
    Canvas canvas,
    Rect rect,
    Color color, {
    required int cols,
    required int rows,
  }) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      Paint()..color = color.withValues(alpha: 0.78),
    );

    final light = Paint()..color = const Color(0xFFEADCC8).withValues(alpha: 0.16);
    final dark = Paint()..color = const Color(0xFF2A221B).withValues(alpha: 0.2);

    final padX = rect.width * 0.16;
    final padY = rect.height * 0.12;
    final usableW = rect.width - padX * 2;
    final usableH = rect.height - padY * 2;
    final cellW = usableW / cols;
    final cellH = usableH / rows;

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final wx = rect.left + padX + c * cellW + cellW * 0.25;
        final wy = rect.top + padY + r * cellH + cellH * 0.22;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(wx, wy, cellW * 0.4, cellH * 0.42),
            const Radius.circular(1.2),
          ),
          (r + c).isEven ? light : dark,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
