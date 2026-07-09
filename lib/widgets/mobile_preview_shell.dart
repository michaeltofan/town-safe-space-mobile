import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Centers the app in a phone-sized frame on wide screens.
/// On real phones (< 600px), the app uses the full device width.
class MobilePreviewShell extends StatelessWidget {
  const MobilePreviewShell({super.key, required this.child});

  final Widget child;

  static const double breakpoint = 600;
  static const double phoneWidth = 402;
  static const double phoneAspect = 19.5 / 9; // tall mobile proportion

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

        final availableHeight = constraints.maxHeight - 48;
        final idealHeight = phoneWidth * phoneAspect;
        final phoneHeight = idealHeight.clamp(560.0, availableHeight);
        final media = MediaQuery.of(context);

        return ColoredBox(
          color: AppColors.previewBackdrop,
          child: Center(
            child: Container(
              width: phoneWidth,
              height: phoneHeight,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: const Color(0xFF3A322A),
                  width: 10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 56,
                    offset: const Offset(0, 22),
                  ),
                ],
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: MediaQuery(
                data: media.copyWith(
                  size: Size(phoneWidth, phoneHeight),
                  padding: EdgeInsets.only(
                    top: media.padding.top > 0 ? media.padding.top : 12,
                    bottom: media.padding.bottom > 0 ? media.padding.bottom : 10,
                  ),
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
