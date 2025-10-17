import 'package:flutter/material.dart';
import '../utility/responsive_helper.dart';

class ResponsiveSizes {
  // Responsive font sizes
  static double getDisplayFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 32);
  }
  
  static double getLargeHeadingFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 28);
  }
  
  static double getHeadingFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 24);
  }
  
  static double getSubHeadingFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 20);
  }
  
  static double getTitleLargeFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 19);
  }
  
  static double getTitleFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 18);
  }
  
  static double getTitleSmallFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 17);
  }
  
  static double getBodyFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 16);
  }
  
  static double getBodySmallFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 15);
  }
  
  static double getCaptionFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 14);
  }
  
  static double getSmallFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(context, 12);
  }

  // Responsive spacing
  static double getSpacing2(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 2);
  }
  
  static double getSpacing4(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 4);
  }
  
  static double getSpacing8(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 8);
  }
  
  static double getSpacing12(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 12);
  }
  
  static double getSpacing16(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 16);
  }
  
  static double getSpacing20(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 20);
  }
  
  static double getSpacing24(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 24);
  }
  
  static double getSpacing32(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 32);
  }
  
  static double getSpacing40(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 40);
  }
  
  static double getSpacing48(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 48);
  }

  // Responsive dimensions
  static double getSize50(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 50);
  }
  
  static double getSize80(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 80);
  }
  
  static double getSize100(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 100);
  }
  
  static double getSize120(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 120);
  }
  
  static double getSize150(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 150);
  }
  
  static double getSize200(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 200);
  }
  
  static double getSize250(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 250);
  }
  
  static double getSize300(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 300);
  }
  
  static double getSize380(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 380);
  }

  // Responsive radius
  static double getButtonRadius(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 8);
  }
  
  static double getCardRadius(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 12);
  }

  // Responsive padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    return ResponsiveHelper.getResponsivePadding(context);
  }
  
  static EdgeInsets getCardPadding(BuildContext context) {
    final spacing = getSpacing16(context);
    return EdgeInsets.all(spacing);
  }
  
  static EdgeInsets getButtonPadding(BuildContext context) {
    final horizontal = getSpacing20(context);
    final vertical = getSpacing12(context);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  // Responsive margins
  static EdgeInsets getScreenMargin(BuildContext context) {
    final spacing = getSpacing20(context);
    return EdgeInsets.all(spacing);
  }
  
  static EdgeInsets getSectionMargin(BuildContext context) {
    final spacing = getSpacing24(context);
    return EdgeInsets.symmetric(vertical: spacing);
  }

  // Responsive heights
  static double getButtonHeight(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 45);
  }
  
  static double getAppBarHeight(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 56);
  }
  
  static double getBottomNavHeight(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(context, 80);
  }

  // Responsive widths
  static double getMaxContentWidth(BuildContext context) {
    final screenType = ResponsiveHelper.getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return double.infinity;
      case ScreenType.tablet:
        return 600;
      case ScreenType.desktop:
        return 800;
    }
  }

  static double getFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) return baseSize * 1.4; // tablet
    if (width > 600) return baseSize * 1.2; // large phones
    return baseSize;
  }
}
