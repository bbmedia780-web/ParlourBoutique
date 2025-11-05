import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../common/common_button.dart';
import '../../common/common_text_form_field.dart';
import '../../constants/app_assets.dart';
import '../../controller/auth_controller/sign_in_controller.dart';
import '../../controller/auth_controller/otp_verification_controller.dart';
import '../../utility/global.dart';
import 'otp_verification_bottom_sheet.dart';

class LoginBottomSheet extends StatelessWidget {
  LoginBottomSheet({super.key});

  final SignInController signInController = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.spacing20),
          topRight: Radius.circular(AppSizes.spacing20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Container(
            width: double.infinity,
            height: AppSizes.size50,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
              vertical: AppSizes.spacing12,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(AppSizes.spacing12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: AppSizes.spacing28), // for symmetry
                Expanded(
                  child: Center(
                    child: Text(
                      AppStrings.login.tr,
                      style: AppTextStyles.bottomSheetHeading,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: AppSizes.spacing28,
                    height: AppSizes.spacing28,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.red, width: AppSizes.borderWidth1_5),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.red,
                      size: AppSizes.spacing16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacing24),

          // Title and description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
            child: Column(
              children: [
                Text(
                  AppStrings.loginToContinue.tr,
                  style: AppTextStyles.welcomePageTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spacing12),
                Text(
                  AppStrings.loginDescription.tr,
                  style: AppTextStyles.welcomePageDes,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacing32),

          // Phone number input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
            child: CommonTextField(
              controller: signInController.phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              prefixIcon: Padding(
                padding: const EdgeInsets.all(AppSizes.spacing8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing12,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(right: BorderSide(width: AppSizes.borderWidth1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.flag,
                        width: AppSizes.spacing24,
                        height: AppSizes.spacing16,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: AppSizes.spacing8),
                      Text(
                        AppStrings.countryCode.tr,
                        style: AppTextStyles.inputText,
                      ),
                    ],
                  ),
                ),
              ),
              hintText: AppStrings.enterMobileNumber.tr,
            ),
          ),

          const SizedBox(height: AppSizes.spacing32),

          // Send OTP Button
          Builder(
            builder: (context) {
              final bottomInset = MediaQuery.of(context).viewPadding.bottom;

              return Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.spacing20,
                  right: AppSizes.spacing20,
                  bottom: bottomInset + AppSizes.spacing20,
                ),
                child: Obx(
                  () => AppButton(
                    width: double.infinity,
                    height: AppSizes.spacing45,
                    textStyle: AppTextStyles.buttonText,
                    text: signInController.isLoading.value
                        ? AppStrings.pleaseWait.tr
                        : AppStrings.sendOtp.tr,
                    onPressed: signInController.isLoading.value
                        ? null
                        : () => _sendOtpAndShowVerification(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendOtpAndShowVerification() async {
    final mobile = signInController.phoneController.text.trim();

    if (mobile.isEmpty || mobile.length < 10) {
      // Dismiss keyboard before showing toast
      FocusScope.of(Get.context!).unfocus();
      // Add small delay to ensure keyboard is dismissed before showing toast
      await Future.delayed(const Duration(milliseconds: 100));
      ShowToast.error(AppStrings.mobileNumberInvalid);
      return;
    }

    // Show loading
    signInController.isLoading.value = true;

    try {
      final response = await signInController.authServices.sendOtp(mobile);

      if (response.success && response.data?.otpSent == true) {
        // Toast message removed - Success toasts are disabled per requirement

        // Clear OTP fields and close login bottom sheet
        Get.find<OtpVerificationController>().clearOtpFields();
        Get.back(); // Close login bottom sheet

        // Show OTP verification bottom sheet
        Get.bottomSheet(
          OtpVerificationBottomSheet(),
          isScrollControlled: true,
          backgroundColor: AppColors.transparent,
        );
      } else {
        // Dismiss keyboard before showing toast
        FocusScope.of(Get.context!).unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        ShowToast.error(response.message.isNotEmpty ? response.message : AppStrings.failedOtp);
      }
    } catch (e) {
      // Dismiss keyboard before showing toast
      FocusScope.of(Get.context!).unfocus();
      await Future.delayed(const Duration(milliseconds: 100));
      ShowToast.error(e.toString());
    } finally {
      signInController.isLoading.value = false;
    }
  }
}
