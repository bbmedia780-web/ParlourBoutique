import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common_button.dart';
import '../../common/common_text_form_field.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/auth_controller/sign_in_controller.dart';
import 'package:flutter/services.dart';



class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController controller = Get.find<SignInController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      /// Main content
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing20,
            vertical: AppSizes.spacing32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.size80),

              /// 🔹 Welcome Title
              Center(
                child: Column(
                  children: [
                    Text(
                      AppStrings.welcomeBack.tr,
                      style: AppTextStyles.welcomeBack,
                    ),
                    const SizedBox(height: AppSizes.spacing12),
                    Text(
                      AppStrings.welcomeBackDes.tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.welcomePageDes,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spacing40),

              /// 🔹 Phone Number Input
              Obx(() => CommonTextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (value) => controller.validatePhone(),
                showErrorBorder: controller.phoneError.value.isNotEmpty,
                errorText: controller.phoneError.value.isNotEmpty ? controller.phoneError.value : null,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(AppSizes.spacing8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing12,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(width: 1.0)),
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
              )),
              const SizedBox(height: AppSizes.spacing32),

              /// 🔹 Send OTP Button with inline loading
              Obx(
                () => AppButton(
                  width: double.infinity,
                  height: AppSizes.spacing45,
                  text: controller.isLoading.value
                      ? 'Please wait...'
                      : AppStrings.sendOtp.tr,
                  textStyle: AppTextStyles.buttonText,
                  onPressed: (controller.isLoading.value || !controller.isFormValid.value)
                      ? null
                      : () => controller.sendOTP(context, scrollController),
                ),
              ),

             /// [ Phase 2 ]
             /* Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppGlobal.commonDivider(
                          indent: AppSizes.spacing10,
                          endIndent: AppSizes.spacing10,
                        ),
                      ),
                      Text(
                        AppStrings.connectWith.tr,
                        style: AppTextStyles.hintText,
                      ),
                      Expanded(
                        child: AppGlobal.commonDivider(
                          indent: AppSizes.spacing10,
                          endIndent: AppSizes.spacing10,
                        ),
                      ),
                    ],
                  ).paddingOnly(
                    top: AppSizes.size50,
                    bottom: AppSizes.spacing32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialCircleButton(
                        assetPath: AppAssets.facebook,
                        onTap: controller.loginWithFacebook,
                        imageSize: AppSizes.spacing62, // slightly smaller
                      ),
                      const SizedBox(width: AppSizes.spacing8),
                      SocialCircleButton(
                        assetPath: AppAssets.google,
                        onTap: controller.loginWithGoogle,
                        imageSize: AppSizes.spacing62, // slightly bigger
                      ),
                      const SizedBox(width: AppSizes.spacing8),
                      SocialCircleButton(
                        assetPath: AppAssets.apple,
                        onTap: controller.loginWithApple,
                        imageSize: AppSizes.spacing62, // adjust based on look
                      ),
                    ],
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),

      /// 🔹 Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
        child: Text(
          AppStrings.brightBrewText.tr,
          style: AppTextStyles.hintText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
