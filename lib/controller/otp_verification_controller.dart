import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/controller/sign_in_controller.dart';
import 'dart:async';
import '../constants/app_strings.dart';
import '../services/auth_services.dart';
import 'auth_controller.dart';
import '../routes/app_routes.dart';

class OtpVerificationController extends GetxController {
  final AuthServices authServices = AuthServices();
  final RxBool isResendEnabled = false.obs;
  final RxInt resendTimer = 30.obs;
  final RxBool showError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isVerifying = false.obs;
  Timer? _timer;

  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  void startResendTimer() {
    isResendEnabled.value = false;
    resendTimer.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        isResendEnabled.value = true;
        timer.cancel();
      }
    });
  }

  /// Clear OTP inputs and related state before showing the bottom sheet
  void clearOtpFields() {
    print('[OtpVerificationController] 🧹 Clearing OTP input fields');
    for (final c in otpControllers) {
      c.text = '';
    }
    showError.value = false;
    errorMessage.value = '';
    isVerifying.value = false;
    for (final n in focusNodes) {
      n.unfocus();
    }
  }

  void resendOtp() async {
    if (!isResendEnabled.value) return;

    try {
      // Get the SignInController instance
      final signInController = Get.find<SignInController>();
      final mobileNumber = signInController.phoneController.text.trim();

      if (mobileNumber.isEmpty) {
        Get.snackbar('Error', 'Mobile number is missing');
        return;
      }

      // Call API to resend OTP
      final response = await authServices.sendOtp(mobileNumber);

      if (response.success) {
        Get.snackbar('OTP Resent', 'A new OTP has been sent to your number');
        startResendTimer(); // restart the resend timer
      } else {
        Get.snackbar('Failed', response.message.isNotEmpty ? response.message : 'Failed to resend OTP');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void continueVerification() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    final mobile = Get.find<SignInController>().phoneController.text.trim();

    if (otp.length < 4) {
      showError.value = true;
      errorMessage.value = AppStrings.invalidCode;
      return;
    }

    try {
      // Disable button while verifying
      isVerifying.value = true;

      // Call API
      final response = await authServices.verifyOtp(mobile, otp);

      if (response.success && response.data?.verified == true) {
        Get.snackbar('Success', 'OTP Verified Successfully');

        // Save all data via AuthController
        final authController = Get.find<AuthController>();
        final saved = await authController.saveLoginDataFromApi(response.data!);

        if (!saved) {
          Get.snackbar('Warning', 'Login successful but failed to save data locally');
        }

        await authController.refreshFromPrefs();

        // Close bottom sheet
        Get.back();

        // Conditional navigation based on profile completion
        if (response.data?.profileCompleted == true) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.toNamed(AppRoutes.information);
        }
      } else {
        showError.value = true;
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Invalid OTP';
      }
    } catch (e) {
      showError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isVerifying.value = false;
    }
  }

  void closeBottomSheet() {
    Get.back();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }
}
