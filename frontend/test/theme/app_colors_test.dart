import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_store/theme/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    test('Primary colors are defined correctly', () {
      expect(AppColors.primary, const Color(0xFF00FF41));
      expect(AppColors.primaryDark, const Color(0xFF00CC33));
      expect(AppColors.primaryLight, const Color(0xFF33FF66));
    });

    test('Secondary colors are defined correctly', () {
      expect(AppColors.secondary, const Color(0xFF00D9FF));
      expect(AppColors.secondaryDark, const Color(0xFF00A8CC));
      expect(AppColors.secondaryLight, const Color(0xFF33E0FF));
    });

    test('Background colors are defined correctly', () {
      expect(AppColors.background, const Color(0xFF010409));
      expect(AppColors.surface, const Color(0xFF0D1117));
      expect(AppColors.cardBackground, const Color(0xFF161B22));
    });

    test('Text colors are defined correctly', () {
      expect(AppColors.textPrimary, const Color(0xFF00FF41));
      expect(AppColors.textSecondary, const Color(0xFFB3B3B3));
      expect(AppColors.textHint, const Color(0xFF666666));
      expect(AppColors.textOnPrimary, const Color(0xFF000000));
    });

    test('Accent colors are defined correctly', () {
      expect(AppColors.error, const Color(0xFFFF0055));
      expect(AppColors.success, const Color(0xFF00FF41));
      expect(AppColors.warning, const Color(0xFFFFAA00));
      expect(AppColors.info, const Color(0xFF00D9FF));
    });

    test('Border colors are defined correctly', () {
      expect(AppColors.border, const Color(0xFF30363D));
      expect(AppColors.borderAccent, const Color(0xFF00FF41));
    });

    test('Overlay colors are defined correctly', () {
      expect(AppColors.overlay, const Color(0x80000000));
      expect(AppColors.overlayLight, const Color(0x40000000));
    });

    test('Gradient colors are defined correctly', () {
      expect(AppColors.primaryGradient.length, 2);
      expect(AppColors.primaryGradient[0], const Color(0xFF00FF41));
      expect(AppColors.primaryGradient[1], const Color(0xFF00CC33));

      expect(AppColors.backgroundGradient.length, 2);
      expect(AppColors.backgroundGradient[0], const Color(0xFF010409));
      expect(AppColors.backgroundGradient[1], const Color(0xFF0D1117));

      expect(AppColors.cardGradient.length, 2);
      expect(AppColors.cardGradient[0], const Color(0xFF161B22));
      expect(AppColors.cardGradient[1], const Color(0xFF0D1117));
    });

    test('primaryWithOpacity returns color with correct opacity', () {
      final color = AppColors.primaryWithOpacity(0.5);
      // alpha is a double between 0 and 1 in the new Color API
      expect(color.a, closeTo(0.5, 0.01));
      expect(color.r, AppColors.primary.r);
      expect(color.g, AppColors.primary.g);
      expect(color.b, AppColors.primary.b);
    });

    test('secondaryWithOpacity returns color with correct opacity', () {
      final color = AppColors.secondaryWithOpacity(0.3);
      expect(color.a, closeTo(0.3, 0.01));
      expect(color.r, AppColors.secondary.r);
      expect(color.g, AppColors.secondary.g);
      expect(color.b, AppColors.secondary.b);
    });

    test('textPrimaryWithOpacity returns color with correct opacity', () {
      final color = AppColors.textPrimaryWithOpacity(0.7);
      expect(color.a, closeTo(0.7, 0.01));
      expect(color.r, AppColors.textPrimary.r);
      expect(color.g, AppColors.textPrimary.g);
      expect(color.b, AppColors.textPrimary.b);
    });

    test('Opacity methods handle edge cases', () {
      // Full opacity
      final fullOpacity = AppColors.primaryWithOpacity(1.0);
      expect(fullOpacity.a, closeTo(1.0, 0.01));

      // Zero opacity
      final zeroOpacity = AppColors.primaryWithOpacity(0.0);
      expect(zeroOpacity.a, closeTo(0.0, 0.01));
    });
  });
}
