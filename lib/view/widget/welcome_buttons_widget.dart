import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../controller/auth_controller/welcome_controller.dart';
import '../../common/common_button.dart';
import '../../constants/app_text_style.dart';

class WelcomeButtonsWidget extends StatelessWidget {
  final PageController pageController;
  final int pageCount;

  const WelcomeButtonsWidget({
    required this.pageController,
    required this.pageCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final WelcomeController welcomeController = Get.find<WelcomeController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
      child: Obx(() {
        final isLastPage = welcomeController.currentPage.value == pageCount - 1;
        if (isLastPage) {
          /// Centered "Get Started" button
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: AppButton(
                  height: AppSizes.spacing45,
                  text: AppStrings.getStarted,
                  textStyle: AppTextStyles.buttonText,
                  width: double.infinity,
                  //onPressed: () => Get.offAllNamed(AppRoutes.signIn),
                  onPressed: welcomeController.onGetStarted, // ✅ controller logic
                ).paddingOnly(right: AppSizes.size70,left: AppSizes.size70
                ),
              ),
            ],
          );
        } else {
          /// Skip and Next buttons in row
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => welcomeController.skipToEnd(pageController, pageCount),
                child:Text(
                  AppStrings.skip,
                  style: AppTextStyles.skipButtonText
                  ,
                ),
              ),
              AppButton(
                height: AppSizes.spacing45,
                width: AppSizes.size110,
                text: AppStrings.next,
                textStyle: AppTextStyles.buttonText,
                onPressed: () => welcomeController.nextPage(pageController, pageCount),
              ).paddingOnly(right: AppSizes.spacing16),
            ],
          );
        }
      }),
    );
  }
}
