import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/constants/app_text_style.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';


class AppGlobal {

  static Widget commonDivider({
    double indent = 0,
    double endIndent = 0,
    double thickness = 1,
    Color color = Colors.grey,
  }) {
    return Divider(
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }

}

class ShowSnackBar {
  static void show(
      String title,
      String message, {
        Color backgroundColor = AppColors.primary,
      }) {
    Get.snackbar(
      '',
      '',
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(AppSizes.spacing16),
      borderRadius: AppSizes.spacing8,
      duration: const Duration(seconds: 3),
      titleText: Text(
        title,
        style: AppTextStyles.buttonText,
      ),
      messageText: Text(
        message,
        style: AppTextStyles.whiteNameText,
      ),
    );
  }
}


