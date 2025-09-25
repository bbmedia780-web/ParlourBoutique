import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/home_controller/home_controller.dart';
import '../../../controller/home_controller/unified_service_data_controller.dart';

class UnifiedBanner extends StatelessWidget {
  final UnifiedServiceDataController unifiedController;
  final HomeController homeController;


  const UnifiedBanner({super.key,
    required this.unifiedController,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bannerData = unifiedController.getBannerData();
      return Row(
        children: [
          Image.asset(
            bannerData['image']!,
            height: AppSizes.size130,
            fit: BoxFit.contain,
          ),
          Expanded(
            child: Column(
              children: [
                Text(bannerData['title']!, style: AppTextStyles.homeBanner),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      bannerData['discountImage'] ?? AppAssets.off30,
                      height: AppSizes.spacing24,
                    ),
                    Text(
                      bannerData['highlightText'] ?? "",
                      style: AppTextStyles.homeBanner,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing2),
                GestureDetector(
                  onTap: homeController.onAddButtonTapped,
                  child: Container(
                    height: AppSizes.spacing40,
                    width: AppSizes.size140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.spacing30),
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text(
                        bannerData['btnLabel']!,
                        style: AppTextStyles.whiteNameText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
