import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parlour_app/routes/app_routes.dart';
import '../../common/common_button.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../auth_controller/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();


  // ---------------- Menu Navigation ----------------
  /// Handles navigation when a profile menu item is tapped
  void onMenuItemTapped(String item) {
    switch (item) {
      case AppStrings.menuItemAccount:
        Get.toNamed(AppRoutes.accountInformation);
        break;

      case AppStrings.menuItemFavourite:
        Get.toNamed(AppRoutes.favourite);
        break;

      case AppStrings.menuItemBooking:
        Get.toNamed(AppRoutes.booking);
        break;

      case AppStrings.menuItemPaymentHistory:
        Get.toNamed(AppRoutes.paymentHistory);
        break;

      case AppStrings.menuItemSettings:
        Get.toNamed(AppRoutes.settings);
        break;

      case AppStrings.menuItemHelpSupport:
        Get.toNamed(AppRoutes.helpSupport);
        break;

      case AppStrings.menuItemFaqs:
        Get.toNamed(AppRoutes.faqs);
        break;

      case AppStrings.menuItemLogout:
        _showLogoutDialog();
        break;
    }
  }

  /// ----------------- PROFILE IMAGE -----------------
  void onProfileImageTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
    //  authController.updateUserImage(image.path);
      authController.userImage(image.path);
    }
  }

  // ---------------- Logout ----------------
  /// Show confirmation dialog before logging out
  void _showLogoutDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacing12),
        ),
        title: Text(
          AppStrings.logout,
          style: AppTextStyles.bottomSheetHeading,
        ),
        content: Text(
          AppStrings.logoutText,
          style: AppTextStyles.bodyText,
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing12,
          vertical: AppSizes.spacing8,
        ),
        actions: [
          // Cancel Button
          AppButton(
            text: AppStrings.cancel,
            isPrimary: false,
            onPressed: () => Get.back(),
            height: AppSizes.spacing45,
            width: AppSizes.size100,
            borderRadius: AppSizes.spacing8,
            textStyle: AppTextStyles.buttonText,
          ),
          // Logout Button
          AppButton(
            text: AppStrings.logout,
            isPrimary: true,
            onPressed: () {
              Get.back();
              _performLogout();
            },
            height: AppSizes.spacing45,
            width: AppSizes.size100,
            borderRadius: AppSizes.spacing8,
            textStyle: AppTextStyles.buttonText,
          ),
        ],
      ),
    );
  }

  /// Perform logout using `AuthController`
  Future<void> _performLogout() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.logout();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
