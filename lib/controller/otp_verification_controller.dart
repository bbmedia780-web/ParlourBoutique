import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/controller/sign_in_controller.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/auth_services.dart';
import '../utility/global.dart';
import 'auth_controller.dart';
import '../routes/app_routes.dart';

class OtpVerificationController extends GetxController {
  final AuthServices authServices = AuthServices();
  final RxBool isResendEnabled = false.obs;
  final RxInt resendTimer = 30.obs;
  final RxBool showError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isVerifying = false.obs;
  final RxBool isResending = false.obs;
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
    if (!isResendEnabled.value || isResending.value) return;

    try {
      isResending.value = true;
      // Get the SignInController instance
      final signInController = Get.find<SignInController>();
      final mobileNumber = signInController.phoneController.text.trim();

      if (mobileNumber.isEmpty) {
        ShowSnackBar.show(AppStrings.error,AppStrings.mobileNumberMissing,  backgroundColor: AppColors.red);
        return;
      }

      // Call API to resend OTP
      final response = await authServices.sendOtp(mobileNumber);

      if (response.success) {
        ShowSnackBar.show(AppStrings.otpResent,AppStrings.newOtpSent);
        startResendTimer(); // restart the resend timer
      } else {
        ShowSnackBar.show(AppStrings.failed, response.message.isNotEmpty ? response.message : 'Failed to resend OTP', backgroundColor: AppColors.red);
      }
    } catch (e) {
      ShowSnackBar.show(AppStrings.error, e.toString(), backgroundColor: AppColors.red);
    } finally {
      isResending.value = false;
    }
  }

  void continueVerification() async {
    if (isVerifying.value) return;
    String otp = otpControllers.map((controller) => controller.text).join();
    final mobile = Get.find<SignInController>().phoneController.text.trim();

    if (otp.length < 6) {
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
        ShowSnackBar.show(AppStrings.success,AppStrings.otpVerifiedSuccessfully, backgroundColor: AppColors.green);


        // Save all data via AuthController
        final authController = Get.find<AuthController>();
        final saved = await authController.saveLoginDataFromApi(response.data!);

        if (!saved) {
          ShowSnackBar.show(AppStrings.warning,AppStrings.failedSaveLoginData);
        }

        await authController.refreshFromPrefs();

        // Close bottom sheet
        Get.back();

        // Conditional navigation based on profile completion
        if (response.data?.profileCompleted == true) {
          // Existing user - navigate to Home Page using Get.offAll() to prevent going back to OTP
          Get.offAllNamed(AppRoutes.home);
        } else {
          // New user - navigate to Information Page using Get.offAll() to clear the navigation stack
          Get.offAllNamed(AppRoutes.information);
        }
      } else {
        showError.value = true;
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : AppStrings.invalidOtp;
        ShowSnackBar.show(AppStrings.failed, errorMessage.value, backgroundColor: AppColors.red);
      }
    } catch (e) {
      showError.value = true;
      errorMessage.value = e.toString();
      ShowSnackBar.show(AppStrings.error, errorMessage.value, backgroundColor: AppColors.red);
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
