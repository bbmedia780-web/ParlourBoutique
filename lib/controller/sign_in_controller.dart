import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_services.dart';
import '../view/bottomsheet/otp_verification_bottom_sheet.dart';


class SignInController extends GetxController{
  final AuthServices authServices = AuthServices();

  final phoneController = TextEditingController();
  final RxBool isLoading = false.obs;


  Future<void> sendOTP() async {
    final mobile = phoneController.text.trim();

    if (mobile.isEmpty || mobile.length < 10) {
      Get.snackbar('Error', 'Enter a valid mobile number');
      return;
    }

    isLoading.value = true;

    try {
      final response = await authServices.sendOtp(mobile);

      if (response.success && response.data?.otpSent == true) {
        // OTP sent successfully
        Get.snackbar('Success', response.message);

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
