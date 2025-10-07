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
