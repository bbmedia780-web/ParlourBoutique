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
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
                onSharePressed: controller.onSharePressed,
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
   // );
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
              const Icon(Icons.star, size: 18, color: Colors.amber),
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
                    : controller.onSharePressed,
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
}
