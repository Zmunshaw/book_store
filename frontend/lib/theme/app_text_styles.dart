import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

/// Centralized text styles for the application
/// Terminal/cyberpunk aesthetic with neon green styling
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Base text style
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: 'Courier New',
    color: AppColors.textPrimary,
  );

  // Display Styles (Largest)
  static TextStyle displayLarge = _baseStyle.copyWith(
    fontSize: AppDimensions.fontMassive,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingExtraLoose,
  );

  static TextStyle displayMedium = _baseStyle.copyWith(
    fontSize: AppDimensions.fontHuge,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingLoose,
  );

  static TextStyle displaySmall = _baseStyle.copyWith(
    fontSize: AppDimensions.fontXxxl,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingRelaxed,
  );

  // Headline Styles
  static TextStyle headlineLarge = _baseStyle.copyWith(
    fontSize: AppDimensions.fontXxl,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingRelaxed,
  );

  static TextStyle headlineMedium = _baseStyle.copyWith(
    fontSize: AppDimensions.fontXl,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );

  static TextStyle headlineSmall = _baseStyle.copyWith(
    fontSize: AppDimensions.fontL,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );

  // Title Styles
  static TextStyle titleLarge = _baseStyle.copyWith(
    fontSize: AppDimensions.fontL,
    fontWeight: FontWeight.w600,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );

  static TextStyle titleMedium = _baseStyle.copyWith(
    fontSize: AppDimensions.fontM,
    fontWeight: FontWeight.w600,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );

  static TextStyle titleSmall = _baseStyle.copyWith(
    fontSize: AppDimensions.fontS,
    fontWeight: FontWeight.w600,
    letterSpacing: AppDimensions.letterSpacingTight,
  );

  // Body Styles
  static TextStyle bodyLarge = _baseStyle.copyWith(
    fontSize: AppDimensions.fontL,
    fontWeight: FontWeight.normal,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );

  static TextStyle bodyMedium = _baseStyle.copyWith(
    fontSize: AppDimensions.fontM,
    fontWeight: FontWeight.normal,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );

  static TextStyle bodySmall = _baseStyle.copyWith(
    fontSize: AppDimensions.fontS,
    fontWeight: FontWeight.normal,
    letterSpacing: AppDimensions.letterSpacingTight,
  );

  // Label Styles (Small text for UI elements)
  static TextStyle labelLarge = _baseStyle.copyWith(
    fontSize: AppDimensions.fontM,
    fontWeight: FontWeight.w500,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );

  static TextStyle labelMedium = _baseStyle.copyWith(
    fontSize: AppDimensions.fontS,
    fontWeight: FontWeight.w500,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );

  static TextStyle labelSmall = _baseStyle.copyWith(
    fontSize: AppDimensions.fontXs,
    fontWeight: FontWeight.w500,
    letterSpacing: AppDimensions.letterSpacingTight,
  );

  // Special Styles
  static TextStyle caption = _baseStyle.copyWith(
    fontSize: AppDimensions.fontS,
    color: AppColors.textSecondary,
    letterSpacing: AppDimensions.letterSpacingTight,
  );

  static TextStyle overline = _baseStyle.copyWith(
    fontSize: AppDimensions.fontXs,
    fontWeight: FontWeight.w600,
    letterSpacing: AppDimensions.letterSpacingLoose,
  );

  static TextStyle button = _baseStyle.copyWith(
    fontSize: AppDimensions.fontM,
    fontWeight: FontWeight.w600,
    letterSpacing: AppDimensions.letterSpacingRelaxed,
  );

  // Custom App-Specific Styles
  static TextStyle terminalHeader = _baseStyle.copyWith(
    fontSize: AppDimensions.fontXxxl,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingExtraLoose,
    color: AppColors.primary,
  );

  static TextStyle bookTitle = _baseStyle.copyWith(
    fontSize: AppDimensions.fontL,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingNormal,
    color: AppColors.textPrimary,
  );

  static TextStyle bookAuthor = _baseStyle.copyWith(
    fontSize: AppDimensions.fontM,
    fontWeight: FontWeight.normal,
    letterSpacing: AppDimensions.letterSpacingNormal,
    color: AppColors.textSecondary,
  );

  static TextStyle price = _baseStyle.copyWith(
    fontSize: AppDimensions.fontXl,
    fontWeight: FontWeight.bold,
    letterSpacing: AppDimensions.letterSpacingRelaxed,
    color: AppColors.secondary,
  );

  static TextStyle error = _baseStyle.copyWith(
    fontSize: AppDimensions.fontS,
    color: AppColors.error,
    letterSpacing: AppDimensions.letterSpacingNormal,
  );
}

/// Extension on TextStyle for convenient color modifications
extension TextStyleExtensions on TextStyle {
  TextStyle withPrimaryColor() => copyWith(color: AppColors.primary);
  TextStyle withSecondaryColor() => copyWith(color: AppColors.secondary);
  TextStyle withErrorColor() => copyWith(color: AppColors.error);
  TextStyle withTextSecondaryColor() => copyWith(color: AppColors.textSecondary);
  TextStyle withCustomColor(Color color) => copyWith(color: color);
}