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
import '../../utility/global.dart';
import '../widget/social_button_widget.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController controller = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing20,
                    vertical: AppSizes.spacing40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TOP CONTENT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Welcome Text
                          Center(
                            child:
                                Text(
                                  AppStrings.welcomeBack.tr,
                                  style: AppTextStyles.welcomeBack,
                                ).paddingOnly(
                                  bottom: AppSizes.spacing12,
                                  top: AppSizes.size110,
                                ),
                          ),

                          /// Description
                          Text(
                            AppStrings.welcomeBackDes.tr,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.welcomePageDes,
                          ).paddingOnly(bottom: AppSizes.spacing24),

                          /// Phone Field
                          CommonTextField(
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(AppSizes.spacing8),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
                                decoration: const BoxDecoration(border: Border(right: BorderSide(width: 1.0)),),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      AppAssets.flag,
                                      width: AppSizes.spacing24,
                                      height: AppSizes.spacing16,
                                      fit: BoxFit.cover,
                                      scale: AppSizes.scaleSize,
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
                          ).paddingOnly(
                            bottom: AppSizes.spacing24,
                            top: AppSizes.spacing12,
                          ),

                          /// Send OTP Button
                          Builder(
                            builder: (context) {
                              final bottomInset = MediaQuery.of(context).viewPadding.bottom;
                              return Padding(
                                padding: EdgeInsets.only(bottom: bottomInset),
                                child: AppButton(
                                  width: double.infinity,
                                  height: AppSizes.spacing45,
                                  text: AppStrings.sendOtp.tr,
                                  textStyle: AppTextStyles.buttonText,
                                  onPressed: controller.sendOTP,
                                ),
                              );
                            },
                          ),

                          /// Divider and Social Login
                          Column(
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
                          ),
                        ],
                      ),

                      /// Bottom: Company Text
                      Center(
                        child: Text(
                          AppStrings.brightBrewText.tr,
                          style: AppTextStyles.hintText,
                        ),
                      ).paddingOnly(top: AppSizes.size250),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
          ),
          Obx(() => controller.isLoading.value
              ? Stack(children: [
                  ModalBarrier(dismissible: false, color: AppColors.black.withOpacity(0.38)),
                  const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ])
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
