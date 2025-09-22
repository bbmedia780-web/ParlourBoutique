import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';
import '../../model/unified_data_model.dart';
import '../../routes/app_routes.dart';

class RentServiceCardWidget extends StatelessWidget {
  final UnifiedDataModel data;
  final VoidCallback onFavoriteTap;

  const RentServiceCardWidget({
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
              color: Colors.black.withOpacity(0.08),
              blurRadius: AppSizes.spacing12,
              offset: const Offset(0, AppSizes.spacing6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: AppSizes.spacing4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            const SizedBox(width: AppSizes.spacing14),
            Expanded(child: _buildContentSection()),
          ],
        ),
      ),
    );
  }

  /// ---------------- IMAGE SECTION ----------------
  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.spacing12),
      child: Stack(
        children: [
          Image.asset(
            data.image,
            width: AppSizes.size110,
            height: AppSizes.size110,
            fit: BoxFit.cover,
          ),
          if (data.discount.isNotEmpty) _buildDiscountBadge(),
          _buildBottomGradient(),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge() {
    return Positioned(
      top: AppSizes.spacing12,
      left: -12,
      child: Container(
        padding: const EdgeInsets.only(
            left: AppSizes.spacing20,
            right: AppSizes.spacing8,
            top: AppSizes.spacing4,
            bottom: AppSizes.spacing4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black26, Colors.black38, Colors.black38],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(AppSizes.spacing12),
        ),
        child: Text(
          data.discount,
          style: AppTextStyles.whiteSmallText,
        ),
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: AppSizes.spacing40,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black45, Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------------- CONTENT SECTION ----------------
  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spacing12, right: AppSizes.spacing8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            data.subtitle,
            style: AppTextStyles.hintText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSizes.spacing6),
          _buildStatsRow(),
          const SizedBox(height: AppSizes.spacing6),
          _buildLocationRow(),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Expanded(child: Text(data.title, style: AppTextStyles.cardTitle)),
        GestureDetector(
          onTap: onFavoriteTap,
          child: Icon(
            data.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: AppColors.red,
            size: AppSizes.spacing18,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _iconText(Icons.currency_rupee, data.price?.toStringAsFixed(0) ?? ''),
        _verticalDivider(),
        _iconTextAsset(AppAssets.eye, '${data.view ?? 0}'),
        _verticalDivider(),
        _iconTextAsset(AppAssets.star, data.rating),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Image.asset(AppAssets.location, scale: AppSizes.scaleSize, color: AppColors.primary),
        const SizedBox(width: AppSizes.spacing4),
        Expanded(
          child: Text(
            data.location,
            style: AppTextStyles.captionMediumTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// ---------------- HELPER WIDGETS ----------------
  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: AppSizes.spacing14, color: AppColors.grey),
        const SizedBox(width: AppSizes.spacing2),
        Text(text, style: AppTextStyles.welcomePageDes),
      ],
    );
  }

  Widget _iconTextAsset(String asset, String text) {
    return Row(
      children: [
        Image.asset(asset, height: AppSizes.spacing14),
        const SizedBox(width: AppSizes.spacing4),
        Text(text, style: AppTextStyles.captionMediumTitle),
      ],
    );
  }

  Widget _verticalDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: SizedBox(
        height: AppSizes.spacing12,
        child: VerticalDivider(color: Colors.grey, thickness: 1),
      ),
    );
  }
}
