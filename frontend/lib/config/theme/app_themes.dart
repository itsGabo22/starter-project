import 'package:flutter/material.dart';

/// Premium color palette used across the entire app.
class AppColors {
  // ── Dark Mode ──
  static const darkScaffold = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkCard = Color(0xFF1E293B);
  static const darkBorder = Color(0xFF334155);
  static const darkTextPrimary = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFF94A3B8);

  // ── Light Mode ──
  static const lightScaffold = Color(0xFFF8FAFC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE2E8F0);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF64748B);

  // ── Accent (shared) ──
  static const accent = Color(0xFF7C3AED);       // Purple electric
  static const accentLight = Color(0xFF8B5CF6);
  static const accentCyan = Color(0xFF06B6D4);
  static const warning = Color(0xFFF59E0B);       // Amber – drafts
  static const success = Color(0xFF10B981);       // Green – published
  static const error = Color(0xFFEF4444);
  
  // ── Newspaper Mode ──
  static const newspaperScaffold = Color(0xFFF4F1EA);
  static const newspaperTextPrimary = Color(0xFF1A1A1A);
  static const newspaperTextSecondary = Color(0xFF4A4A4A);
  static const newspaperAccent = Color(0xFF704214);

  // ── Gradients ──
  static const fabGradient = LinearGradient(
    colors: [accent, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const heroGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glassmorphism helpers (fake glass for list perf) ──
  static Color glassLight = Colors.white.withOpacity(0.08);
  static Color glassBorder = Colors.white.withOpacity(0.12);
}

/// Dark theme definition.
ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkScaffold,
    fontFamily: 'Muli',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accentCyan,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    ),
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkScaffold,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: 'Muli',
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSurface,
      contentTextStyle: const TextStyle(color: AppColors.darkTextPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.darkTextSecondary),
      border: InputBorder.none,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.darkTextPrimary),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.darkTextPrimary),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.darkTextPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkTextSecondary),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: AppColors.darkTextSecondary),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.accent.withOpacity(0.15),
      labelStyle: const TextStyle(color: AppColors.accentLight, fontSize: 12, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
  );
}

/// Newspaper (Classic) theme definition.
ThemeData newspaperTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.newspaperScaffold,
    fontFamily: 'Serif',
    colorScheme: const ColorScheme.light(
      primary: AppColors.newspaperAccent,
      secondary: AppColors.newspaperAccent,
      surface: AppColors.newspaperScaffold,
      error: AppColors.error,
    ),
    cardColor: AppColors.newspaperScaffold,
    dividerColor: AppColors.newspaperTextSecondary.withOpacity(0.2),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.newspaperScaffold,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.newspaperTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.newspaperTextPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        fontFamily: 'Serif',
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.newspaperTextPrimary, fontFamily: 'Serif', letterSpacing: -1.0, height: 1.1),
      headlineMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.newspaperTextPrimary, fontFamily: 'Serif', height: 1.1),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.newspaperTextPrimary, fontFamily: 'Serif', height: 1.2),
      titleMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.newspaperTextPrimary, fontFamily: 'Serif', height: 1.2),
      bodyLarge: TextStyle(fontSize: 18, color: AppColors.newspaperTextPrimary, fontFamily: 'Serif', height: 1.6),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.newspaperTextSecondary, fontFamily: 'Serif', height: 1.6),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: AppColors.newspaperTextSecondary, fontFamily: 'Serif'),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.transparent,
      labelStyle: const TextStyle(color: AppColors.newspaperTextPrimary, fontSize: 10, fontWeight: FontWeight.w900, fontFamily: 'Serif'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      side: const BorderSide(color: AppColors.newspaperTextPrimary, width: 1.5),
    ),
    // Use the explicit Data class if the combined class is causing issues
    cardTheme: const CardThemeData(
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

/// Light theme definition.
ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightScaffold,
    fontFamily: 'Muli',
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      secondary: AppColors.accentCyan,
      surface: AppColors.lightSurface,
      error: AppColors.error,
    ),
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.lightBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightScaffold,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: 'Muli',
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightSurface,
      contentTextStyle: const TextStyle(color: AppColors.lightTextPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.lightTextSecondary),
      border: InputBorder.none,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.lightTextPrimary),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.lightTextSecondary),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: AppColors.lightTextSecondary),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.accent.withOpacity(0.1),
      labelStyle: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
  );
}