import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';
import '../../constants/app_strings.dart';
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
  
  /// Handle logout with confirmation dialog
  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              _performLogout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  
  /// Perform the actual logout
  void _performLogout() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.logout();
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar('Error', 'Failed to logout');
    }
  }
}

