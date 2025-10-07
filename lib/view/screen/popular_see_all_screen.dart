/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/popular_controller.dart';
import '../widget/popular_card_widget.dart';

class PopularSeeAllScreen extends StatelessWidget {
  PopularSeeAllScreen({super.key});

  final PopularController popularController = Get.find<PopularController>();
  late final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    selectedCategory = Get.arguments ?? 'parlour'; // Default to parlour if no argument
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.black,
          size: AppSizes.spacing20,
        ),
      ),
      title: Text(
        AppStrings.popularNow,
        style: AppTextStyles.appBarText
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left:AppSizes.spacing12,right:AppSizes.spacing12),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (popularController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              // Filter items based on selected category
              final filteredItems = popularController.getFilteredItemsByCategory(selectedCategory);

              if (filteredItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: AppSizes.size80,
                        color: AppColors.grey,
                      ),
                      const SizedBox(height: AppSizes.spacing16),
                      Text(
                        'No ${popularController.getCategoryDisplayName(selectedCategory)} items available',
                        style: AppTextStyles.bodyTitle.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: AppSizes.size250,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: AppSizes.spacing8,
                  mainAxisSpacing: AppSizes.spacing8,
                ),
                itemCount: filteredItems.length,
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
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/popular_controller.dart';
import '../widget/popular_card_widget.dart';

class PopularSeeAllScreen extends StatelessWidget {
  PopularSeeAllScreen({super.key});

  // ----------------- Controller -----------------
  final PopularController popularController = Get.find<PopularController>();

  // ----------------- Argument (Category) -----------------
  late final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    // Get selected category from navigation arguments
    selectedCategory = Get.arguments ?? 'parlour';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// ............AppBar with back button and title............

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.black,
          size: AppSizes.spacing20,
        ),
      ),
      title: Text(
        AppStrings.popularNow,
        style: AppTextStyles.appBarText,
      ),
      centerTitle: true,
    );
  }

  /// ............Body containing the grid of items (filtered by category)............

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing12,
      ),
      child: Obx(() {
        // ----------------- Loading State -----------------
        if (popularController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // ----------------- Filter Items by Category -----------------
        final filteredItems =
        popularController.getFilteredItemsByCategory(selectedCategory);

        // ----------------- Empty State -----------------
        if (filteredItems.isEmpty) {
          return _buildEmptyState();
        }

        // ----------------- GridView with Items -----------------
        return GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: AppSizes.size250,
            childAspectRatio: 0.70,
            crossAxisSpacing: AppSizes.spacing8,
            mainAxisSpacing: AppSizes.spacing8,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return PopularCard(
              data: item,
              onFavoriteTap: () =>
                  popularController.toggleFavoriteById(item.id ?? ''),
            );
          },
        );
      }),
    );
  }

  /// ............ Empty State UI when no items are available .............

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: AppSizes.size80,
            color: AppColors.grey,
          ),
          const SizedBox(height: AppSizes.spacing16),
          Text(
            'No ${popularController.getCategoryDisplayName(selectedCategory)} items available',
            style: AppTextStyles.bodyTitle.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
