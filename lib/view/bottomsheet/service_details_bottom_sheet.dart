import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../model/details_model.dart';
import '../../constants/app_assets.dart';
// import '../../routes/app_routes.dart';

class ServiceDetailsBottomSheet extends StatelessWidget {
  final ServiceCategoryModel service;
  final String businessName;
  final String businessLocation;
  final String businessCategory;
  final double businessRating;
  final int reviewsCount;
  final VoidCallback onBookNow;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final bool isFavorite;
  final RxBool favoriteState; // Add reactive favorite state

  const ServiceDetailsBottomSheet({
    super.key,
    required this.service,
    required this.businessName,
    required this.businessLocation,
    required this.businessCategory,
    required this.businessRating,
    this.reviewsCount = 90,
    required this.onBookNow,
    required this.onFavorite,
    required this.onShare,
    this.isFavorite = false,
    required this.favoriteState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.spacing20),
          topRight: Radius.circular(AppSizes.spacing20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildServiceImage(),
          _buildServiceDetails(),
          _buildBookNowButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: AppSizes.spacing28,
            height: AppSizes.spacing28,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.red, width: AppSizes.borderWidth2),
            ),
            child: const Icon(
              Icons.close_outlined,
              color: AppColors.red,
              size: AppSizes.spacing16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceImage() {
    return Container(
      width: double.infinity,
      height: AppSizes.size200,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        image: DecorationImage(
          image: AssetImage(service.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(service.name, style: AppTextStyles.appBarText),
              Row(
                children: [
                  // Share Button - COMMENTED OUT
                  // GestureDetector(
                  //   onTap: onShare,
                  //   child: Container(
                  //     padding: const EdgeInsets.all(AppSizes.spacing8),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.grey.withValues(alpha: 0.1),
                  //       borderRadius: BorderRadius.circular(
                  //         AppSizes.buttonRadius,
                  //       ),
                  //     ),
                  //     child: Image.asset(
                  //       AppAssets.shareArrow,
                  //       height: AppSizes.spacing16,
                  //       width: AppSizes.spacing16,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: AppSizes.spacing8),

                  // Favorite Button - COMMENTED OUT
                  // GestureDetector(
                  //   onTap: onFavorite,
                  //   child: Container(
                  //     padding: const EdgeInsets.all(AppSizes.spacing8),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.grey.withValues(alpha: 0.1),
                  //       borderRadius: BorderRadius.circular(
                  //         AppSizes.buttonRadius,
                  //       ),
                  //     ),
                  //     child: Obx(() => Icon(
                  //       favoriteState.value ? Icons.favorite : Icons.favorite_border,
                  //       color: AppColors.red,
                  //       size: AppSizes.spacing16,
                  //     )),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (businessCategory ==
                        AppStrings.parlour) // 👈 direct condition lagao
                      Text(
                        AppStrings.homeService,
                        style: AppTextStyles.reviewTextTitle,
                      ),
                    const SizedBox(height: AppSizes.spacing4),
                    // Location
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.location,
                          height: AppSizes.spacing16,
                          color: AppColors.mediumGrey,
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Expanded(
                          child: Text(
                            businessLocation,
                            style: AppTextStyles.addressText,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing6),
          Text(service.price, style: AppTextStyles.primaryButtonText),
          const SizedBox(height: AppSizes.spacing6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (service.discount != null && service.discount!.isNotEmpty) ...[
                Row(
                  children: [
                    Text(AppStrings.offer, style: AppTextStyles.bodyTitle),
                    Text(
                      '${AppStrings.flat}  ${service.discount} ${AppStrings.off}',
                       style: AppTextStyles.captionTitle,
                    ),
                    Text(
                      AppStrings.bridalPackages,
                      style: AppTextStyles.faqsDescriptionText,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing8),
              ],
              Row(
                children: [
                  ...List.generate(5, (index) {
                    final bool isHalf =
                        (businessRating - index) > 0 &&
                        (businessRating - index) < 1;
                    if (index < businessRating.floor()) {
                      return const Icon(
                        Icons.star,
                        color: AppColors.yellow,
                        size: AppSizes.spacing20,
                      );
                    } else if (isHalf) {
                      return const Icon(
                        Icons.star_half,
                        color: AppColors.yellow,
                        size: AppSizes.spacing20,
                      );
                    } else {
                      return const Icon(
                        Icons.star_border,
                        color: AppColors.yellow,
                        size: AppSizes.spacing20,
                      );
                    }
                  }),
                  const SizedBox(width: AppSizes.spacing6),
                  Text(
                    '${businessRating.toStringAsFixed(1)}  ($reviewsCount ${AppStrings.reviewsText})',
                    style: AppTextStyles.captionTitle,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing6),
              Text(AppStrings.description, style: AppTextStyles.bodyTitle),
              const SizedBox(height: AppSizes.spacing6),
              Text(
                (service.description == null ||
                        service.description!.trim().isEmpty)
                    ? AppStrings.getProfessionalServiceDescription(service.name.toLowerCase())
                    : service.description!,
                style: AppTextStyles.captionText.copyWith(
                  color: AppColors.grey,
                  height: AppSizes.lineHeight1_4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookNowButton() {
    return Builder(
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewPadding.bottom;
        return Padding(
          padding: EdgeInsets.only(
            left:AppSizes.spacing16,
            top:AppSizes.spacing4,
            right:AppSizes.spacing16,
            bottom: bottomInset + AppSizes.spacing20,
          ),
          child: AppButton(
            width: double.infinity,
            height: AppSizes.spacing45,
            textStyle: AppTextStyles.buttonText,
            text: AppStrings.bookNow,
            onPressed: onBookNow,
          ),
        );
      },
    );
  }
}
