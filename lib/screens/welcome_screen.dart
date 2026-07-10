import 'package:flutter/material.dart';

/// Welcome / Manifest screen for TOWN.
///
/// Static visual prototype only — no navigation or real interaction.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _ivory = Color(0xFFFDFBF7);
  static const Color _charcoal = Color(0xFF1E140F);
  static const Color _bodyText = Color(0xFF2C241C);
  static const Color _secondaryButton = Color(0xFFF2EBE1);
  static const Color _footerText = Color(0xFF8A7F74);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ivory,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 48),
              const Text(
                'TOWN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                  color: _charcoal,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Real communities.\nReal stories.\nNo noise.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.55,
                  color: _bodyText,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 36),
              const Expanded(
                child: Center(
                  child: _StreetIllustrationPlaceholder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: _charcoal,
                    foregroundColor: _ivory,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  child: const Text('Welcome'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: _secondaryButton,
                    foregroundColor: _charcoal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  child: const Text('Learn more'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'A local civic space for thoughtful neighbourhood stories.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: _footerText,
                  letterSpacing: 0.1,
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

/// Soft European street scene built from shapes and gradients only.
class _StreetIllustrationPlaceholder extends StatelessWidget {
  const _StreetIllustrationPlaceholder();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.15,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const RadialGradient(
            center: Alignment(0, -0.15),
            radius: 0.95,
            colors: [
              Color(0xFFF5EDE0),
              Color(0xFFEDE3D4),
              Color(0x00FDFBF7),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: const CustomPaint(
          painter: _StreetPainter(),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}

class _StreetPainter extends CustomPainter {
  const _StreetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final vanishing = Offset(w * 0.5, h * 0.38);

    // Soft sky wash
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          const Color(0xFFF8F3EA).withValues(alpha: 0.9),
          const Color(0xFFE8DCC8).withValues(alpha: 0.35),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.45));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.45), skyPaint);

    // Cobblestone street (perspective trapezoid)
    final streetPath = Path()
      ..moveTo(w * 0.08, h * 0.92)
      ..lineTo(w * 0.92, h * 0.92)
      ..lineTo(vanishing.dx + w * 0.04, vanishing.dy + h * 0.08)
      ..lineTo(vanishing.dx - w * 0.04, vanishing.dy + h * 0.08)
      ..close();

    final streetPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: const [
          Color(0xFFD4C4AE),
          Color(0xFFE2D5C0),
          Color(0xFFC9B89E),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.35, w, h * 0.6));
    canvas.drawPath(streetPath, streetPaint);

    // Center street line suggestion
    final centerLine = Paint()
      ..color = const Color(0xFFB8A68C).withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.5, h * 0.9),
      Offset(vanishing.dx, vanishing.dy + h * 0.1),
      centerLine,
    );

    // Left building block
    _drawBuildingBlock(
      canvas,
      Path()
        ..moveTo(w * 0.02, h * 0.88)
        ..lineTo(w * 0.28, h * 0.55)
        ..lineTo(vanishing.dx - w * 0.05, vanishing.dy + h * 0.05)
        ..lineTo(w * 0.02, h * 0.22)
        ..close(),
      const Color(0xFFC4B19A),
      const Color(0xFFA89278),
    );

    // Right building block
    _drawBuildingBlock(
      canvas,
      Path()
        ..moveTo(w * 0.98, h * 0.88)
        ..lineTo(w * 0.72, h * 0.55)
        ..lineTo(vanishing.dx + w * 0.05, vanishing.dy + h * 0.05)
        ..lineTo(w * 0.98, h * 0.22)
        ..close(),
      const Color(0xFFBFA88E),
      const Color(0xFF9E876C),
    );

    // Distant facade suggestion
    final facadePaint = Paint()
      ..color = const Color(0xFFD8C8B2).withValues(alpha: 0.85);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(vanishing.dx, vanishing.dy - h * 0.02),
          width: w * 0.14,
          height: h * 0.18,
        ),
        const Radius.circular(2),
      ),
      facadePaint,
    );

    // Soft tree canopies (left)
    _drawCanopy(canvas, Offset(w * 0.22, h * 0.52), w * 0.11, h * 0.09);
    _drawCanopy(canvas, Offset(w * 0.30, h * 0.46), w * 0.08, h * 0.07);

    // Soft tree canopies (right)
    _drawCanopy(canvas, Offset(w * 0.78, h * 0.52), w * 0.11, h * 0.09);
    _drawCanopy(canvas, Offset(w * 0.70, h * 0.46), w * 0.08, h * 0.07);

    // Edge vignette to blend into ivory background
    final vignette = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, 0.05),
        radius: 0.78,
        colors: [
          const Color(0x00FDFBF7),
          const Color(0x66FDFBF7),
          const Color(0xFFFDFBF7),
        ],
        stops: const [0.45, 0.78, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), vignette);
  }

  void _drawBuildingBlock(
    Canvas canvas,
    Path path,
    Color light,
    Color dark,
  ) {
    final bounds = path.getBounds();
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [light, dark],
      ).createShader(bounds);
    canvas.drawPath(path, paint);

    // Subtle window suggestions
    final windowPaint = Paint()
      ..color = const Color(0xFF8F7A62).withValues(alpha: 0.35);
    final midY = bounds.center.dy;
    for (var i = 0; i < 3; i++) {
      final y = midY - bounds.height * 0.2 + i * bounds.height * 0.18;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(bounds.center.dx, y),
            width: bounds.width * 0.12,
            height: bounds.height * 0.06,
          ),
          const Radius.circular(1),
        ),
        windowPaint,
      );
    }
  }

  void _drawCanopy(Canvas canvas, Offset center, double rx, double ry) {
    final paint = Paint()
      ..color = const Color(0xFF9AAB6E).withValues(alpha: 0.55);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
      paint,
    );
    final highlight = Paint()
      ..color = const Color(0xFFB8C882).withValues(alpha: 0.35);
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(-rx * 0.15, -ry * 0.2),
        width: rx * 1.2,
        height: ry * 1.1,
      ),
      highlight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
