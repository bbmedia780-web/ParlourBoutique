/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/constants/app_assets.dart';
import '../../common/common_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/popular_details_controller.dart';
import '../widget/details_widgets.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({super.key});

  final DetailsController controller = Get.find<DetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: controller.isRentCategory
          ? AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.black),
                onPressed: controller.onBackPressed,
              ),
              title: Text(AppStrings.details, style: AppTextStyles.appBarText),
              centerTitle: true,
            )
          : null,
      body: Obx(() {
          final businessDetails = controller.businessDetails.value;

          if (businessDetails == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppSizes.spacing16),
                  Text(AppStrings.loadingDetails),
                ],
              ),
            );
          }

          if (controller.isRentCategory) {
            return _buildRentDetailsLayout(
              context,
              businessDetails,
              controller,
            );
          }

          return CustomScrollView(
            slivers: [
              BusinessHeaderWidget(
                businessDetails: businessDetails,
                onBackPressed: controller.onBackPressed,
                // onSharePressed: controller.onSharePressed, // COMMENTED OUT
                onSharePressed: () {}, // Empty function to avoid errors
                // onFavoritePressed: controller.onFavoritePressed, // COMMENTED OUT
                onFavoritePressed: () {}, // Empty function to avoid errors
                isFavorite: controller.isFavorite.value,
                onTitlePressed: controller.onTitleTapped,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        businessDetails.description,
                        style: AppTextStyles.reviewTextTitle,
                      ),
                      const SizedBox(height: AppSizes.spacing10),
                      _buildPromotionsSection(controller, businessDetails),
                      const SizedBox(height: AppSizes.spacing12),
                      if (controller.isBoutique.value) ...[
                        _buildGenderSelectionSection(controller),
                        const SizedBox(height: AppSizes.spacing24),
                      ],
                      _buildCategorySection(controller),
                      const SizedBox(height: AppSizes.spacing24),
                      _buildServicesGrid(controller),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      );
  }

  Widget _buildRentDetailsLayout(
    BuildContext context,
    dynamic businessDetails,
    DetailsController controller,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.spacing16),
            child: Image.asset(
              businessDetails.image,
              width: double.infinity,
              height: AppSizes.size450,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Text(businessDetails.title, style: AppTextStyles.bodyTitle),
          if (businessDetails.service != null &&
              businessDetails.service!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacing2),
            Text(
              businessDetails.service!,
              style: AppTextStyles.faqsDescriptionText,
            ),
          ],
          const SizedBox(height: AppSizes.spacing6),
          Row(
            children: [
              Image.asset(
                AppAssets.location,
                height: AppSizes.spacing14,
                width: AppSizes.spacing14,
                color: Colors.black54,
              ),
              const SizedBox(width: AppSizes.spacing6),
              Expanded(
                child: Text(
                  businessDetails.location,
                  style: AppTextStyles.faqsDescriptionText,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            children: [
              Text(
                '₹${controller.rentCurrentPrice.value.toStringAsFixed(0)}',
                style: AppTextStyles.priceText,
              ),
              if (controller.rentOldPrice.value != null) ...[
                const SizedBox(width: AppSizes.spacing6),
                Text(
                  '₹${controller.rentOldPrice.value!.toStringAsFixed(0)}',
                  style: AppTextStyles.faqsDescriptionText.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          if (controller.rentDiscountText.value != null &&
              controller.rentDiscountText.value!.isNotEmpty)
            Text(
              '${AppStrings.offerLabel} ${controller.rentDiscountText.value}',
              style: AppTextStyles.reviewTextTitle,
            ),
          const SizedBox(height: AppSizes.spacing8),
          Row(
            children: [
              Image.asset(AppAssets.star,height: AppSizes.spacing14),
              const SizedBox(width: AppSizes.spacing6),
              Text(
                '${businessDetails.rating} ${AppStrings.reviewsCount(90)}',
                style: AppTextStyles.faqsDescriptionText,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing16),
          Text(AppStrings.description, style: AppTextStyles.bodyTitle),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            businessDetails.description,
            style: AppTextStyles.faqsDescriptionText,
          ),
          const SizedBox(height: AppSizes.spacing16),
          Obx(() {
            final isRent =
                controller.businessDetails.value?.category ==
                AppStrings.rentType;
            return SizedBox(
              width: double.infinity,
              child: AppButton(
                width: double.infinity,
                height: AppSizes.spacing45,
                textStyle: AppTextStyles.buttonText,
                text: AppStrings.rentNow.tr,
                onPressed: isRent
                    ? controller.onRentNowPressed
                    : () {}, // Share functionality commented out
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPromotionsSection(
    DetailsController controller,
    dynamic businessDetails,
  ) {
    return SizedBox(
      height: AppSizes.spacing64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: businessDetails.promotions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == businessDetails.promotions.length - 1
                  ? 0
                  : AppSizes.spacing12,
            ),
            child: SizedBox(
              width: AppSizes.size250,
              child: PromotionCardWidget(
                promotion: businessDetails.promotions[index],
                onPressed: () => controller.onPromotionPressed(
                  businessDetails.promotions[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenderSelectionSection(DetailsController controller) {
    return CategoryTabWidget(
      categories: controller.boutiqueGenderCategories,
      selectedIndex: controller.selectedGenderIndex.value,
      onCategorySelected: controller.onGenderCategorySelected,
    );
  }

  Widget _buildCategorySection(DetailsController controller) {
    return CategoryTabWidget(
      categories: controller.getCurrentCategories(),
      selectedIndex: controller.selectedCategoryIndex.value,
      onCategorySelected: controller.onServiceCategorySelected,
      useSegmentedStyle: controller.isBoutique.value,
    );
  }

*/
/*
  Widget _buildServicesGrid(DetailsController controller) {
    final services = controller.getCurrentItems();
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: AppSizes.spacing8,
        mainAxisSpacing: AppSizes.spacing8,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return ServiceCardWidget(
          service: services[index],
          onPressed: () => controller.onServiceItemPressed(services[index]),
        );
      },
    );
  }
*//*

  Widget _buildServicesGrid(DetailsController controller) {
    final services = controller.getCurrentItems();
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: AppSizes.size250,
        childAspectRatio: 0.95,
        crossAxisSpacing: AppSizes.spacing8,
        mainAxisSpacing: AppSizes.spacing8,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return ServiceCardWidget(
          service: services[index],
          onPressed: () => controller.onServiceItemPressed(services[index]),
        );
      },
    );
  }

}
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/constants/app_assets.dart';
import '../../common/common_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/popular_details_controller.dart';
import '../widget/details_widgets.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({super.key});

  final DetailsController controller = Get.find<DetailsController>();

  @override
  Widget build(BuildContext context) {
    print('DEBUG: DetailsScreen build called');
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: controller.isRentCategory ? _buildRentAppBar() : null,
      body: SafeArea(
        child: Obx(() {
        final businessDetails = controller.businessDetails.value;
        print('DEBUG: DetailsScreen Obx - businessDetails: $businessDetails');

        if (businessDetails == null) {
          print('DEBUG: Showing loading view');
          return const _LoadingView();
        }

        print('DEBUG: Showing details layout');
        return controller.isRentCategory
            ? _RentDetailsLayout(controller: controller, details: businessDetails)
            : _BusinessDetailsLayout(controller: controller, details: businessDetails);
        }),
      ),
      bottomNavigationBar: Obx(() {
        final isRent = controller.businessDetails.value?.category == AppStrings.rentType;
        if (!isRent) return const SizedBox.shrink(); // No button if not rent

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: AppButton(
              width: double.infinity,
              height: AppSizes.spacing45,
              textStyle: AppTextStyles.buttonText,
              text: AppStrings.rentNow.tr,
              onPressed: controller.onRentNowPressed,
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildRentAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: controller.onBackPressed,
      ),
      title: Text(AppStrings.details, style: AppTextStyles.appBarText),
      centerTitle: true,
    );
  }
}

/* ------------------ Small reusable widgets ------------------ */

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSizes.spacing16),
          Text(AppStrings.loadingDetails),
        ],
      ),
    );
  }
}

/* ------------------ Rent Layout ------------------ */

class _RentDetailsLayout extends StatelessWidget {
  final DetailsController controller;
  final dynamic details;

  const _RentDetailsLayout({
    required this.controller,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          const SizedBox(height: AppSizes.spacing12),
          Text(details.title, style: AppTextStyles.titleSmall),
          if (details.bestFamousService?.isNotEmpty ?? false) ...[
            const SizedBox(height: AppSizes.spacing2),
            Text(details.bestFamousService!, style: AppTextStyles.hintText),
          ],
          const SizedBox(height: AppSizes.spacing6),
          _buildLocation(),
          const SizedBox(height: AppSizes.spacing12),
          _buildPrice(),
          const SizedBox(height: AppSizes.spacing8),
          _buildDiscount(),
          const SizedBox(height: AppSizes.spacing8),
          _buildRating(),
          const SizedBox(height: AppSizes.spacing16),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Check if we have multiple images from UnifiedDataModel
    final unifiedData = controller.originalUnifiedData;
    final List<String> images = unifiedData?.images ?? [];
    
    // If multiple images, show carousel; otherwise show single image
    if (images.length > 1) {
      return _buildImageCarousel(images);
    } else {
      // Single image - check if it's a file path or asset
      final String imagePath = images.isNotEmpty ? images.first : details.image;
      final bool isFile = imagePath.startsWith('/');
      
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.spacing16),
        child: isFile
            ? Image.file(
                File(imagePath),
                width: double.infinity,
                height: AppSizes.size450,
                fit: BoxFit.cover,
              )
            : Image.asset(
                imagePath,
                width: double.infinity,
                height: AppSizes.size450,
                fit: BoxFit.cover,
              ),
      );
    }
  }

  Widget _buildImageCarousel(List<String> images) {
    return SizedBox(
      height: AppSizes.size450,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.spacing16),
        child: PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            final String imagePath = images[index];
            final bool isFile = imagePath.startsWith('/');
            
            return isFile
                ? Image.file(
                    File(imagePath),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
          },
        ),
      ),
    );
  }

  Widget _buildLocation() => Row(
    children: [
      Image.asset(AppAssets.location, height: AppSizes.spacing14, width: AppSizes.spacing14),
      const SizedBox(width: AppSizes.spacing6),
      Expanded(child: Text(details.location, style: AppTextStyles.addressText)),
    ],
  );

  Widget _buildPrice() => Row(
    children: [
      Text('₹${controller.rentCurrentPrice.value.toStringAsFixed(0)}',
          style: AppTextStyles.primaryButtonText),
      if (controller.rentOldPrice.value != null) ...[
        const SizedBox(width: AppSizes.spacing6),
        Text(
          '₹${controller.rentOldPrice.value!.toStringAsFixed(0)}',
          style: AppTextStyles.primaryButtonText.copyWith(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
          ),
        ),
      ],
    ],
  );

  Widget _buildDiscount() {
    final discount = controller.rentDiscountText.value;
    if (discount == null || discount.isEmpty) return const SizedBox();
    return Text('${AppStrings.offerLabel} $discount', style: AppTextStyles.captionTitle);
  }

  Widget _buildRating() => Row(
    children: [
      Image.asset(AppAssets.star, height: AppSizes.spacing14),
      const SizedBox(width: AppSizes.spacing6),
      Text('${details.rating} ${AppStrings.reviewsCount(90)}',
          style: AppTextStyles.captionTitle),
    ],
  );

  Widget _buildDescription() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppStrings.description, style: AppTextStyles.bodyTitle),
      const SizedBox(height: AppSizes.spacing8),
      Text(details.description, style: AppTextStyles.hintText),
    ],
  );

}

/* ------------------ Business Layout ------------------ */

class _BusinessDetailsLayout extends StatelessWidget {
  final DetailsController controller;
  final dynamic details;

  const _BusinessDetailsLayout({
    required this.controller,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        BusinessHeaderWidget(
          businessDetails: details,
          onBackPressed: controller.onBackPressed,
          //onSharePressed: controller.onSharePressed,
          onFavoritePressed: controller.onFavoritePressed,
          isFavorite: controller.isFavorite.value,
          onTitlePressed: controller.onTitleTapped,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(details.description, style: AppTextStyles.reviewTextTitle),
                const SizedBox(height: AppSizes.spacing10),
                _PromotionsSection(controller: controller, details: details),
                const SizedBox(height: AppSizes.spacing12),
                if (controller.isBoutique.value) ...[
                  _CategorySection(
                    title: AppStrings.genderLabel,
                    widget: CategoryTabWidget(
                      categories: controller.boutiqueGenderCategories,
                      selectedIndex: controller.selectedGenderIndex.value,
                      onCategorySelected: controller.onGenderCategorySelected,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing24),
                ],
                Obx(() => _CategorySection(
                  title: AppStrings.categoryLabel,
                  widget: CategoryTabWidget(
                    categories: controller.getCurrentCategories(),
                    selectedIndex: controller.selectedCategoryIndex.value,
                    onCategorySelected: controller.onServiceCategorySelected,
                    useSegmentedStyle: controller.isBoutique.value,
                  ),
                )),
                const SizedBox(height: AppSizes.spacing24),
                _ServicesGrid(controller: controller),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/* ------------------ Sub widgets ------------------ */

class _PromotionsSection extends StatelessWidget {
  final DetailsController controller;
  final dynamic details;

  const _PromotionsSection({required this.controller, required this.details});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.spacing64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: details.promotions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spacing12),
        itemBuilder: (_, index) {
          final promo = details.promotions[index];
          return SizedBox(
            width: AppSizes.size250,
            child: PromotionCardWidget(
              promotion: promo,
              onPressed: () => controller.onPromotionPressed(promo),
            ),
          );
        },
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final Widget widget;

  const _CategorySection({required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [widget],
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  final DetailsController controller;

  const _ServicesGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final services = controller.getCurrentItems();
      return GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: AppSizes.size250,
          childAspectRatio: 0.95,
          crossAxisSpacing: AppSizes.spacing8,
          mainAxisSpacing: AppSizes.spacing8,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ServiceCardWidget(
            service: services[index],
            onPressed: () => controller.onServiceItemPressed(services[index]),
          );
        },
      );
    });
  }
}
