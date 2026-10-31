import 'package:flutter/material.dart';
import '../constants/ui_constants.dart';

class MinimalTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: UIConstants.background,
      colorScheme: const ColorScheme.light(
        primary: UIConstants.primary,
        secondary: UIConstants.secondary,
        surface: UIConstants.surface,
        error: UIConstants.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: UIConstants.textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: UIConstants.surface,
        foregroundColor: UIConstants.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: UIConstants.border,
        surfaceTintColor: UIConstants.surface,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: UIConstants.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: UIConstants.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusLG),
          side: const BorderSide(color: UIConstants.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UIConstants.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: UIConstants.textPrimary,
          side: const BorderSide(color: UIConstants.border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: UIConstants.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: UIConstants.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          borderSide: const BorderSide(color: UIConstants.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          borderSide: const BorderSide(color: UIConstants.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          borderSide: const BorderSide(color: UIConstants.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          borderSide: const BorderSide(color: UIConstants.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: UIConstants.textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: UIConstants.textTertiary, fontSize: 14),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w600, letterSpacing: -1.5),
        displayMedium: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w600, letterSpacing: -1),
        displaySmall: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w600, letterSpacing: -0.5),
        headlineLarge: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w600, letterSpacing: -0.5),
        headlineMedium: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w600, letterSpacing: -0.3),
        headlineSmall: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w600, letterSpacing: -0.2),
        titleLarge: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w600, letterSpacing: -0.2),
        titleMedium: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w500, letterSpacing: -0.2),
        titleSmall: TextStyle(color: UIConstants.textPrimary, fontWeight: FontWeight.w500, letterSpacing: -0.1),
        bodyLarge: TextStyle(color: UIConstants.textPrimary, fontSize: 16, height: 1.6, letterSpacing: -0.1),
        bodyMedium: TextStyle(color: UIConstants.textPrimary, fontSize: 14, height: 1.6, letterSpacing: -0.1),
        bodySmall: TextStyle(color: UIConstants.textSecondary, fontSize: 13, height: 1.5, letterSpacing: -0.1),
        labelLarge: TextStyle(color: UIConstants.textPrimary, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: -0.1),
        labelMedium: TextStyle(color: UIConstants.textSecondary, fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: -0.1),
        labelSmall: TextStyle(color: UIConstants.textTertiary, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0),
      ),
      dividerTheme: const DividerThemeData(
        color: UIConstants.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
