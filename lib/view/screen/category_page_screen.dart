import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/home_controller/unified_service_data_controller.dart';
import '../widget/category_card_widget.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UnifiedServiceDataController controller = Get.find<UnifiedServiceDataController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSizes.spacing30),
          child: _CategoryGrid(controller: controller),
        ),
      ),
    );
  }
}


/* -------------------- GRID -------------------- */

class _CategoryGrid extends StatelessWidget {
  final UnifiedServiceDataController controller;

  const _CategoryGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
      child: Obx(() {
        final dataList = controller.dataList;

        if (dataList.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noCategory,
              style: AppTextStyles.faqsDescriptionText,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: AppSizes.size250,
            childAspectRatio: 0.70,
            crossAxisSpacing: AppSizes.spacing8,
            mainAxisSpacing: AppSizes.spacing8,
          ),
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.details, arguments: dataList[index]),
              child: CategoryCardWidget(
                data: dataList[index],
                onFavoriteTap: () => controller.toggleFavorite(index),
              ),
            );
          },
        );
      }),
    );
  }
}
