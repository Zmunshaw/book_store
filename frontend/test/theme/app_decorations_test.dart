import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_store/theme/app_decorations.dart';
import 'package:book_store/theme/app_colors.dart';
import 'package:book_store/theme/app_spacing.dart';

void main() {
  group('AppDecorations Tests', () {
    test('containerDark returns BoxDecoration with correct properties', () {
      final decoration = AppDecorations.containerDark();

      expect(decoration.color, AppColors.surface);
      expect(decoration.border, isA<Border>());

      final border = decoration.border as Border;
      expect(border.top.width, 2);
      expect(border.top.color, AppColors.primaryWithOpacity(0.3));
    });

    test('containerDark accepts custom border opacity', () {
      final decoration = AppDecorations.containerDark(borderOpacity: 0.7);

      final border = decoration.border as Border;
      expect(border.top.color, AppColors.primaryWithOpacity(0.7));
    });

    test('cardBackground has correct properties', () {
      final decoration = AppDecorations.cardBackground;

      expect(decoration.color, AppColors.cardBackground);
      expect(decoration.borderRadius, isA<BorderRadiusGeometry>());
    });

    test('chip decoration has correct properties', () {
      final decoration = AppDecorations.chip;

      expect(decoration.color, AppColors.surface);
      expect(decoration.border, isA<Border>());
      expect(decoration.borderRadius, AppSpacing.radiusSM);

      final border = decoration.border as Border;
      expect(border.top.width, 1);
      expect(border.top.color, AppColors.secondaryWithOpacity(0.5));
    });

    test('addButton decoration has correct properties', () {
      final decoration = AppDecorations.addButton;

      expect(decoration.color, AppColors.primaryWithOpacity(0.9));
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);

      final shadow = decoration.boxShadow![0];
      expect(shadow.blurRadius, 4);
      expect(shadow.offset, const Offset(0, 2));
    });

    test('gradientBackground has correct gradient', () {
      final decoration = AppDecorations.gradientBackground;

      expect(decoration.gradient, isA<LinearGradient>());

      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);
      expect(gradient.colors.length, 3);
      expect(gradient.colors[0], AppColors.background);
      expect(gradient.colors[1], AppColors.surface);
      expect(gradient.colors[2], AppColors.primaryWithOpacity(0.1));
    });

    test('searchInputDecoration returns InputDecoration with correct properties', () {
      final decoration = AppDecorations.searchInputDecoration();

      expect(decoration.hintText, '> search_query...');
      expect(decoration.hintStyle, isNotNull);
      expect(decoration.hintStyle!.color, AppColors.primaryWithOpacity(0.4));
      expect(decoration.hintStyle!.fontFamily, 'monospace');
      expect(decoration.prefixIcon, isA<Icon>());

      final icon = decoration.prefixIcon as Icon;
      expect(icon.icon, Icons.search);
      expect(icon.color, AppColors.primary);
    });

    test('searchInputDecoration accepts custom hint text', () {
      final decoration = AppDecorations.searchInputDecoration(
        hintText: 'Custom hint',
      );

      expect(decoration.hintText, 'Custom hint');
    });

    test('searchInputDecoration accepts custom suffix icon', () {
      final customIcon = Icon(Icons.clear);
      final decoration = AppDecorations.searchInputDecoration(
        suffixIcon: customIcon,
      );

      expect(decoration.suffixIcon, customIcon);
    });

    testWidgets('bottomBorder returns Border with correct properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final border = AppDecorations.bottomBorder(context);

              expect(border.bottom.color, AppColors.primary);
              expect(border.bottom.width, 2);

              return Container();
            },
          ),
        ),
      );
    });

    test('All static decorations are non-null', () {
      expect(AppDecorations.cardBackground, isNotNull);
      expect(AppDecorations.chip, isNotNull);
      expect(AppDecorations.addButton, isNotNull);
      expect(AppDecorations.gradientBackground, isNotNull);
    });

    test('containerDark with different opacity values', () {
      final dec1 = AppDecorations.containerDark(borderOpacity: 0.1);
      final dec2 = AppDecorations.containerDark(borderOpacity: 0.5);
      final dec3 = AppDecorations.containerDark(borderOpacity: 1.0);

      expect(dec1, isNotNull);
      expect(dec2, isNotNull);
      expect(dec3, isNotNull);
    });
  });
}
