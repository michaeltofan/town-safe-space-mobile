import 'package:flutter/material.dart';

/// Premium calm editorial design tokens for the Town visual MVP.
class AppColors {
  static const Color background = Color(0xFFF8F3EA);
  static const Color primary = Color(0xFF2B1F12);
  static const Color text = Color(0xFF24221F);
  static const Color mutedText = Color(0xFF6F675D);
  static const Color card = Color(0xFFFFFCF6);
  static const Color border = Color(0x332B1F12);
  static const Color softWarm = Color(0xFFE8DFD0);
  static const Color softAccent = Color(0xFFC4B5A0);
}

class AppTheme {
  static const String serifFallback = 'Georgia';
  static const String sansFallback = 'Helvetica Neue';

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.card,
        surface: AppColors.card,
        onSurface: AppColors.text,
        secondary: AppColors.mutedText,
        outline: AppColors.border,
      ),
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        labelStyle: const TextStyle(
          color: AppColors.mutedText,
          fontFamily: sansFallback,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: const TextStyle(
        fontFamily: serifFallback,
        fontSize: 48,
        fontWeight: FontWeight.w600,
        letterSpacing: 4,
        color: AppColors.text,
        height: 1.1,
      ),
      displayMedium: const TextStyle(
        fontFamily: serifFallback,
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.2,
      ),
      headlineLarge: const TextStyle(
        fontFamily: serifFallback,
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.25,
      ),
      headlineMedium: const TextStyle(
        fontFamily: serifFallback,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.3,
      ),
      titleLarge: const TextStyle(
        fontFamily: serifFallback,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.3,
      ),
      titleMedium: const TextStyle(
        fontFamily: sansFallback,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
        height: 1.4,
      ),
      bodyLarge: const TextStyle(
        fontFamily: sansFallback,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
        height: 1.55,
      ),
      bodyMedium: const TextStyle(
        fontFamily: sansFallback,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        height: 1.5,
      ),
      bodySmall: const TextStyle(
        fontFamily: sansFallback,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        height: 1.4,
      ),
      labelLarge: const TextStyle(
        fontFamily: sansFallback,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.card,
        letterSpacing: 0.2,
      ),
    );
  }
}
