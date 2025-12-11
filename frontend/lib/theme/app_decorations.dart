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
      color: AppColors.backgroundMedium,
      border: Border.all(
        color: AppColors.primaryGreenLight(borderOpacity),
        width: 2,
      ),
    );
  }

  static BoxDecoration cardBackground = BoxDecoration(
    color: AppColors.grey(200),
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(AppSpacing.borderRadiusSM),
    ),
  );

  // Chip/Tag decoration
  static BoxDecoration chip = BoxDecoration(
    color: AppColors.backgroundMedium,
    border: Border.all(
      color: AppColors.primaryCyanLight(0.5),
      width: 1,
    ),
    borderRadius: AppSpacing.radiusSM,
  );

  // Button decoration
  static BoxDecoration addButton = BoxDecoration(
    color: AppColors.primaryGreenLight(0.9),
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Gradient backgrounds
  static BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.backgroundDark,
        AppColors.backgroundMedium,
        AppColors.primaryGreenLight(0.1),
      ],
    ),
  );

  // Input decoration
  static InputDecoration searchInputDecoration({
    String hintText = '> search_query...',
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.primaryGreenLight(0.4),
        fontFamily: 'monospace',
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.primaryGreen,
      ),
      suffixIcon: suffixIcon,
    );
  }

  // Border decorations
  static Border bottomBorder(BuildContext context) {
    return Border(
      bottom: BorderSide(
        color: AppColors.primaryGreen,
        width: 2,
      ),
    );
  }
}
