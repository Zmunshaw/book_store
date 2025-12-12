import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// Reusable box decorations and borders
class AppDecorations {
  // Private constructor to prevent instantiation
  AppDecorations._();

  // Container decorations
  static BoxDecoration containerDark({double borderOpacity = 0.3}) {
    return BoxDecoration(
      color: AppColors.surface,
      border: Border.all(
        color: AppColors.primaryWithOpacity(borderOpacity),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSM),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration cardBackground = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSM),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Chip/Tag decoration
  static BoxDecoration chip = BoxDecoration(
    color: AppColors.surface,
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
    borderRadius: AppSpacing.radiusSM,
  );

  // Button decoration
  static BoxDecoration addButton = BoxDecoration(
    color: AppColors.primary,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );

  // Gradient backgrounds
  static BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.background,
        AppColors.surface,
      ],
    ),
  );

  // Input decoration
  static InputDecoration searchInputDecoration({
    String hintText = 'Search books...',
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.textHint,
        fontFamily: 'Georgia',
      ),
      prefixIcon: Icon(
        Icons.search,
        color: AppColors.primary,
      ),
      suffixIcon: suffixIcon,
    );
  }

  // Border decorations
  static Border bottomBorder(BuildContext context) {
    return Border(
      bottom: BorderSide(
        color: AppColors.primary,
        width: 2,
      ),
    );
  }
}
