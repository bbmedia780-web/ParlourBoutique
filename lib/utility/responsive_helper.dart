import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Get screen type
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  // Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }

  // Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.desktop;
  }

  // Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ScreenType.tablet:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
      case ScreenType.desktop:
        return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    }
  }

  // Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return baseFontSize;
      case ScreenType.tablet:
        return baseFontSize * 1.2;
      case ScreenType.desktop:
        return baseFontSize * 1.4;
    }
  }

  // Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return baseSpacing;
      case ScreenType.tablet:
        return baseSpacing * 1.5;
      case ScreenType.desktop:
        return baseSpacing * 2.0;
    }
  }

  // Get responsive width percentage
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  // Get responsive height percentage
  static double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  // Get safe area aware height
  static double getSafeAreaHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - 
           mediaQuery.padding.top - 
           mediaQuery.padding.bottom;
  }

  // Get safe area aware width
  static double getSafeAreaWidth(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width - 
           mediaQuery.padding.left - 
           mediaQuery.padding.right;
  }

  // Get responsive grid columns
  static int getResponsiveGridColumns(BuildContext context) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return 2;
      case ScreenType.tablet:
        return 3;
      case ScreenType.desktop:
        return 4;
    }
  }

  // Get responsive card width
  static double getResponsiveCardWidth(BuildContext context) {
    final screenType = getScreenType(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    switch (screenType) {
      case ScreenType.mobile:
        return screenWidth * 0.45; // 2 columns with spacing
      case ScreenType.tablet:
        return screenWidth * 0.3; // 3 columns with spacing
      case ScreenType.desktop:
        return screenWidth * 0.22; // 4 columns with spacing
    }
  }

  // Get responsive image height
  static double getResponsiveImageHeight(BuildContext context, double aspectRatio) {
    final screenType = getScreenType(context);
    final cardWidth = getResponsiveCardWidth(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return cardWidth / aspectRatio;
      case ScreenType.tablet:
        return (cardWidth / aspectRatio) * 1.2;
      case ScreenType.desktop:
        return (cardWidth / aspectRatio) * 1.4;
    }
  }
}

enum ScreenType {
  mobile,
  tablet,
  desktop,
}

// Extension for easy access
extension ResponsiveExtension on BuildContext {
  ScreenType get screenType => ResponsiveHelper.getScreenType(this);
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get safeAreaHeight => ResponsiveHelper.getSafeAreaHeight(this);
  double get safeAreaWidth => ResponsiveHelper.getSafeAreaWidth(this);
  
  EdgeInsets get responsivePadding => ResponsiveHelper.getResponsivePadding(this);
  int get gridColumns => ResponsiveHelper.getResponsiveGridColumns(this);
  double get cardWidth => ResponsiveHelper.getResponsiveCardWidth(this);
}
