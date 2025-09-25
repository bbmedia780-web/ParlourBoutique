import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/home_controller/unified_service_data_controller.dart';
import '../unified_service_card_widget.dart';

class UnifiedListSliver extends StatelessWidget {
  final UnifiedServiceDataController controller;

  const UnifiedListSliver({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filteredDataList.isNotEmpty
          ? controller.filteredDataList
          : controller.dataList;

      if (list.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSizes.spacing20),
            child: Center(
              child: Text(
                AppStrings.noDataFound,
                style: AppTextStyles.bodyText.copyWith(color: AppColors.grey),
              ),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final data = list[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacing16),
              child: UnifiedServiceCard(
                data: data,
                index: index,
                onFavoriteTap: () =>
                    controller.toggleFavoriteById(data.id ?? ''),
              ),
            );
          },
          childCount: list.length,
        ),
      );
    });
  }
}
