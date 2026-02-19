import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common_button.dart';
import '../../../common/common_container_text_field.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import 'dart:io';

import '../../../controller/auth_controller/auth_controller.dart';
import '../../../controller/profile_controller/account_information_controller.dart';

class AccountInformationPageView extends StatelessWidget {
  AccountInformationPageView({super.key});

  final AccountInformationController controller = Get.find<AccountInformationController>();
  final AuthController authController = Get.find<AuthController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
      title: Text(
          AppStrings.accountInformation,
          style: AppTextStyles.appBarText
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(height: AppSizes.spacing30),
              _buildProfilePhotoSection(),
              const SizedBox(height: AppSizes.spacing28),
              Expanded(child: _buildFormFields(context)),
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
                      text: AppStrings.save.tr,
                      onPressed: controller.saveInformation,
                    ),
                  );
                },
              ),
            ],
          );
        }
    );
  }

  Widget _buildProfilePhotoSection() {
    return Center(
      child: Stack(
        children: [
          // Profile Photo
          Container(
            width: AppSizes.size120,
            height: AppSizes.size120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.lightGrey,
                width:  AppSizes.spacing2,
              ),
            ),
            child: ClipOval(
              child: Obx(() {
                if (controller.selectedImagePath.value.isNotEmpty) {
                  return Image.file(
                    File(controller.selectedImagePath.value),
                    fit: BoxFit.cover,
                  );
                } else {
                  return Image.asset(
                    AppAssets.user,
                    fit: BoxFit.cover,
                  );
                }
              }),
            ),
          ),

          // Camera Icon Button
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => controller.changePhoto(),
              child: Container(
                width: AppSizes.spacing36,
                height: AppSizes.spacing36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.mediumGrey,
                  size:  AppSizes.spacing22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return SingleChildScrollView(
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
            hintText: 'Enter your full name',
          ).paddingOnly(bottom: AppSizes.spacing20),
          Text(
            AppStrings.yourEmail,
            style: AppTextStyles.profilePageText,
          ).paddingOnly(bottom: AppSizes.spacing8),
          CommonContainerTextField(
            controller: controller.emailController,
            textStyle: AppTextStyles.hintText,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Enter your email',
          ).paddingOnly(bottom: AppSizes.spacing20),
          Text(
            AppStrings.dateOfBirth,
            style: AppTextStyles.profilePageText,
          ).paddingOnly(bottom: AppSizes.spacing8),
          GestureDetector(
            onTap: () => controller.selectDate(context),
            child: AbsorbPointer(
              child: CommonContainerTextField(
                controller: controller.dateOfBirthController,
                textStyle: AppTextStyles.hintText,
                keyboardType: TextInputType.none,
                readOnly: true,
                hintText: 'Select date of birth',
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
              ),
            ),
          ).paddingOnly(bottom: AppSizes.spacing20),
        ],
      ).paddingSymmetric(horizontal: AppSizes.spacing20),
    );
  }

}
