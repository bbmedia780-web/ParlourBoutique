/*
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_style.dart';


class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.width,
    this.height,
    this.padding,
    this.textStyle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary ? AppColors.primary : AppColors.mediumLightGray;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSizes.buttonRadius, // default if not set
            ),
          ),
          padding: padding ?? EdgeInsets.zero,
          alignment: Alignment.center,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ?? AppTextStyles.buttonText,
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_style.dart';
import '../utility/responsive_helper.dart';
import '../constants/responsive_sizes.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? borderRadius;
  final bool isLoading; // ✅ built-in loader support
  final Color? backgroundColor; // optional customization

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.width,
    this.height,
    this.padding,
    this.textStyle,
    this.borderRadius,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ??
        (isPrimary ? AppColors.primary : AppColors.mediumLightGray);

    // Use responsive dimensions
    final responsiveHeight = height ?? ResponsiveSizes.getButtonHeight(context);
    final responsiveBorderRadius = borderRadius ?? ResponsiveSizes.getButtonRadius(context);
    final responsivePadding = padding ?? ResponsiveSizes.getButtonPadding(context);

    return SizedBox(
      width: width,
      height: responsiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // disable while loading
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
          ),
          padding: responsivePadding,
          alignment: Alignment.center,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: isLoading
            ? SizedBox(
          width: ResponsiveSizes.getSpacing24(context),
          height: ResponsiveSizes.getSpacing24(context),
          child: CircularProgressIndicator(
            color: AppColors.white,
            strokeWidth: 2.5,
          ),
        )
            : Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ?? AppTextStyles.buttonText,
        ),
      ),
    );
  }
}

