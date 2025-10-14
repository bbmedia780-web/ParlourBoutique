import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../services/auth_services.dart';
import '../../utility/global.dart';
import '../../utility/validation_helper.dart';
import '../../utility/form_focus_helper.dart';
import '../../view/bottomsheet/otp_verification_bottom_sheet.dart';
import 'otp_verification_controller.dart';


class SignInController extends GetxController {
  // ==================== Dependencies ====================
  /// Service for authentication API calls
  final AuthServices authServices = AuthServices();

  // ==================== Controllers ====================
  /// Text field controller for phone number input
  TextEditingController phoneController = TextEditingController();
  
  // ==================== Focus Nodes ====================
  /// Focus node for phone number input
  FocusNode phoneFocusNode = FocusNode();

  // ==================== State ====================
  /// Loading state for OTP sending
  final RxBool isLoading = false.obs;
  
  /// Phone number validation error
  final RxString phoneError = ''.obs;
  
  /// Form validation state
  final RxBool isFormValid = false.obs;

  // ==================== Methods ====================
  
  /// Validates phone number and updates form state
  void validatePhone() {
    final error = ValidationHelper.validatePhone(phoneController.text);
    phoneError.value = error ?? '';
    updateFormValidity();
  }
  
  /// Updates form validity based on all field validations
  void updateFormValidity() {
    isFormValid.value = phoneError.value.isEmpty;
  }
  
  /// Validates all form fields
  bool validateForm() {
    validatePhone();
    return isFormValid.value;
  }

  Future<void> sendOTP(BuildContext context, ScrollController scrollController) async {
    if (isLoading.value) return; // prevent multiple API calls
    
    // Validate form before proceeding
    if (!validateForm()) {
      // Focus on phone field if validation fails
      FocusScope.of(context).requestFocus(phoneFocusNode);
      
      ShowToast.error(phoneError.value.isNotEmpty ? phoneError.value : AppStrings.mobileNumberInvalid);
      return;
    }
    
    final mobile = phoneController.text.trim();

    isLoading.value = true;

    try {
      final response = await authServices.sendOtp(mobile);

      if (response.success && response.data?.otpSent == true) {
        ShowToast.success(response.message);

        // Persist just the mobile number for later use
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('mobile_number', mobile);
        } catch (_) {}


        Get.find<OtpVerificationController>().clearOtpFields();


        if (!(Get.isBottomSheetOpen ?? false)) {
          Get.bottomSheet(
            OtpVerificationBottomSheet(),
            isScrollControlled: true,
            backgroundColor: AppColors.transparent,
          );
        }
      }
      else {
        ShowToast.error(response.message.isNotEmpty ? response.message : AppStrings.failedOtp);
      }
    } catch (e) {
      ShowToast.error(e.toString());

    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Social Login Methods ====================


  void loginWithFacebook() {}


  void loginWithGoogle() {}


  void loginWithApple() {}

  // ==================== Lifecycle ====================

  /// Cleanup resources when controller is removed
  @override
  void onClose() {
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.onClose();
  }
}

