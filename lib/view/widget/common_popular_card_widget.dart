import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';
import '../../model/popular_model.dart';

class CommonPopularCard extends StatelessWidget {
  final PopularModel data;
  final VoidCallback onFavoriteTap;

  const CommonPopularCard({
    super.key,
    required this.data,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    // Choose card layout based on category
    if (data.category == 'rent') {
      return _buildRentCard();
    } else {
      return _buildParlourCard();
    }
  }

  Widget _buildParlourCard() {
    return Card(
      color: AppColors.white,
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.spacing12),
                  topRight: Radius.circular(AppSizes.spacing12),
                ),
                child: Image.asset(
                  data.image,
                  width: double.infinity,
                  height: AppSizes.size160,
                  fit: BoxFit.cover,
                  cacheHeight: 300, // Optimize memory
                ),
              ),
              // Gradient, discount badge, favorite icon...
              Positioned(
                bottom: AppSizes.spacing4,
                left: AppSizes.spacing8,
                child: Text(
                  data.service ?? "",
                  style: AppTextStyles.whiteSmallText,
                ),
              ),
              // Favorite Button - COMMENTED OUT
              // Positioned(
              //   top: AppSizes.spacing12,
              //   right: AppSizes.spacing10,
              //   child: GestureDetector(
              //     onTap: onFavoriteTap,
              //     child: Icon(
              //       data.isFavorite ? Icons.favorite : Icons.favorite_border,
              //       color: data.isFavorite ? AppColors.red : AppColors.white,
              //       size: AppSizes.spacing18,
              //     ),
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: AppTextStyles.captionTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacing2),
                    Image.asset(
                      AppAssets.star,
                      width: AppSizes.spacing14,
                      height: AppSizes.spacing14,
                    ),
                    const SizedBox(width: AppSizes.spacing2),
                    Text(data.rating.toString(), style: AppTextStyles.hintText),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing4),
                Text(
                  data.bestFamousService,
                  style: AppTextStyles.faqsDescriptionText,
                ),
                SizedBox(height: AppSizes.spacing4),
                Row(
                  children: [
                    Image.asset(
                      AppAssets.location,
                      width: AppSizes.spacing12,
                      height: AppSizes.spacing12,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: AppSizes.spacing4),
                    Expanded(
                      child: Text(
                        data.location,
                        style: AppTextStyles.captionTitle,
                        maxLines: 1,
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
    );
  }

  Widget _buildRentCard() {
    return Card(
      color: AppColors.white,
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.spacing12),
                  topRight: Radius.circular(AppSizes.spacing12),
                ),
                child: Image.asset(
                  data.image,
                  width: double.infinity,
                  height: AppSizes.size160,
                  fit: BoxFit.cover,
                  cacheHeight: 300, // Optimize memory
                ),
              ),
              // Gradient, discount badge, favorite icon...
              // Favorite Button - COMMENTED OUT
              // Positioned(
              //   top: AppSizes.spacing12,
              //   right: AppSizes.spacing10,
              //   child: GestureDetector(
              //     onTap: onFavoriteTap,
              //     child: Icon(
              //       data.isFavorite ? Icons.favorite : Icons.favorite_border,
              //       color: data.isFavorite ? AppColors.red : AppColors.white,
              //       size: AppSizes.spacing18,
              //     ),
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: AppTextStyles.captionTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacing2),
                    Image.asset(AppAssets.eye,scale: AppSizes.scaleSize,color: AppColors.mediumGrey),
                    const SizedBox(width: AppSizes.spacing2),
                    Text((data.view ?? 0).toString(), style: AppTextStyles.hintText),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing4),
                Text(
                  '₹ ${data.price}',
                  style: AppTextStyles.cardSubTitle,
                ),
                SizedBox(height: AppSizes.spacing4),
                Row(
                  children: [
                    Image.asset(
                      AppAssets.location,
                      width: AppSizes.spacing12,
                      height: AppSizes.spacing12,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: AppSizes.spacing4),
                    Expanded(
                      child: Text(
                        data.location,
                        style: AppTextStyles.captionTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Image.asset(
                      AppAssets.star,
                      width: AppSizes.spacing12,
                      height: AppSizes.spacing12,
                    ),
                    SizedBox(width: AppSizes.spacing2),
                    Text(
                      data.rating.toString(),
                      style: AppTextStyles.captionTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
