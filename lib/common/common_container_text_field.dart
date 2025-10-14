import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_style.dart';


class CommonContainerTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? hintText;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final bool showErrorBorder;
  final String? errorText;

  const CommonContainerTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.hintText,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.suffixIcon,
    this.textStyle,
    this.hintStyle,
    this.showErrorBorder = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AppSizes.size50,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: showErrorBorder ? AppColors.red : AppColors.mediumLightGray,
              width: showErrorBorder ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  cursorColor: AppColors.primary,
                  controller: controller,
                  keyboardType: keyboardType,
                  readOnly: readOnly,
                  enabled: enabled,
                  onTap: onTap,
                  onChanged: onChanged,
                  style: textStyle ?? AppTextStyles.welcomePageDes,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: hintStyle ?? AppTextStyles.hintText,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: AppSizes.spacing14),
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon!,
            ],
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spacing8, left: AppSizes.spacing14),
            child: Text(
              errorText!,
              style: AppTextStyles.hintText.copyWith(
                color: AppColors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
