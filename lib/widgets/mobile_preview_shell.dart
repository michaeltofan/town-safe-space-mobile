import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Centers the app in a phone-sized frame on wide screens.
/// On real phones (< 600px), the app uses the full device width.
class MobilePreviewShell extends StatelessWidget {
  const MobilePreviewShell({super.key, required this.child});

  final Widget child;

  static const double breakpoint = 600;
  static const double phoneWidth = 410;

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

        final phoneHeight = constraints.maxHeight;
        final media = MediaQuery.of(context);

        return ColoredBox(
          color: AppColors.previewBackdrop,
          child: Center(
            child: Container(
              width: phoneWidth,
              height: phoneHeight,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 48,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: MediaQuery(
                data: media.copyWith(
                  size: Size(phoneWidth, phoneHeight),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
