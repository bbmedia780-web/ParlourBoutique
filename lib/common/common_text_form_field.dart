import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_style.dart';


class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final Color? cursorColor;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool showErrorBorder;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const CommonTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.cursorColor,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.showErrorBorder = false,
    this.errorText,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      cursorColor: cursorColor ?? AppColors.primary,
      style: AppTextStyles.inputText,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? AppColors.extraLightGrey : AppColors.lightGrey,
        hintText: hintText,
        hintStyle: AppTextStyles.hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: BorderSide.none,
        ),
        errorBorder: showErrorBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: BorderSide(
            color: AppColors.red,
            width: AppSizes.borderWidth1_5,
          ),
        ) : null,
        focusedErrorBorder: showErrorBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: BorderSide(
            color: AppColors.red,
            width: AppSizes.borderWidth1_5,
          ),
        ) : null,
      ),
    );
  }
}
