import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_style.dart';
import '../../controller/auth_controller/welcome_controller.dart';

class WelcomePageWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final int pageCount;

  const WelcomePageWidget({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.pageCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final WelcomeController controller = Get.find<WelcomeController>();


    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing20,
        vertical: AppSizes.size50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: AppSizes.size300,scale: AppSizes.scaleSize),

          const SizedBox(height: AppSizes.spacing40),

          // Page indicator BELOW image
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                pageCount, (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing4),
                height: AppSizes.spacing8,
                width: controller.currentPage.value == index ? AppSizes.spacing24 : AppSizes.spacing8,
                decoration: BoxDecoration(
                  color: controller.currentPage.value == index
                      ? AppColors.primary
                      : AppColors.pinkPastel,
                  borderRadius: BorderRadius.circular(AppSizes.spacing4),
                ),
              ),
            ),
          )),
          const SizedBox(height: AppSizes.spacing12 * 2),
          Text(
            title,
            style:AppTextStyles.welcomePageTitle,
            textAlign: TextAlign.center,
          ).paddingOnly(bottom:AppSizes.spacing12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.welcomePageDes,
          ),
        ],
      ),
    );
  }
}
