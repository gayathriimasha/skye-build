import 'package:flutter/material.dart';

class AppColors {
  // Primary Blue Palette
  static const Color navyBlue = Color(0xFF1A2642);
  static const Color deepBlue = Color(0xFF2C4A7C);
  static const Color skyBlue = Color(0xFF5A8CC9);
  static const Color softBlueWhite = Color(0xFFE8F1F9);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Weather-Adaptive Gradients
  static const List<Color> sunnyGradient = [
    Color(0xFF5A8CC9),
    Color(0xFF8AB5E6),
  ];

  static const List<Color> cloudyGradient = [
    Color(0xFF1A2642),
    Color(0xFF2C4A7C),
  ];

  static const List<Color> rainyGradient = [
    Color(0xFF1A2642),
    Color(0xFF2C4A7C),
  ];

  static const List<Color> nightGradient = [
    Color(0xFF0D1527),
    Color(0xFF1A2642),
  ];

  static const List<Color> snowyGradient = [
    Color(0xFF4A6B9C),
    Color(0xFF7A9EC9),
  ];

  // UI Component Colors
  static const Color cardBackground = Color(0xFFF5F8FC);
  static const Color textPrimary = Color(0xFF1A2642);
  static const Color textSecondary = Color(0xFF6B7C95);
  static const Color textTertiary = Color(0xFF9BABC4);

  // Overlay Colors
  static Color glassmorphicOverlay = Colors.white.withOpacity(0.1);
  static Color shadowColor = Colors.black.withOpacity(0.05);

  // State Colors
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);
}
