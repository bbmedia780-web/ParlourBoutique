import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_style.dart';
import '../constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? borderRadius;
  final bool isLoading;
  final Color? backgroundColor;

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
    final bgColor = backgroundColor ?? (isPrimary ? AppColors.primary : AppColors.darkMediumGrey);
    final responsiveHeight = height ?? AppSizes.spacing45;
    final responsiveBorderRadius = borderRadius ?? AppSizes.buttonRadius;
    final responsivePadding = padding ?? EdgeInsets.symmetric(horizontal: AppSizes.spacing20, vertical: AppSizes.spacing12);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: responsiveHeight,
        minWidth: width ?? double.infinity,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
          ),
          padding: responsivePadding,
          alignment: Alignment.center,
        ),
        child: isLoading
            ? SizedBox(
                width: AppSizes.spacing24,
                height: AppSizes.spacing24,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textStyle ?? AppTextStyles.buttonText,
                ),
              ),
      ),
    );
  }
}
