import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../model/unified_data_model.dart';
import '../../routes/app_routes.dart';

class UnifiedServiceCard extends StatelessWidget {
  final UnifiedDataModel data;
  final int index;
  final VoidCallback onFavoriteTap;

  const UnifiedServiceCard({
    super.key,
    required this.data,
    required this.index,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRent = data.type == AppStrings.rentType;
    final double imageWidth = isRent ? AppSizes.size120 : AppSizes.size120;
    final double imageHeight = isRent ? AppSizes.size120 : AppSizes.size150;
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
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.spacing12),
              child: Stack(
                children: [
                  Image.asset(
                    data.image,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.title,
                          style: AppTextStyles.cardTitle,
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.spacing6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.extraLightGrey,
                          ),
                          child: Icon(
                            data.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.red,
                            size: AppSizes.spacing18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (data.type == AppStrings.rentType) ...[
                    Text(
                      data.subtitle,
                      style: AppTextStyles.captionMediumTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Row(
                      children: [
                        Text(
                          '₹ ${data.price?.toStringAsFixed(0) ?? ''}',
                          style: AppTextStyles.captionMediumTitle,
                        ),
                        if (data.oldPrice != null) ...[
                          const SizedBox(width: AppSizes.spacing8),
                          Text(
                            '₹ ${data.oldPrice!.toStringAsFixed(0)}',
                            style: AppTextStyles.hintText.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                        if (data.offerText != null && data.offerText!.isNotEmpty) ...[
                          const SizedBox(width: AppSizes.spacing8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spacing8,
                              vertical: AppSizes.spacing2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightPinkAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppSizes.spacing6),
                            ),
                            child: Text(
                              data.offerText!,
                              style: AppTextStyles.smallTitle.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ] else
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
                  if (data.type != AppStrings.rentType) ...[
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
                ],
              ).paddingOnly(top: AppSizes.spacing12, right: AppSizes.spacing8),
            ),
          ],
        ),
      ),
    );
  }
}

