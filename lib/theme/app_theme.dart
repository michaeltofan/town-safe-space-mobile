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
  static const Color previewBackdrop = Color(0xFF1A1612);
}

class AppTheme {
  static const String serifFamily = 'Georgia';
  static const List<String> serifFallback = [
    'Times New Roman',
    'Times',
    'serif',
  ];
  static const String sansFamily = 'Helvetica Neue';
  static const List<String> sansFallback = [
    'Helvetica',
    'Arial',
    'sans-serif',
  ];

  /// Horizontal padding tuned for a ~390–430px phone canvas.
  static const double screenPadding = 24;

  static TextStyle serif({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.text,
    double height = 1.25,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: serifFamily,
      fontFamilyFallback: serifFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle sans({
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.text,
    double height = 1.5,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: sansFamily,
      fontFamilyFallback: sansFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        labelStyle: sans(fontSize: 14, color: AppColors.mutedText),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: serif(
        fontSize: 44,
        fontWeight: FontWeight.w500,
        letterSpacing: 6,
        height: 1.05,
      ),
      displayMedium: serif(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 1.15,
      ),
      headlineLarge: serif(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
      headlineMedium: serif(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      titleLarge: serif(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      titleMedium: sans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodyLarge: sans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.55,
      ),
      bodyMedium: sans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        height: 1.5,
      ),
      bodySmall: sans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        height: 1.4,
      ),
      labelLarge: sans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.card,
        letterSpacing: 0.2,
      ),
    );
  }
}
