import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parlour_app/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/modal_components.dart';
import '../../constants/app_strings.dart';
import '../../utility/global.dart';
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

      case AppStrings.menuItemDeleteAccount:
        _showDeleteAccountDialog();
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
  /// Show beautiful confirmation dialog before logging out
  void _showLogoutDialog() {
    ModalComponents.showConfirmationDialog(
      context: Get.context!,
      icon: Icons.logout_rounded,
      title: AppStrings.logout,
      description: AppStrings.logoutText,
      confirmButtonText: AppStrings.logout,
      onConfirm: _performLogout,
      isLoadingRx: authController.isLoading,
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

  // ---------------- Delete Account ----------------
  /// Show simple confirmation dialog before deleting account
  void _showDeleteAccountDialog() {
    ModalComponents.showConfirmationDialog(
      context: Get.context!,
      icon: Icons.delete_forever_rounded,
      title: AppStrings.deleteAccount,
      description: AppStrings.deleteAccountText,
      confirmButtonText: AppStrings.delete,
      onConfirm: _openDeleteAccountUrl,
    );
  }

  /// Open delete account URL in browser
  Future<void> _openDeleteAccountUrl() async {
    final Uri url = Uri.parse(AppStrings.deleteAccountUrl);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      ShowToast.error(AppStrings.couldNotOpenDeletePage);
    }
  }

}
