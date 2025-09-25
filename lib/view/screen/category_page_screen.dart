/*
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
          physics: const BouncingScrollPhysics(), // smooth scroll
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: AppSizes.size250,
            childAspectRatio: 0.70,
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
*/

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
    final UnifiedServiceDataController controller =
    Get.find<UnifiedServiceDataController>();
    final MainNavigationController navController =
    Get.find<MainNavigationController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _CategoryAppBar(onBack: () => _onBackPressed(navController)),
      body: _CategoryGrid(controller: controller),
    );
  }

  void _onBackPressed(MainNavigationController navController) {
    if (Get.currentRoute == AppRoutes.home) {
      navController.onBottomNavItemTapped(0);
    } else {
      Get.back();
    }
  }
}

/* -------------------- APP BAR -------------------- */

class _CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _CategoryAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: AppColors.black, size: AppSizes.spacing20),
        onPressed: onBack,
      ),
      title: Text(AppStrings.category.tr, style: AppTextStyles.appBarText),
      centerTitle: true,
      actions: const [_FilterButton()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/* -------------------- FILTER BUTTON -------------------- */

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.spacing12),
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.05),
        radius: AppSizes.spacing20,
        child: IconButton(
          icon: Image.asset(AppAssets.filterBlack,
              scale: AppSizes.scaleSize, color: AppColors.black),
          onPressed: _openFilter,
        ),
      ),
    );
  }

  void _openFilter() {
    Get.bottomSheet(
      const FilterBottomSheet(),
      isScrollControlled: true,
    );
  }
}




/* -------------------- GRID -------------------- */

class _CategoryGrid extends StatelessWidget {
  final UnifiedServiceDataController controller;

  const _CategoryGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dataList = controller.dataList;

      if (dataList.isEmpty) {
        return  Center(child: Text(AppStrings.noCategory));
      }

      return GridView.builder(
        padding: EdgeInsets.only(
          left: AppSizes.spacing12,
          right: AppSizes.spacing12,
          bottom: MediaQuery.of(context).padding.bottom + AppSizes.spacing20,
        ),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: AppSizes.size250,
          childAspectRatio: 0.70,
          crossAxisSpacing: AppSizes.spacing8,
          mainAxisSpacing: AppSizes.spacing8,
        ),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final data = dataList[index];
          return GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.details, arguments: data),
            child: CategoryCardWidget(
              data: data,
              onFavoriteTap: () => controller.toggleFavorite(index),
            ),
          );
        },
      );
    });
  }
}

