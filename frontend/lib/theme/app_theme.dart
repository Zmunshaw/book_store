import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: AppColors.primary,
        elevation: AppDimensions.elevationNone,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineMedium,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppDimensions.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusM,
          side: BorderSide(
            color: AppColors.primaryWithOpacity(0.2),
            width: AppDimensions.borderWidthThin,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusS,
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusS,
          borderSide: BorderSide(
            color: AppColors.primaryWithOpacity(0.5),
            width: AppDimensions.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusS,
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderWidthMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusS,
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusS,
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderWidthMedium,
          ),
        ),
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.primary,
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      iconTheme: IconThemeData(
        color: AppColors.primary,
        size: AppDimensions.iconM,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: AppDimensions.elevationS,
          padding: AppDimensions.paddingL,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusS,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: AppDimensions.paddingM,
          textStyle: AppTextStyles.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderWidthMedium,
          ),
          padding: AppDimensions.paddingL,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusS,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: AppDimensions.elevationM,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        elevation: AppDimensions.elevationM,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.border,
        thickness: AppDimensions.borderWidthThin,
        space: AppDimensions.spacingL,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryWithOpacity(0.2),
        circularTrackColor: AppColors.primaryWithOpacity(0.2),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTextStyles.bodyMedium,
        actionTextColor: AppColors.primary,
        elevation: AppDimensions.elevationL,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusS,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppDimensions.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusM,
          side: BorderSide(
            color: AppColors.primaryWithOpacity(0.3),
            width: AppDimensions.borderWidthThin,
          ),
        ),
        titleTextStyle: AppTextStyles.headlineMedium,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        deleteIconColor: AppColors.primary,
        disabledColor: AppColors.surface.withValues(alpha: 0.5),
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.secondary,
        padding: AppDimensions.paddingS,
        labelStyle: AppTextStyles.labelMedium,
        secondaryLabelStyle: AppTextStyles.labelMedium,
        brightness: Brightness.dark,
        elevation: AppDimensions.elevationXs,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusS,
          side: BorderSide(
            color: AppColors.primaryWithOpacity(0.3),
            width: AppDimensions.borderWidthThin,
          ),
        ),
      ),
    );
  }

  static LinearGradient get backgroundGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColors.backgroundGradient,
    );
  }

  static LinearGradient get cardGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColors.cardGradient,
    );
  }

  static LinearGradient get primaryGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColors.primaryGradient,
    );
  }

  static List<BoxShadow> get elevatedShadow {
    return [
      BoxShadow(
        color: AppColors.primaryWithOpacity(0.1),
        blurRadius: AppDimensions.elevationM,
        offset: const Offset(0, AppDimensions.spacingXs),
      ),
    ];
  }

  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: AppColors.primaryWithOpacity(0.15),
        blurRadius: AppDimensions.elevationL,
        offset: const Offset(0, AppDimensions.spacingS),
      ),
    ];
  }
}
