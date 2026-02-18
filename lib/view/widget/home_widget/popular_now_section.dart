import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/popular_controller.dart';
import '../../../controller/home_controller/home_controller.dart';
import '../popular_card_widget.dart';

class PopularNowSection extends StatelessWidget {
  final HomeController controller;
  final PopularController popularController;

  const PopularNowSection({
    super.key,
    required this.controller,
    required this.popularController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.popularNow.tr, style: AppTextStyles.bodyTitle),
            GestureDetector(
              onTap: controller.onSeeAllPopularTap,
              child: Text(AppStrings.seeAll.tr, style: AppTextStyles.hintText),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacing10),
        SizedBox(
          height: AppSizes.size270,
          child: Obx(() {
            final filteredItems =
            controller.getFilteredPopularItems(popularController.popularList);
            if (filteredItems.isEmpty) {
              final categoryName = controller.getCategoryName();
              return Center(
                child: Text(
                  AppStrings.noItemsFor(categoryName),
                  style: AppTextStyles.bodyText.copyWith(color: AppColors.grey),
                ),
              );
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filteredItems.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: AppSizes.spacing4),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return PopularCard(
                  data: item,
                  onFavoriteTap: () => popularController.toggleFavoriteById(item.id ?? ''),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
