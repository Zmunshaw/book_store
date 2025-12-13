import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 2.0;
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;

  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);

  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);

  static const SizedBox verticalSpaceXS = SizedBox(height: xs);
  static const SizedBox verticalSpaceSM = SizedBox(height: sm);
  static const SizedBox verticalSpaceMD = SizedBox(height: md);
  static const SizedBox verticalSpaceLG = SizedBox(height: lg);
  static const SizedBox verticalSpaceXL = SizedBox(height: xl);
  static const SizedBox verticalSpaceXXL = SizedBox(height: xxl);

  static const SizedBox horizontalSpaceXS = SizedBox(width: xs);
  static const SizedBox horizontalSpaceSM = SizedBox(width: sm);
  static const SizedBox horizontalSpaceMD = SizedBox(width: md);
  static const SizedBox horizontalSpaceLG = SizedBox(width: lg);
  static const SizedBox horizontalSpaceXL = SizedBox(width: xl);
  static const SizedBox horizontalSpaceXXL = SizedBox(width: xxl);

  static const double gridCrossAxisSpacing = lg;
  static const double gridMainAxisSpacing = lg;

  static const double borderRadiusSM = 4.0;
  static const double borderRadiusMD = 8.0;
  static const double borderRadiusLG = 12.0;
  static const double borderRadiusCircle = 20.0;

  static BorderRadius radiusSM = BorderRadius.circular(borderRadiusSM);
  static BorderRadius radiusMD = BorderRadius.circular(borderRadiusMD);
  static BorderRadius radiusLG = BorderRadius.circular(borderRadiusLG);
  static BorderRadius radiusCircle = BorderRadius.circular(borderRadiusCircle);

  static const double iconSM = 16.0;
  static const double iconMD = 20.0;
  static const double iconLG = 60.0;
  static const double iconXL = 80.0;
  static const double iconXXL = 100.0;

  static const double coverImageHeight = 300.0;
  static const double coverImageWidth = 200.0;

  static const double elevationCard = 4.0;
}
