import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../services/auth_services.dart';
import '../../utility/global.dart';
import '../../view/bottomsheet/otp_verification_bottom_sheet.dart';
import 'otp_verification_controller.dart';

/// SignInController - Manages sign-in screen logic
///
/// This controller handles the mobile number input and OTP sending
/// functionality for user authentication. It follows the MVVM pattern
/// where business logic is separated from the UI.
///
/// Responsibilities:
/// - Validate mobile number input
/// - Send OTP to the user's mobile
/// - Show OTP verification bottom sheet
/// - Handle loading states
/// - Social login triggers (Facebook, Google, Apple)
class SignInController extends GetxController {
  // ==================== Dependencies ====================
  /// Service for authentication API calls
  final AuthServices authServices = AuthServices();

  // ==================== Controllers ====================
  /// Text field controller for phone number input
  TextEditingController phoneController = TextEditingController();

  // ==================== State ====================
  /// Loading state for OTP sending
  final RxBool isLoading = false.obs;

  // ==================== Methods ====================

  /// Sends OTP to the entered mobile number
  ///
  /// Validates the mobile number, shows loading state, makes API call,
  /// and displays OTP verification bottom sheet on success.
  ///
  /// Validation:
  /// - Mobile number should not be empty
  /// - Mobile number should be at least 10 digits
  Future<void> sendOTP() async {
    if (isLoading.value) return; // prevent multiple API calls
    final mobile = phoneController.text.trim();

    if (mobile.isEmpty || mobile.length < 10) {
      ShowSnackBar.show(AppStrings.error,AppStrings.mobileNumberInvalid, backgroundColor: AppColors.red);
      return;
    }

    isLoading.value = true;

    try {
      final response = await authServices.sendOtp(mobile);

      if (response.success && response.data?.otpSent == true) {
        ShowSnackBar.show(AppStrings.success, response.message, backgroundColor: AppColors.green);

        // Persist just the mobile number for later use
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('mobile_number', mobile);
        } catch (_) {}

        // Always clear OTP inputs before showing the sheet
        if (Get.isRegistered<OtpVerificationController>()) {
          Get.find<OtpVerificationController>().clearOtpFields();
        }

        if (!(Get.isBottomSheetOpen ?? false)) {
          Get.bottomSheet(
            OtpVerificationBottomSheet(),
            isScrollControlled: true,
            backgroundColor: AppColors.transparent,
          );
        }
      }
      else {
        ShowSnackBar.show(AppStrings.failed,response.message.isNotEmpty ? response.message : AppStrings.failedOtp, backgroundColor: AppColors.red);
      }
    } catch (e) {
      ShowSnackBar.show(AppStrings.error,  e.toString(), backgroundColor: AppColors.red);

    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Social Login Methods ====================

  /// Handles Facebook login
  ///
  /// TODO: Implement Facebook SDK integration
  void loginWithFacebook() {
    // Implement Facebook login logic
  }

  /// Handles Google login
  ///
  /// TODO: Implement Google Sign-In integration
  void loginWithGoogle() {
    // Implement Google login logic
  }

  /// Handles Apple login
  ///
  /// TODO: Implement Sign in with Apple
  void loginWithApple() {
    // Implement Apple login logic
  }

  // ==================== Lifecycle ====================

  /// Cleanup resources when controller is removed
  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}

