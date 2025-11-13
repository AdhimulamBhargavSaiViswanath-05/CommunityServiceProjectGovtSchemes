import 'package:flutter/material.dart';

class Responsive {
  // Screen breakpoints
  static const double mobileSmall = 340;
  static const double mobile = 600;
  static const double tablet = 1200;

  // Check device types
  static bool isVerySmallMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileSmall;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet;

  /// Get screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Get screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Get responsive padding
  static EdgeInsets pagePadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return const EdgeInsets.all(12);
    } else if (width < mobile) {
      return const EdgeInsets.all(16);
    } else if (width < tablet) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 32);
    }
  }

  /// Get responsive horizontal padding
  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileSmall) return 12;
    if (width < mobile) return 16;
    if (width < tablet) return 24;
    return 48;
  }

  /// Get responsive vertical padding
  static double verticalPadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileSmall) return 8;
    if (width < mobile) return 12;
    if (width < tablet) return 16;
    return 24;
  }

  /// Get responsive font size
  static double fontSize(BuildContext context, {required double mobile}) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return mobile * 0.85; // 15% smaller for very small screens
    } else if (width < Responsive.mobile) {
      return mobile;
    } else if (width < tablet) {
      return mobile * 1.1;
    } else {
      return mobile * 1.2;
    }
  }

  /// Get responsive spacing
  static double spacing(BuildContext context, {required double mobile}) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return mobile * 0.75;
    } else if (width < Responsive.mobile) {
      return mobile;
    } else if (width < tablet) {
      return mobile * 1.5;
    } else {
      return mobile * 2;
    }
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, {required double mobile}) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return mobile * 0.8;
    } else if (width < Responsive.mobile) {
      return mobile;
    } else {
      return mobile * 1.2;
    }
  }

  /// Get responsive card width
  static double cardWidth(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobile) {
      return width - (horizontalPadding(context) * 2);
    } else if (width < tablet) {
      return width * 0.7;
    } else {
      return 600;
    }
  }

  /// Get number of grid columns
  static int gridColumns(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileSmall) return 1;
    if (width < mobile) return 1;
    if (width < tablet) return 2;
    return 3;
  }

  /// Get max content width for readability
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1200;
    }
    return double.infinity;
  }

  /// Get app bar height
  static double appBarHeight(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileSmall) return 100;
    if (width < 360) return 105;
    if (width < mobile) return 115;
    return 140;
  }

  /// Get button height
  static double buttonHeight(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileSmall) return 42;
    if (width < mobile) return 48;
    return 54;
  }

  /// Get card border radius
  static double borderRadius(BuildContext context, {double base = 16}) {
    final width = screenWidth(context);
    if (width < mobileSmall) return base * 0.75;
    return base;
  }
}

/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (Responsive.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Centered max-width container for content
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Responsive.maxContentWidth(context),
        ),
        child: child,
      ),
    );
  }
}
