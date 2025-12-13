import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF8B4513);
  static const Color primaryDark = Color(0xFF654321);
  static const Color primaryLight = Color(0xFFA0522D);

  static const Color secondary = Color(0xFFD4AF37);
  static const Color secondaryDark = Color(0xFFB8860B);
  static const Color secondaryLight = Color(0xFFDAA520);

  static const Color background = Color(0xFFF5F1E8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFAF0);

  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF6B4423);
  static const Color textHint = Color(0xFF9E8B7D);
  static const Color textOnPrimary = Color(0xFFFFFAF0);

  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  static const Color border = Color(0xFFD4C4B0);
  static const Color borderAccent = Color(0xFF8B4513);

  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  static const List<Color> primaryGradient = [
    Color(0xFF8B4513),
    Color(0xFF654321),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFFF5F1E8),
    Color(0xFFFFFFFF),
  ];

  static const List<Color> cardGradient = [
    Color(0xFFFFFAF0),
    Color(0xFFFFFFFF),
  ];

  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withValues(alpha: opacity);
  static Color textPrimaryWithOpacity(double opacity) =>
      textPrimary.withValues(alpha: opacity);
}
