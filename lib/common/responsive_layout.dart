import 'package:flutter/material.dart';
import '../utility/responsive_helper.dart';
import '../constants/responsive_sizes.dart';
import '../constants/app_sizes.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final bool useScrollView;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool centerContent;
  final double? maxWidth;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.useSafeArea = true,
    this.useScrollView = false,
    this.padding,
    this.margin,
    this.centerContent = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    // Apply padding
    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    } else {
      content = Padding(
        padding: ResponsiveSizes.getScreenPadding(context),
        child: content,
      );
    }

    // Apply margin
    if (margin != null) {
      content = Container(
        margin: margin!,
        child: content,
      );
    }

    // Center content if needed
    if (centerContent) {
      content = Center(child: content);
    }

    // Apply max width constraint
    if (maxWidth != null || !context.isMobile) {
      final maxContentWidth = maxWidth ?? ResponsiveSizes.getMaxContentWidth(context);
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: content,
      );
    }

    // Wrap in scroll view if needed
    if (useScrollView) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    // Wrap in SafeArea if needed
    if (useSafeArea) {
      content = SafeArea(
        child: content,
      );
    }

    return content;
  }
}

// Responsive Grid Widget
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.gridColumns;
    final spacing = ResponsiveSizes.getSpacing8(context);
    
    return GridView.builder(
      padding: padding ?? ResponsiveSizes.getScreenPadding(context),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: childAspectRatio ?? 0.7,
        crossAxisSpacing: crossAxisSpacing ?? spacing,
        mainAxisSpacing: mainAxisSpacing ?? spacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

// Responsive Card Widget
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(ResponsiveSizes.getSpacing8(context)),
      child: Card(
        color: color ?? Colors.white,
        elevation: elevation ?? 2,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? 
            BorderRadius.circular(ResponsiveSizes.getCardRadius(context)),
        ),
        child: Padding(
          padding: padding ?? ResponsiveSizes.getCardPadding(context),
          child: child,
        ),
      ),
    );
  }
}

// Responsive Container Widget
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxDecoration? decoration;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? ResponsiveSizes.getCardPadding(context),
      decoration: decoration ?? BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? 
          BorderRadius.circular(ResponsiveSizes.getCardRadius(context)),
      ),
      child: child,
    );
  }
}

// Responsive Button Widget
class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? ResponsiveSizes.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding ?? ResponsiveSizes.getButtonPadding(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveSizes.getButtonRadius(context),
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppSizes.size24,
                height: AppSizes.size24,
                child: CircularProgressIndicator(
                  color: textColor ?? Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
