import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../constants/app_sizes.dart';
import '../../../controller/favourite_controller.dart';
import '../../../model/popular_model.dart';
import '../../../model/unified_data_model.dart';
import '../../widget/common_popular_card_widget.dart';
import '../../widget/category_card_widget.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});

  final FavouriteController controller = Get.find<FavouriteController>();

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => controller.onBackPressed(),
        ),
        title: Text(
          AppStrings.favourite.tr,
          style: AppTextStyles.appBarText,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildFavouriteTab(context,controller.allFavourites),
                  _buildFavouriteTab(context,controller.parlourFavourites),
                  // Disabled for Phase 1: Boutique favourites tab
                  // _buildFavouriteTab(controller.boutiqueFavourites),
                  _buildFavouriteTab(context,controller.rentFavourites),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
      child: TabBar(
        controller: controller.tabController,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey,
        labelStyle: AppTextStyles.captionTitle,
        unselectedLabelStyle: AppTextStyles.captionTitle,
        tabs: [
          Tab(text: AppStrings.all),
          Tab(text: AppStrings.parlourTab),
          // Disabled for Phase 1: Boutique tab
          // Tab(text: AppStrings.boutiqueTab),
          Tab(text: AppStrings.rentTab),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: AppSizes.size80,
            color: AppColors.grey,
          ),
          const SizedBox(height: AppSizes.spacing16),
          Text(
            AppStrings.noFavouritesYet.tr,
            style: AppTextStyles.appBarText.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            AppStrings.addFavouriteHint.tr,
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavouriteTab(BuildContext context,RxList<dynamic> favouriteItems) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (favouriteItems.isEmpty) {
        return _buildEmptyState();
      }

/*
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.70,
            mainAxisSpacing: AppSizes.spacing8,
            crossAxisSpacing: AppSizes.spacing8,
          ),
          itemCount: favouriteItems.length,
          itemBuilder: (context, index) {
            final item = favouriteItems[index];
            if (item is PopularModel) {
              return GestureDetector(
                onTap: () => controller.onItemTap(item),
                child: CommonPopularCard(
                  data: item,
                  onFavoriteTap: () => controller.removeFromFavourites(item),
                ),
              );
            } else if (item is UnifiedDataModel) {
              return GestureDetector(
                onTap: () => controller.onItemTap(item),
                child: CategoryCardWidget(
                  data: item,
                  onFavoriteTap: () => controller.removeFromFavourites(item),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );
*/
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: AppSizes.size250,
            childAspectRatio: 0.70,
            crossAxisSpacing: AppSizes.spacing8,
            mainAxisSpacing: AppSizes.spacing8,
          ),
          itemCount: favouriteItems.length,
          itemBuilder: (context, index) {
            final item = favouriteItems[index];
            if (item is PopularModel) {
              return GestureDetector(
                onTap: () => controller.onItemTap(item),
                child: CommonPopularCard(
                  data: item,
                  onFavoriteTap: () => controller.removeFromFavourites(item),
                ),
              );
            } else if (item is UnifiedDataModel) {
              return GestureDetector(
                onTap: () => controller.onItemTap(item),
                child: CategoryCardWidget(
                  data: item,
                  onFavoriteTap: () => controller.removeFromFavourites(item),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      );

    });
  }
}
