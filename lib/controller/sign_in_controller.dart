import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_strings.dart';
import '../services/auth_services.dart';
import '../utility/global.dart';
import '../view/bottomsheet/otp_verification_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'otp_verification_controller.dart';


class SignInController extends GetxController{
  final AuthServices authServices = AuthServices();

  final phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  // Auto-trigger disabled; OTP will be sent only on button tap


  Future<void> sendOTP() async {
    final mobile = phoneController.text.trim();

    if (mobile.isEmpty || mobile.length < 10) {
      //Get.snackbar(AppStrings.error, 'Enter a valid mobile number');
      ShowSnackBar.show(AppStrings.success,'Enter a valid mobile number');

      return;
    }

    isLoading.value = true;

    try {
      final response = await authServices.sendOtp(mobile);

      if (response.success && response.data?.otpSent == true) {
        ShowSnackBar.show(AppStrings.success, response.message);

        // Persist just the mobile number for later use
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('mobile_number', mobile);
        } catch (_) {}

        // Always clear OTP inputs before showing the sheet
        if (Get.isRegistered<OtpVerificationController>()) {
          Get.find<OtpVerificationController>().clearOtpFields();
        }

        Get.bottomSheet(
          OtpVerificationBottomSheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      }
      else {
        Get.snackbar('Failed', response.message.isNotEmpty ? response.message : 'Failed to send OTP');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // No onChanged auto-send; validation handled on button tap

  void loginWithFacebook() {
    // Add your Facebook login logic here
  }

  void loginWithGoogle() {
    // Add your Google login logic here
  }

  void loginWithApple() {
    // Add your Apple login logic here
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
