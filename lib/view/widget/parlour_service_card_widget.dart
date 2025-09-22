import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../model/unified_data_model.dart';
import '../../routes/app_routes.dart';

class ParlourServiceCardWidget extends StatelessWidget {
  final UnifiedDataModel data;
  final VoidCallback onFavoriteTap;

  const ParlourServiceCardWidget({
    super.key,
    required this.data,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.details, arguments: data),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.spacing16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: AppSizes.spacing12,
              offset: const Offset(0, AppSizes.spacing6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: AppSizes.spacing4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -------- IMAGE + DISCOUNT ----------
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.spacing12),
              child: Stack(
                children: [
                  Image.asset(
                    data.image,
                    width: AppSizes.size120,
                    height: AppSizes.size150,
                    fit: BoxFit.cover,
                  ),

                  /// discount text
                  if (data.discount.isNotEmpty)
                    Positioned(
                      top: AppSizes.spacing12,
                      left: -12,
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: AppSizes.spacing8,
                          top: AppSizes.spacing4,
                          bottom: AppSizes.spacing4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.black26, Colors.black38, Colors.black38],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(AppSizes.spacing12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: AppSizes.spacing20),
                          child: Text(
                            data.discount,
                            style: AppTextStyles.whiteSmallText,
                          ),
                        ),
                      ),
                    ),

                  /// gradient overlay bottom
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: AppSizes.size50,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSizes.spacing14),

            /// -------- CONTENT ----------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + favorite
                  Row(
                    children: [
                      Expanded(
                        child: Text(data.title, style: AppTextStyles.cardTitle),
                      ),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          data.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.red,
                          size: AppSizes.spacing18,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Image.asset(
                        AppAssets.star,
                        width: AppSizes.spacing14,
                        height: AppSizes.spacing14,
                      ),
                      const SizedBox(width: AppSizes.spacing4),
                      Text(data.rating, style: AppTextStyles.hintText),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing4),

                  Row(
                    children: [
                      Image.asset(
                        AppAssets.location,
                        width: AppSizes.spacing12,
                        height: AppSizes.spacing12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSizes.spacing6),
                      Expanded(
                        child: Text(
                          data.location,
                          style: AppTextStyles.captionMediumTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing4),
                  Text(AppStrings.bestService, style: AppTextStyles.hashTag),

                  const SizedBox(height: AppSizes.spacing4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing12,
                        vertical: AppSizes.spacing6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.peachOrange, AppColors.lightPinkAccent],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.spacing10),
                      ),
                      child: Text(
                        data.type == AppStrings.parlourType
                            ? AppStrings.facialHairCut
                            : '${data.subtitle} & Suit',
                        style: AppTextStyles.whiteNameText,
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(top: AppSizes.spacing12, right: AppSizes.spacing8),
            ),
          ],
        ),
      ),
    );
  }
}
