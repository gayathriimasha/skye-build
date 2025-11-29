import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'aura_colors.dart';
import 'aura_typography.dart';

/// Aura Design System - Theme Configuration
class AuraTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AuraColors.deepSpace,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AuraColors.skyBlue,
        secondary: AuraColors.twilightPurple,
        tertiary: AuraColors.sunYellow,
        surface: AuraColors.surfaceDark,
        error: AuraColors.error,
        onPrimary: AuraColors.deepSpace,
        onSecondary: AuraColors.deepSpace,
        onSurface: AuraColors.textPrimary,
        onError: AuraColors.textPrimary,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AuraColors.textPrimary),
        titleTextStyle: AuraTypography.title,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: AuraColors.glassLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AuraColors.textSecondary,
        size: 24,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AuraTypography.display,
        displayMedium: AuraTypography.displaySmall,
        headlineLarge: AuraTypography.headline,
        titleLarge: AuraTypography.title,
        titleMedium: AuraTypography.subtitle,
        bodyLarge: AuraTypography.bodyLarge,
        bodyMedium: AuraTypography.body,
        bodySmall: AuraTypography.bodySmall,
        labelLarge: AuraTypography.label,
        labelMedium: AuraTypography.caption,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AuraColors.glassLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AuraColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AuraColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AuraColors.skyBlue, width: 2),
        ),
        hintStyle: AuraTypography.body.copyWith(color: AuraColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AuraColors.skyBlue,
          foregroundColor: AuraColors.deepSpace,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AuraTypography.subtitle,
        ),
      ),
    );
  }
}
