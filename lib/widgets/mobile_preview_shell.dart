import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Centers the app in a tall iPhone-like frame on wide screens.
/// On real phones (< 600px), the app uses the full device width.
class MobilePreviewShell extends StatelessWidget {
  const MobilePreviewShell({super.key, required this.child});

  final Widget child;

  static const double breakpoint = 600;
  static const double phoneWidth = 390;
  static const double phoneHeightTarget = 844; // iPhone-like tall screen

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final usePhoneFrame = constraints.maxWidth > breakpoint;

        if (!usePhoneFrame) {
          return ColoredBox(
            color: AppColors.background,
            child: child,
          );
        }

        final maxH = constraints.maxHeight;
        final phoneHeight = phoneHeightTarget.clamp(640.0, maxH - 16);
        final media = MediaQuery.of(context);

        return ColoredBox(
          color: const Color(0xFF1C1916),
          child: Center(
            child: SizedBox(
              width: phoneWidth,
              height: phoneHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.55),
                      blurRadius: 40,
                      spreadRadius: 2,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Thin device bezel
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF11100E),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(37),
                          child: MediaQuery(
                            data: media.copyWith(
                              size: Size(phoneWidth - 6, phoneHeight - 6),
                              padding: const EdgeInsets.only(
                                top: 14,
                                bottom: 12,
                              ),
                            ),
                            child: child,
                          ),
                        ),
                      ),
                      // Subtle notch hint
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 96,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xFF11100E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
