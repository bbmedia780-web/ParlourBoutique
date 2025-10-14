import 'package:flutter/material.dart';
import 'package:parlour_app/constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';
import '../../model/details_model.dart';
import '../../constants/app_strings.dart';
import '../bottomsheet/review_bottom_sheet.dart';
import 'package:get/get.dart';

class BusinessHeaderWidget extends StatelessWidget {
  final BusinessDetailsModel businessDetails;
  final VoidCallback onBackPressed;
  //final VoidCallback onSharePressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback? onTitlePressed;
  final bool isFavorite;

  const BusinessHeaderWidget({
    super.key,
    required this.businessDetails,
    required this.onBackPressed,
   // required this.onSharePressed,
    required this.onFavoritePressed,
    required this.isFavorite,
    this.onTitlePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: AppSizes.size300,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: _buildActionButton(
        icon: Icons.arrow_back_ios_new,
        onPressed: onBackPressed,
        iconColor: AppColors.black,
      ),
      actions: [
        // Share Button - COMMENTED OUT
        // _buildActionButton(
        //   imageAsset: AppAssets.share,
        //   onPressed: onSharePressed,
        // ),
        // Favorite Button - COMMENTED OUT
        // _buildActionButton(
        //   icon: isFavorite ? Icons.favorite : Icons.favorite_border,
        //   onPressed: onFavoritePressed,
        //   iconColor: isFavorite ? AppColors.red : AppColors.white,
        // ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeaderBackground(context),
      ),
    );
  }

  Widget _buildActionButton({
    IconData? icon,
    String? imageAsset,
    required VoidCallback onPressed,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.spacing8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.black.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: imageAsset != null
            ? Image.asset(
                imageAsset,
                width: AppSizes.spacing20,
                height: AppSizes.spacing20,
                color: iconColor,
              )
            : Icon(icon, color: iconColor ?? AppColors.white),
      ),
    );
  }

  Widget _buildHeaderBackground(context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset(businessDetails.image, fit: BoxFit.cover),
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
            ),
          ),
        ),
        // Business Information Overlay
        Positioned(
          bottom: AppSizes.spacing10,
          left: AppSizes.spacing20,
          right: AppSizes.spacing20,
          child: _buildBusinessInfo(context),
        ),
      ],
    );
  }

  Widget _buildBusinessInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onTitlePressed,
                    child: Text(
                      businessDetails.title,
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                  if (businessDetails.service != null &&
                      businessDetails.service!.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      businessDetails.service!,
                      style: AppTextStyles.whiteNormalText,
                    ),
                  ],
                  const SizedBox(height: AppSizes.spacing2),
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.location,
                        scale: AppSizes.scaleSize,
                        height: AppSizes.spacing14,
                      ),
                      const SizedBox(width: AppSizes.spacing4),
                      Expanded(
                        child: Text(
                          businessDetails.location,
                          style: AppTextStyles.whiteAddressText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      ReviewBottomSheet(),
                      isScrollControlled: true,
                    );
                  },
                  child: Image.asset(
                    AppAssets.star,
                    scale: AppSizes.scaleSize,
                    height: AppSizes.spacing16,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing4),
                Text(
                  '${businessDetails.rating}',
                  style: AppTextStyles.whiteNormalText,
                ),
                const SizedBox(width: AppSizes.spacing12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing10,
                    vertical: AppSizes.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: businessDetails.isOpen
                        ? AppColors.green
                        : AppColors.red,
                    borderRadius: BorderRadius.circular(AppSizes.spacing6),
                  ),
                  child: Text(
                    businessDetails.isOpen
                        ? AppStrings.open
                        : AppStrings.closed,
                    style: AppTextStyles.whiteSmallText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class PromotionCardWidget extends StatelessWidget {
  final PromotionModel promotion;
  final VoidCallback? onPressed;

  const PromotionCardWidget({
    super.key,
    required this.promotion,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing8,
          vertical: AppSizes.spacing10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(color: AppColors.mediumGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flower with discount
            SizedBox(width: AppSizes.spacing14),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  AppAssets.flower,
                  width: AppSizes.spacing40,
                  height: AppSizes.spacing40,
                  fit: BoxFit.cover,
                ),
                Text(
                  promotion.discount,
                  style: AppTextStyles.whiteSmallText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(width: AppSizes.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promotion.title,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1, // line wrap control
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${promotion.service} | ${promotion.price}',
                    style: AppTextStyles.faqsDescriptionText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTabWidget extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onCategorySelected;
  final bool useSegmentedStyle;

  const CategoryTabWidget({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    this.useSegmentedStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final int safeInitialIndex = categories.isEmpty
        ? 0
        : selectedIndex.clamp(0, categories.length - 1);

    return DefaultTabController(
      length: categories.isEmpty ? 1 : categories.length,
      initialIndex: safeInitialIndex,
      child: Builder(
        builder: (context) {
          final controller = DefaultTabController.of(context);
          if (controller.index != safeInitialIndex) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.animateTo(safeInitialIndex);
            });
          }

          final bool segmented = useSegmentedStyle;

          final TabBar tabBar = TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing14,
            ),
            dividerColor: segmented ? Colors.transparent : AppColors.lightGrey,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: segmented
                ? AppTextStyles.cardTitle
                : AppTextStyles.cardTitle,
            labelColor: segmented ? AppColors.white : AppColors.primary,
            unselectedLabelStyle: segmented
                ? AppTextStyles.cardTitle
                : AppTextStyles.cardTitle,
            unselectedLabelColor: AppColors.black,
            tabAlignment: TabAlignment.start,
            indicator: segmented
                ? BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.spacing8),
                  )
                : const UnderlineTabIndicator(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
            tabs: [
              for (final title in (categories.isEmpty ? [''] : categories))
                Tab(text: title),
            ],
            onTap: (index) => onCategorySelected(index),
          );

          if (!segmented) return tabBar;

          return Container(child: tabBar);
        },
      ),
    );
  }
}

class ServiceCardWidget extends StatelessWidget {
  final ServiceCategoryModel service;
  final VoidCallback? onPressed;

  const ServiceCardWidget({super.key, required this.service, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.spacing12),
            color: AppColors.extraLightGrey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.spacing12),
                    child: Image.asset(
                      service.image,
                      width: double.infinity,
                      height: AppSizes.size120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (service.discount != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing14,
                        vertical: AppSizes.spacing4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.lightPinkAccent,
                            AppColors.peachOrange,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.spacing10),
                          bottomRight: Radius.circular(AppSizes.spacing10),
                        ),
                      ),
                      child: Text(
                        service.discount!,
                        style: AppTextStyles.whiteSmallText,
                      ),
                    ),
                  // Favorite Button - COMMENTED OUT
                  // Positioned(
                  //   top: AppSizes.spacing8,
                  //   right: AppSizes.spacing8,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(AppSizes.spacing6),
                  //     child: Icon(
                  //       service.isFavorite == true
                  //           ? Icons.favorite
                  //           : Icons.favorite_border,
                  //       size: AppSizes.spacing16,
                  //       color: AppColors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              const SizedBox(height: AppSizes.spacing8),

              // ✅ First Row: Title + Rating
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: AppTextStyles.captionTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.star,
                          width: AppSizes.spacing14,
                          height: AppSizes.spacing14,
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Text(
                          service.rating.toString(),
                          style: AppTextStyles.faqsDescriptionText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spacing4),

              // ✅ Second Row: Price + Views
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DetailsPriceRow(
                      priceString: service.price,
                      discountLabel: service.discount,
                      oldPriceString: service.oldPrice,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.remove_red_eye_outlined,
                          size: AppSizes.spacing16,
                          color: AppColors.mediumGrey,
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Text(
                          service.views.toString(),
                          style: AppTextStyles.faqsDescriptionText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spacing8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsPriceRow extends StatelessWidget {
  final String priceString;
  final String? discountLabel;
  final String? oldPriceString;

  const _DetailsPriceRow({
    required this.priceString,
    this.discountLabel,
    this.oldPriceString,
  });

  @override
  Widget build(BuildContext context) {
    final double currentPrice = _parse(priceString);
    final double? old = oldPriceString != null && oldPriceString!.isNotEmpty
        ? _parse(oldPriceString!)
        : _oldFromDiscount(currentPrice, discountLabel);
    return Row(
      children: [
        Text(
          '₹${currentPrice.toStringAsFixed(0)}',
          style: AppTextStyles.priceText,
        ),
        if (old != null) ...[
          const SizedBox(width: AppSizes.spacing6),
          Text(
            '₹${old.toStringAsFixed(0)}',
            style: AppTextStyles.faqsDescriptionText.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.mediumGrey,
            ),
          ),
        ],
      ],
    );
  }

  double _parse(String input) {
    final sanitized = input.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(sanitized) ?? 0;
  }

  double? _oldFromDiscount(double price, String? discount) {
    if (discount == null || price <= 0) return null;
    final m = RegExp(r'(\d+)%').firstMatch(discount);
    if (m == null) return null;
    final pct = double.tryParse(m.group(1)!) ?? 0;
    if (pct <= 0 || pct >= 90) return null;
    return price / (1 - pct / 100.0);
  }
}
