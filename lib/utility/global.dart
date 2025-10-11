import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_style.dart';

/// Global utility class for common UI components
///
/// Provides reusable widgets and utilities used throughout the app
class AppGlobal {
  /// Creates a common divider with customizable properties
  ///
  /// Parameters:
  /// - [indent]: Left indentation
  /// - [endIndent]: Right indentation
  /// - [thickness]: Divider thickness
  /// - [color]: Divider color
  ///
  /// Returns: A styled Divider widget
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

/// Utility class for displaying snackbar notifications
///
/// Provides a consistent way to show messages to users throughout the app
class ShowSnackBar {
  /// Shows a snackbar notification with title and message
  ///
  /// Parameters:
  /// - [title]: The title text
  /// - [message]: The message text
  /// - [backgroundColor]: Background color of the snackbar (default: primary color)
  ///
  /// Usage:
  /// ```dart
  /// ShowSnackBar.show('Success', 'Operation completed', backgroundColor: AppColors.green);
  /// ```
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


