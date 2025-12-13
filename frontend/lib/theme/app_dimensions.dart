import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;
  static const double spacingXxxl = 48.0;

  static const double radiusXs = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;

  static BorderRadius get borderRadiusXs =>
      BorderRadius.circular(radiusXs);
  static BorderRadius get borderRadiusS =>
      BorderRadius.circular(radiusS);
  static BorderRadius get borderRadiusM =>
      BorderRadius.circular(radiusM);
  static BorderRadius get borderRadiusL =>
      BorderRadius.circular(radiusL);
  static BorderRadius get borderRadiusXl =>
      BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusXxl =>
      BorderRadius.circular(radiusXxl);

  static const double elevationNone = 0.0;
  static const double elevationXs = 2.0;
  static const double elevationS = 4.0;
  static const double elevationM = 8.0;
  static const double elevationL = 12.0;
  static const double elevationXl = 16.0;

  static const double iconXs = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 60.0;
  static const double iconXxxl = 80.0;
  static const double iconHuge = 100.0;

  static const double fontXxs = 10.0;
  static const double fontXs = 11.0;
  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXl = 18.0;
  static const double fontXxl = 20.0;
  static const double fontXxxl = 24.0;
  static const double fontHuge = 28.0;
  static const double fontMassive = 32.0;

  static const double letterSpacingTight = 0.5;
  static const double letterSpacingNormal = 1.0;
  static const double letterSpacingRelaxed = 1.2;
  static const double letterSpacingLoose = 1.5;
  static const double letterSpacingExtraLoose = 2.0;

  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(spacingXs);
  static const EdgeInsets paddingS = EdgeInsets.all(spacingS);
  static const EdgeInsets paddingM = EdgeInsets.all(spacingM);
  static const EdgeInsets paddingL = EdgeInsets.all(spacingL);
  static const EdgeInsets paddingXl = EdgeInsets.all(spacingXl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(spacingXxl);

  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: spacingS);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: spacingL);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: spacingXl);

  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: spacingS);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: spacingM);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: spacingL);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: spacingXl);

  static const double appBarHeight = kToolbarHeight;

  static const double bottomNavHeight = 60.0;

  static const double imageWidthS = 80.0;
  static const double imageWidthM = 120.0;
  static const double imageWidthL = 200.0;
  static const double imageWidthXl = 300.0;

  static const double imageHeightS = 120.0;
  static const double imageHeightM = 180.0;
  static const double imageHeightL = 300.0;
  static const double imageHeightXl = 450.0;
}
