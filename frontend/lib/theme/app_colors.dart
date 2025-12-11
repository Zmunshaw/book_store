import 'package:flutter/material.dart';

/// Application color palette
/// Terminal/Hacker theme with green primary colors
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primaryGreen = Color(0xFF00FF41);
  static const Color primaryCyan = Color(0xFF00D9FF);
  static const Color primaryRed = Color(0xFFFF0055);

  // Background colors
  static const Color backgroundDark = Color(0xFF010409);
  static const Color backgroundMedium = Color(0xFF0D1117);

  // Opacity helpers
  static Color primaryGreenLight(double opacity) =>
      primaryGreen.withOpacity(opacity);
  static Color primaryCyanLight(double opacity) =>
      primaryCyan.withOpacity(opacity);
  static Color backgroundMediumLight(double opacity) =>
      backgroundMedium.withOpacity(opacity);

  // Grey scale
  static Color grey(int shade) {
    final greyShades = {
      200: Colors.grey[200]!,
      400: Colors.grey[400]!,
      600: Colors.grey[600]!,
    };
    return greyShades[shade] ?? Colors.grey;
  }
}
