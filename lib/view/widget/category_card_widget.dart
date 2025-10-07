 import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_style.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../../model/unified_data_model.dart';

class CategoryCardWidget extends StatelessWidget {
  final UnifiedDataModel data;
  final VoidCallback onFavoriteTap;

  const CategoryCardWidget({
    super.key,
    required this.data,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Main Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.spacing12),
                  topRight: Radius.circular(AppSizes.spacing12),
                ),
                child: Image.asset(
                  data.image,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.18, // 18% of screen height
                  fit: BoxFit.cover,
                  cacheHeight: 300, // Reduce memory usage
                ),
              ),
              // Gradient Overlay at bottom
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: AppSizes.size50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),

              // Discount Badge
              if (data.discount.isNotEmpty)
                Positioned(
                  top: AppSizes.spacing12,
                  left: -12,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: AppSizes.spacing8,
                      top: AppSizes.spacing4,
                      bottom: AppSizes.spacing4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black26,
                          Colors.black38,
                          Colors.black38,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.spacing12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: AppSizes.spacing20),
                      child: Text(
                        data.discount,
                        style: AppTextStyles.whiteSmallText,
                      ),
                    ),
                  ),
                ),

              // Text on top of gradient (bottom left)
              if (data.type == 'parlour' && (data.id == 'parlour1' || data.id == 'parlour3' || data.id == 'parlour5'))
                Positioned(
                bottom: AppSizes.spacing4,
                left: AppSizes.spacing8,
                child: Text(
                 AppStrings.homeServiceType,
                  style: AppTextStyles.whiteSmallText,
                ),
              ),
              if (data.type == 'boutique' && (data.id == 'boutique1' || data.id == 'boutique3' || data.id == 'boutique5'))
                Positioned(
                  bottom: AppSizes.spacing4,
                  left: AppSizes.spacing8,
                  child: Text(
                    AppStrings.boutiqueServiceType,
                    style: AppTextStyles.whiteSmallText,
                  ),
                ),
              // Favorite Icon
              Positioned(
                top: AppSizes.spacing12,
                right: AppSizes.spacing10,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Icon(
                    data.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: data.isFavorite ? AppColors.red : AppColors.white,
                    size: AppSizes.spacing18,
                  ),
                ),
              ),
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
                    const SizedBox(width: AppSizes.spacing4),
                    Image.asset(
                      AppAssets.star,
                      width: AppSizes.spacing14,
                      height: AppSizes.spacing14,
                    ),
                    const SizedBox(width: AppSizes.spacing2),
                    Text(data.rating.toString(), style: AppTextStyles.hintText),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing2),
                Text(
                  data.subtitle,
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
                        style: AppTextStyles.captionTitle.copyWith(
                          fontSize: AppSizes.small,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
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
}
