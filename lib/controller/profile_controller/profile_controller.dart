import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';
import 'package:parlour_app/utility/global.dart';
import '../../common/common_button.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../auth_controller.dart';

class ProfileController extends GetxController {


  void onMenuItemTapped(String item) {
    switch (item) {
      case AppStrings.menuItemAccount:
      // Navigate to account information
        Get.toNamed(AppRoutes.accountInformation);
        break;

      case AppStrings.menuItemFavourite:
        Get.toNamed(AppRoutes.favourite);
        break;

      case AppStrings.menuItemBooking:
        Get.toNamed(AppRoutes.booking);
        break;

      case AppStrings.menuItemPaymentHistory:
      // Navigate to payment history
        Get.toNamed(AppRoutes.paymentHistory);
        break;
      case AppStrings.menuItemSettings:
      // Navigate to settings
        Get.toNamed(AppRoutes.settings);
        break;
      case AppStrings.menuItemHelpSupport:
      // Navigate to help & support
        Get.toNamed(AppRoutes.helpSupport);
        break;
      case AppStrings.menuItemFaqs:
      // Navigate to FAQs
        Get.toNamed(AppRoutes.faqs);
        break;
      case AppStrings.menuItemLogout:
      // Handle logout
        _handleLogout();
        break;
    }
  }


  void _handleLogout() {
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
          AppButton(
            text: AppStrings.cancel,
            isPrimary: true,
            onPressed: () {
              Get.back();
            },
            height: AppSizes.spacing30,
            width: AppSizes.size80,
            borderRadius: AppSizes.spacing6,
            textStyle: AppTextStyles.buttonText,
          ),
          AppButton(
            text: AppStrings.logout,
            isPrimary: true,
            onPressed: () {
              Get.back();
              _performLogout();
            },
            height: AppSizes.spacing30,
            width: AppSizes.size80,
            borderRadius: AppSizes.spacing6,
            textStyle: AppTextStyles.buttonText,
          ),
        ],
      ),
    );
  }

  void _performLogout() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.logout();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

}

