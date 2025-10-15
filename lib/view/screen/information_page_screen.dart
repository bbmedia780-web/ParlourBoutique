import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common_container_text_field.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../common/common_button.dart';
import '../../constants/app_text_style.dart';
import '../../controller/auth_controller/information_controller.dart';
import '../../routes/app_routes.dart';

class InformationScreen extends StatelessWidget {
  InformationScreen({super.key});

  final InformationController controller = Get.find<InformationController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
        /*  leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.black,
              size: AppSizes.spacing20,
            ),
            onPressed: () => Get.offAllNamed(AppRoutes.home),
          ),*/
          title:
          Text(AppStrings.information.tr, style: AppTextStyles.appBarText),
          centerTitle: true,
        ),

        // ✅ Main Content
        body: SafeArea(
          child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSizes.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              Text(AppStrings.fullName, style: AppTextStyles.profilePageText)
                  .paddingOnly(bottom: AppSizes.spacing8),
              Obx(() => CommonContainerTextField(
                controller: controller.fullNameController,
                keyboardType: TextInputType.name,
                textStyle: AppTextStyles.hintText,
                onChanged: (value) => controller.validateFullName(),
                showErrorBorder: controller.fullNameError.value.isNotEmpty,
                errorText: controller.fullNameError.value.isNotEmpty ? controller.fullNameError.value : null,
              )).paddingOnly(bottom: AppSizes.spacing24),

              // Email
              Text(AppStrings.yourEmail, style: AppTextStyles.profilePageText)
                  .paddingOnly(bottom: AppSizes.spacing8),
              Obx(() => CommonContainerTextField(
                controller: controller.emailController,
                textStyle: AppTextStyles.hintText,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => controller.validateEmail(),
                showErrorBorder: controller.emailError.value.isNotEmpty,
                errorText: controller.emailError.value.isNotEmpty ? controller.emailError.value : null,
              )).paddingOnly(bottom: AppSizes.spacing24),

              // DOB
              Text(AppStrings.dateOfBirth, style: AppTextStyles.profilePageText).paddingOnly(bottom: AppSizes.spacing8),
              Obx(() => CommonContainerTextField(
                controller: controller.dateOfBirthController,
                textStyle: AppTextStyles.hintText,
                keyboardType: TextInputType.none,
                readOnly: true,
                onTap: () => controller.selectDate(context),
                showErrorBorder: controller.dateOfBirthError.value.isNotEmpty,
                errorText: controller.dateOfBirthError.value.isNotEmpty ? controller.dateOfBirthError.value : null,
                suffixIcon: InkWell(
                  onTap: () => controller.selectDate(context),
                  child: Container(
                    height: AppSizes.size100,
                    width: AppSizes.size50,
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppSizes.buttonRadius),
                        bottomRight:
                        Radius.circular(AppSizes.buttonRadius),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppAssets.calender,
                      color: AppColors.primary,
                      height: AppSizes.spacing26,
                    ),
                  ),
                ),
              )).paddingOnly(bottom: AppSizes.spacing24),

              // Gender
              Text(AppStrings.gender, style: AppTextStyles.profilePageText)
                  .paddingOnly(bottom: AppSizes.spacing8),
              Obx(() => CommonContainerTextField(
                controller: controller.genderController,
                textStyle: AppTextStyles.hintText,
                keyboardType: TextInputType.none,
                readOnly: true,
                onTap: controller.selectGender,
                showErrorBorder: controller.genderError.value.isNotEmpty,
                errorText: controller.genderError.value.isNotEmpty ? controller.genderError.value : null,
                suffixIcon: InkWell(
                  onTap: controller.selectGender,
                  child: Container(
                    height: AppSizes.size100,
                    width: AppSizes.size50,
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppSizes.buttonRadius),
                        bottomRight:
                        Radius.circular(AppSizes.buttonRadius),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                      size: AppSizes.spacing20,
                    ),
                  ),
                ),
              )).paddingOnly(bottom: AppSizes.spacing24),
            ],
          ),
          ),
        ),

        // ✅ Bottom Button with Safe Padding
        bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.symmetric(
            horizontal: AppSizes.spacing20,
            vertical: AppSizes.spacing20,
          ),
          child: Obx(() {
            return AppButton(
              width: double.infinity,
              height: AppSizes.spacing45,
              textStyle: AppTextStyles.buttonText,
              text: AppStrings.continueText.tr,
              isLoading: controller.isSubmitting.value,
              onPressed: (controller.isSubmitting.value || !controller.isFormValid.value)
                  ? null // disable when loading or form invalid
                  : () => controller.continueToNext(context, scrollController),
            );
          }),
        ),
    );
  }
}
