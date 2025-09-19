import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../routes/app_routes.dart';
import '../services/auth_services.dart';
import '../utility/global.dart';
import 'auth_controller.dart';
import 'information_controller.dart';
import 'sign_in_controller.dart';

class OtpVerificationController extends GetxController {
  // ------------------ Services ------------------
  final _authServices = AuthServices();

  // ------------------ State ------------------
  final isResendEnabled = false.obs;
  final resendTimer = 30.obs;
  final isVerifying = false.obs;
  final isResending = false.obs;

  final showError = false.obs;
  final errorMessage = ''.obs;

  Timer? _timer;

  // OTP fields
  final otpControllers =
  List.generate(6, (_) => TextEditingController(), growable: false);
  final focusNodes = List.generate(6, (_) => FocusNode(), growable: false);

  // ------------------ Lifecycle ------------------
  @override
  void onInit() {
    super.onInit();
    _startResendTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final n in focusNodes) {
      n.dispose();
    }
    super.onClose();
  }

  // ------------------ OTP Helpers ------------------
  void clearOtpFields() {
    for (final c in otpControllers) {
      c.clear();
    }
    for (final n in focusNodes) {
      n.unfocus();
    }
    showError.value = false;
    errorMessage.value = '';
    isVerifying.value = false;
  }

  String get enteredOtp =>
      otpControllers.map((controller) => controller.text).join();

  // ------------------ Resend OTP ------------------
  void _startResendTimer() {
    isResendEnabled.value = false;
    resendTimer.value = 30;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        isResendEnabled.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    if (!isResendEnabled.value || isResending.value) return;

    try {
      isResending.value = true;

      final signInController = Get.find<SignInController>();
      final mobile = signInController.phoneController.text.trim();

      if (mobile.isEmpty) {
        ShowSnackBar.show(
          AppStrings.error,
          AppStrings.mobileNumberMissing,
          backgroundColor: AppColors.red,
        );
        return;
      }

      final response = await _authServices.sendOtp(mobile);

      if (response.success) {
        ShowSnackBar.show(AppStrings.otpResent, AppStrings.newOtpSent);
        _startResendTimer();
      } else {
        _showError(response.message.isNotEmpty
            ? response.message
            : AppStrings.failedResendOtp);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isResending.value = false;
    }
  }

  // ------------------ Verify OTP ------------------
  Future<void> continueVerification() async {
    if (isVerifying.value) return;

    final otp = enteredOtp;
    final mobile = Get.find<SignInController>().phoneController.text.trim();

    if (otp.length < 6) {
      _showError(AppStrings.invalidCode);
      return;
    }

    try {
      isVerifying.value = true;

      final response = await _authServices.verifyOtp(mobile, otp);

      if (response.success && response.data?.verified == true) {
        ShowSnackBar.show(
          AppStrings.success,
          AppStrings.otpVerifiedSuccessfully,
          backgroundColor: AppColors.green,
        );

        final authController = Get.find<AuthController>();
        final saved = await authController.login(response.data!);

        if (!saved) {
          ShowSnackBar.show(
            AppStrings.warning,
            AppStrings.failedSaveLoginData,
          );
        }

        await authController.refreshTokens();

        Get.back(); // close OTP sheet

        /// Navigate based on profile completion
        if (response.data?.profileCompleted == true) {
          // Existing user → Home
          Get.offAllNamed(AppRoutes.home);
        } else {
          // New user → clear old info
          final infoController = Get.find<InformationController>();
          infoController.reset(); // <-- add this here
          Get.offAllNamed(AppRoutes.information); // Navigate to Information Page
        }

      } else {
        _showError(response.message.isNotEmpty
            ? response.message
            : AppStrings.invalidOtp);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isVerifying.value = false;
    }
  }

  // ------------------ Helpers ------------------
  void closeBottomSheet() => Get.back();

  void _showError(String message) {
    showError.value = true;
    errorMessage.value = message;
    ShowSnackBar.show(AppStrings.failed, message,
        backgroundColor: AppColors.red);
  }
}
