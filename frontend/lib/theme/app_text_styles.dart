import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Reusable text styles for the application
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Headers
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryGreen,
    letterSpacing: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryGreen,
    letterSpacing: 1.5,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryGreen,
    letterSpacing: 1.5,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    color: AppColors.primaryCyan,
    letterSpacing: 1.0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    height: 1.5,
    color: AppColors.primaryGreen,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 16,
    color: AppColors.primaryGreen,
    letterSpacing: 1.0,
  );

  // Card text
  static const TextStyle cardTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 11,
  );

  static TextStyle cardSubtitle = TextStyle(
    fontSize: 9,
    color: AppColors.grey(600),
  );

  // Special styles
  static const TextStyle appBarTitle = TextStyle(
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
  );

  static TextStyle hintText = TextStyle(
    color: AppColors.primaryGreenLight(0.4),
    fontFamily: 'monospace',
  );

  static const TextStyle chipText = TextStyle(
    color: AppColors.primaryCyan,
    fontSize: 12,
    letterSpacing: 1.0,
  );

  // Utility methods for text with prefix
  static TextStyle withPrefix({
    double fontSize = 18,
    Color color = AppColors.primaryCyan,
    double letterSpacing = 1.0,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static String addPrefix(String text) => '> $text';
}
