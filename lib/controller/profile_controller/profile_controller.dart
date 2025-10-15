import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parlour_app/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/common_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
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
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacing20),
        ),
        elevation: 10,
        backgroundColor: AppColors.white,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.spacing20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white,
                AppColors.softPink.withOpacity(0.3),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with gradient background
              Container(
                width: AppSizes.size80,
                height: AppSizes.size80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.pinkAccent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.white,
                  size: AppSizes.spacing36,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing24),
              
              // Title
              Text(
                AppStrings.logout,
                style: AppTextStyles.bottomSheetHeading.copyWith(
                  fontSize: AppSizes.largeHeading,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing12),
              
              // Description
              Text(
                AppStrings.logoutText,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.grey,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing32),
              
              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: AppButton(
                      text: AppStrings.cancel,
                      isPrimary: false,
                      onPressed: () => Get.back(),
                      height: AppSizes.spacing56,
                      borderRadius: AppSizes.buttonRadius,
                      textStyle: AppTextStyles.buttonText,
                    ),
                  ),
                  
                  const SizedBox(width: AppSizes.spacing16),
                  
                  // Logout button
                  Expanded(
                    child: Obx(() => AppButton(
                      text: AppStrings.logout,
                      isPrimary: true,
                      onPressed: authController.isLoading.value ? null : () {
                        Get.back();
                        _performLogout();
                      },
                      height: AppSizes.spacing56,
                      borderRadius: AppSizes.buttonRadius,
                      textStyle: AppTextStyles.buttonText,
                      isLoading: authController.isLoading.value,
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  // ---------------- Delete Account ----------------
  /// Show simple confirmation dialog before deleting account
  void _showDeleteAccountDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacing20),
        ),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simple icon
              Container(
                width: AppSizes.size80,
                height: AppSizes.size80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.primary,
                  size: AppSizes.spacing36,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing24),
              
              // Title
              Text(
                AppStrings.deleteAccount,
                style: AppTextStyles.bottomSheetHeading.copyWith(
                  fontSize: AppSizes.largeHeading,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing12),
              
              // Description
              Text(
                AppStrings.deleteAccountText,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.grey,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing32),
              
              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: AppButton(
                      text: AppStrings.cancel,
                      isPrimary: false,
                      onPressed: () => Get.back(),
                      height: AppSizes.spacing56,
                      borderRadius: AppSizes.buttonRadius,
                      textStyle: AppTextStyles.buttonText,
                    ),
                  ),
                  
                  const SizedBox(width: AppSizes.spacing16),
                  
                  // Delete button
                  Expanded(
                    child: AppButton(
                      text: AppStrings.delete,
                      isPrimary: true,
                      onPressed: () {
                        Get.back();
                        _openDeleteAccountUrl();
                      },
                      height: AppSizes.spacing56,
                      borderRadius: AppSizes.buttonRadius,
                      textStyle: AppTextStyles.buttonText.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Open delete account URL in browser
  Future<void> _openDeleteAccountUrl() async {
    final Uri url = Uri.parse(AppStrings.deleteAccountUrl);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      ShowToast.error('Could not open the delete account page. Please try again.');
    }
  }

}
