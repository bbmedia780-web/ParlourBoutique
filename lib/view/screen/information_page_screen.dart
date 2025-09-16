import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common_container_text_field.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../common/common_button.dart';
import '../../constants/app_text_style.dart';
import '../../controller/information_controller.dart';

class InformationScreen extends StatelessWidget {
  InformationScreen({super.key});

  final InformationController controller = Get.find<InformationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: AppSizes.spacing20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(AppStrings.information.tr, style: AppTextStyles.appBarText),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.spacing20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.fullName,
                        style: AppTextStyles.profilePageText,
                      ).paddingOnly(bottom: AppSizes.spacing8),
                      CommonContainerTextField(
                        controller: controller.fullNameController,
                        keyboardType: TextInputType.name,
                        textStyle: AppTextStyles.hintText,
                      ).paddingOnly(bottom: AppSizes.spacing24),

                      // Email Field
                      Text(
                        AppStrings.yourEmail,
                        style: AppTextStyles.profilePageText,
                      ).paddingOnly(bottom: AppSizes.spacing8),
                      CommonContainerTextField(
                        controller: controller.emailController,
                        textStyle: AppTextStyles.hintText,
                        keyboardType: TextInputType.emailAddress,
                      ).paddingOnly(bottom: AppSizes.spacing24),

                      // Date of Birth Field
                      Text(
                        AppStrings.dateOfBirth,
                        style: AppTextStyles.profilePageText,
                      ).paddingOnly(bottom: AppSizes.spacing8),
                      CommonContainerTextField(
                        controller: controller.dateOfBirthController,
                        textStyle: AppTextStyles.hintText,
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        onTap: () => controller.selectDate(context),
                        suffixIcon: Container(
                          height: AppSizes.size100,
                          width: AppSizes.size50,
                          decoration: BoxDecoration(
                            color: AppColors.lightPink,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(AppSizes.buttonRadius),
                              bottomRight: Radius.circular(
                                AppSizes.buttonRadius,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppAssets.calender,
                            color: AppColors.primary,
                            height: AppSizes.spacing26,
                          ),
                        ),
                      ).paddingOnly(bottom: AppSizes.spacing24),

                      // Gender Field
                      Text(
                        AppStrings.gender,
                        style: AppTextStyles.profilePageText,
                      ).paddingOnly(bottom: AppSizes.spacing8),
                      CommonContainerTextField(
                        controller: controller.genderController,
                        textStyle: AppTextStyles.hintText,
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        onTap: controller.selectGender,
                        suffixIcon: Container(
                          height: AppSizes.size100,
                          width: AppSizes.size50,
                          decoration: BoxDecoration(
                            color: AppColors.lightPink,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(AppSizes.buttonRadius),
                              bottomRight: Radius.circular(
                                AppSizes.buttonRadius,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                            size: AppSizes.spacing20,
                          ),
                        ),
                      ).paddingOnly(bottom: AppSizes.spacing24),
                    ],
                  ),
                ),
              ),
              // Fixed Button at Bottom
              Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewPadding.bottom;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: AppSizes.spacing20,
                      right: AppSizes.spacing20,
                      bottom: bottomInset + AppSizes.spacing20,
                      top: AppSizes.spacing20,
                    ),
                    child: AppButton(
                      width: double.infinity,
                      height: AppSizes.spacing45,
                      textStyle: AppTextStyles.buttonText,
                      text: AppStrings.continueText.tr,
                      onPressed: controller.continueToNext,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
