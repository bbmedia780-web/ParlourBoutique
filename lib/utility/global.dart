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


enum ToastType { success, error, warning, info }

class ShowToast {
  static void show({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    IconData icon;
    Color color;
    Color backgroundColor;

    switch (type) {
      case ToastType.success:
        icon = Icons.check_circle;
        color = AppColors.toastSuccessIcon;
        backgroundColor = AppColors.toastSuccessBg;
        break;
      case ToastType.error:
        icon = Icons.error;
        color = AppColors.toastErrorIcon;
        backgroundColor = AppColors.toastErrorBg;
        break;
      case ToastType.warning:
        icon = Icons.warning;
        color = AppColors.toastWarningIcon;
        backgroundColor = AppColors.toastWarningBg;
        break;
      case ToastType.info:
        icon = Icons.info;
        color = AppColors.toastInfoIcon;
        backgroundColor = AppColors.toastInfoBg;
    }

    final overlay = Overlay.of(Get.overlayContext!);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        // Get keyboard height to position toast above it
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;
        // Position toast above keyboard if keyboard is open, otherwise use default bottom spacing
        final bottomPosition = keyboardHeight > 0
            ? keyboardHeight + AppSizes.spacing20
            : AppSizes.spacing20;

        return Positioned(
          bottom: bottomPosition,
          left: AppSizes.spacing20,
          right: AppSizes.spacing20,
          child: Material(
            color: AppColors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing12,
                vertical: AppSizes.spacing14,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(color: color, width: 1.5), // outline
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white,
                    blurRadius: AppSizes.spacing6,
                    offset: const Offset(0, AppSizes.spacing4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: color, size: AppSizes.spacing24),
                  const SizedBox(width: AppSizes.spacing12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: color,
                        fontSize: AppSizes.caption,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => overlayEntry.remove(),
                    child: Icon(Icons.close, color: color, size: AppSizes.spacing20),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }

  static void success(String message) =>
      show(message: message, type: ToastType.success);

  static void error(String message) =>
      show(message: message, type: ToastType.error);

  static void warning(String message) =>
      show(message: message, type: ToastType.warning);

  static void info(String message) =>
      show(message: message, type: ToastType.info);
}