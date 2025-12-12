import 'package:flutter/material.dart';

/// Centralized color palette for the application
/// Using a warm bookstore aesthetic with rich browns, creams, and gold accents
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors - Rich brown leather tones
  static const Color primary = Color(0xFF8B4513); // Saddle brown
  static const Color primaryDark = Color(0xFF654321); // Dark brown
  static const Color primaryLight = Color(0xFFA0522D); // Sienna

  // Secondary Colors - Warm gold/amber
  static const Color secondary = Color(0xFFD4AF37); // Gold
  static const Color secondaryDark = Color(0xFFB8860B); // Dark goldenrod
  static const Color secondaryLight = Color(0xFFDAA520); // Goldenrod

  // Background Colors - Warm cream and parchment
  static const Color background = Color(0xFFF5F1E8); // Cream
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color cardBackground = Color(0xFFFFFAF0); // Floral white

  // Text Colors
  static const Color textPrimary = Color(0xFF2C1810); // Dark brown
  static const Color textSecondary = Color(0xFF6B4423); // Medium brown
  static const Color textHint = Color(0xFF9E8B7D); // Light brown
  static const Color textOnPrimary = Color(0xFFFFFAF0); // Cream

  // Accent Colors
  static const Color error = Color(0xFFDC3545); // Red
  static const Color success = Color(0xFF28A745); // Green
  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color info = Color(0xFF17A2B8); // Teal

  // Border Colors
  static const Color border = Color(0xFFD4C4B0); // Light tan
  static const Color borderAccent = Color(0xFF8B4513); // Saddle brown

  // Overlay Colors
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black

  // Gradient Colors
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

  // Opacity variants
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withValues(alpha: opacity);
  static Color textPrimaryWithOpacity(double opacity) =>
      textPrimary.withValues(alpha: opacity);
}
