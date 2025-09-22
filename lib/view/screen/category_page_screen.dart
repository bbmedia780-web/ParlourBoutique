import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/constants/app_assets.dart';
import 'package:parlour_app/routes/app_routes.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../constants/app_sizes.dart';
import '../../controller/home_controller/main_navigation_controller.dart';
import '../../controller/home_controller/unified_service_data_controller.dart';
import '../../view/bottomsheet/filter_bottom_sheet.dart';
import '../../controller/home_controller/filter_controller.dart';
import '../widget/category_card_widget.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UnifiedServiceDataController controller = Get.find<UnifiedServiceDataController>();
    final MainNavigationController mainNavController = Get.find<MainNavigationController>();

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
          onPressed: () {
            if (Get.currentRoute == AppRoutes.home) {
              mainNavController.onBottomNavItemTapped(0);
            } else {
              Get.back();
            }
          },
        ),
        title: Text(AppStrings.category.tr, style: AppTextStyles.appBarText),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.spacing12),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.05),
              radius: AppSizes.spacing20,
              child: IconButton(
                icon: Image.asset(
                  AppAssets.filterBlack,
                  scale: AppSizes.scaleSize,
                  color: AppColors.black,
                ),
                onPressed: () {
                  if (!Get.isRegistered<FilterController>()) {
                    Get.put(FilterController());
                  }
                  Get.bottomSheet(
                    const FilterBottomSheet(),
                    isScrollControlled: true,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return GridView.builder(
          padding: EdgeInsets.only(
            left: AppSizes.spacing12,
            right: AppSizes.spacing12,
            bottom: MediaQuery.of(context).padding.bottom + AppSizes.spacing20,
          ),
          physics: const BouncingScrollPhysics(), // 👈 smooth scroll
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            //childAspectRatio: 0.70,
            mainAxisExtent: MediaQuery.of(context).size.height * 0.30,
            crossAxisSpacing: AppSizes.spacing8,
            mainAxisSpacing: AppSizes.spacing8,
          ),
          itemCount: controller.dataList.length,
          itemBuilder: (context, index) {
            final data = controller.dataList[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.details, arguments: data);
              },
              child: CategoryCardWidget(
                data: data,
                onFavoriteTap: () => controller.toggleFavorite(index),
              ),
            );
          },
        );
      }),
    );
  }
}
