
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../common/common_button.dart';
import '../../constants/app_text_style.dart';
import '../../controller/auth_controller/otp_verification_controller.dart';

class OtpVerificationBottomSheet extends StatelessWidget {
  OtpVerificationBottomSheet({super.key});

  final OtpVerificationController controller = Get.find<OtpVerificationController>();


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
                      AppStrings.verification.tr,
                      style: AppTextStyles.bottomSheetHeading,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.closeBottomSheet,
                  child: Container(
                    width: AppSizes.spacing28,
                    height: AppSizes.spacing28,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.red, width: 1.5),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing18),
            child: Text(
              AppStrings.otpInstruction.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.welcomePageDes,
            ),
          ).paddingOnly(left: AppSizes.spacing20, right: AppSizes.spacing20),
          const SizedBox(height: AppSizes.spacing24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return Obx(
                    () => Container(
                  width: AppSizes.spacing54,
                  height: AppSizes.spacing54,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.showError.value
                          ? AppColors.red
                          : AppColors.mediumLightGray,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.spacing8),
                  ),
                  child: TextField(
                    controller: controller.otpControllers[index],
                    focusNode: controller.focusNodes[index],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: AppColors.primary,
                    cursorHeight: AppSizes.spacing28,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: AppTextStyles.welcomePageTitle,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(AppSizes.spacing8),
                      isCollapsed: true,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        // Move forward
                        if (index < controller.focusNodes.length - 1) {
                          controller.focusNodes[index + 1].requestFocus();
                        } else {
                          controller.focusNodes[index].unfocus(); // Close keyboard on last box
                        }
                      } else {
                        // Move backward on backspace
                        if (index > 0) {
                          controller.focusNodes[index - 1].requestFocus();
                        }
                      }
                    },
                    onSubmitted: (_) {
                      // Optional: close keyboard when user finishes
                      if (index == controller.focusNodes.length - 1) {
                        controller.focusNodes[index].unfocus();
                      }
                    },
                  ),
                ),
              );
            }),
          ).paddingOnly(left: AppSizes.spacing20, right: AppSizes.spacing20),

          const SizedBox(height: AppSizes.spacing12),

          Obx(
                () => controller.showError.value
                ? Text(
              controller.errorMessage.value,
              style: AppTextStyles.redText,
            ).paddingOnly(bottom: AppSizes.spacing24)
                : const SizedBox(height: AppSizes.spacing24),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(
                    () => GestureDetector(
                  onTap: controller.isResendEnabled.value
                      ? controller.resendOtp
                      : null,
                  child: controller.isResendEnabled.value
                      ? Text(
                    AppStrings.resend,
                    style: AppTextStyles.primaryButtonText,
                  )
                      : RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${AppStrings.resendOn} ",
                          style: AppTextStyles.hintText,
                        ),
                        TextSpan(
                          text:
                          "${controller.resendTimer.value.toString().padLeft(2, '0')}:${(controller.resendTimer.value % 60).toString().padLeft(2, '0')}",
                          style: AppTextStyles.primaryButtonText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ).paddingOnly(right: AppSizes.spacing16),
          const SizedBox(height: AppSizes.spacing24),

          Builder(
            builder: (context) {
              final bottomInset = MediaQuery.of(context).viewPadding.bottom;

              return Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.spacing16,
                  right: AppSizes.spacing16,
                  bottom: bottomInset + AppSizes.spacing20,
                ),
                child: AppButton(
                  width: double.infinity,
                  height: AppSizes.spacing45,
                  textStyle: AppTextStyles.buttonText,
                  text: AppStrings.continueText.tr,
                  onPressed: controller.continueVerification,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
