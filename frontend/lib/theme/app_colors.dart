import 'package:flutter/material.dart';

/// Centralized color palette for the application
/// Using a cyberpunk/terminal aesthetic with neon green and cyan accents
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFF00FF41); // Neon green
  static const Color primaryDark = Color(0xFF00CC33);
  static const Color primaryLight = Color(0xFF33FF66);

  // Secondary Colors
  static const Color secondary = Color(0xFF00D9FF); // Cyan
  static const Color secondaryDark = Color(0xFF00A8CC);
  static const Color secondaryLight = Color(0xFF33E0FF);

  // Background Colors
  static const Color background = Color(0xFF010409); // Almost black
  static const Color surface = Color(0xFF0D1117); // Dark blue-grey
  static const Color cardBackground = Color(0xFF161B22);

  // Text Colors
  static const Color textPrimary = Color(0xFF00FF41); // Neon green
  static const Color textSecondary = Color(0xFFB3B3B3); // Light grey
  static const Color textHint = Color(0xFF666666); // Medium grey
  static const Color textOnPrimary = Color(0xFF000000); // Black

  // Accent Colors
  static const Color error = Color(0xFFFF0055); // Hot pink
  static const Color success = Color(0xFF00FF41);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF00D9FF);

  // Border Colors
  static const Color border = Color(0xFF30363D);
  static const Color borderAccent = Color(0xFF00FF41);

  // Overlay Colors
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF00FF41),
    Color(0xFF00CC33),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFF010409),
    Color(0xFF0D1117),
  ];

  static const List<Color> cardGradient = [
    Color(0xFF161B22),
    Color(0xFF0D1117),
  ];

  // Opacity variants
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withValues(alpha: opacity);
  static Color textPrimaryWithOpacity(double opacity) =>
      textPrimary.withValues(alpha: opacity);
}
