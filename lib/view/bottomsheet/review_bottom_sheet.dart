import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';
import '../../constants/app_strings.dart';
import '../../controller/review_controller.dart';
import '../../routes/app_routes.dart';
import '../widget/review_tile_widget.dart';

class ReviewBottomSheet extends StatelessWidget {
  ReviewBottomSheet({super.key});

  final ReviewController controller = Get.find<ReviewController>();

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
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                height: AppSizes.size50,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing16,
                  vertical: AppSizes.spacing12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppSizes.spacing8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(AppSizes.spacing12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: AppSizes.spacing28),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppStrings.review,
                          style: AppTextStyles.bottomSheetHeading,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: Get.back,
                      child: Container(
                        width: AppSizes.spacing28,
                        height: AppSizes.spacing28,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.red, width: AppSizes.borderWidth1_5),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.red,
                          size: AppSizes.spacing16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Obx(() {
                final rating = controller.averageRating.value;
                return Column(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTextStyles.displayText,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating.floor()
                              ? Icons.star
                              : (rating - index >= 0.5
                                    ? Icons.star_half
                                    : Icons.star_border),
                          color: AppColors.yellowGold,
                          size: AppSizes.spacing24,
                        );
                      }),
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Text(
                      AppStrings.basedOnReviews(
                        controller.totalReviews.value,
                      ),
                      style: AppTextStyles.faqsDescriptionText,
                    ),
                  ],
                );
              }),

              // Reviews List
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.reviews.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSizes.spacing12),
                  itemBuilder: (context, index) {
                    final review = controller.reviews[index];
                    return ReviewTile(review: review);
                  },
                ),
              ).paddingOnly(right: AppSizes.spacing12,left: AppSizes.spacing12),

              Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewPadding.bottom;

                  return Padding(
                    padding: EdgeInsets.only(
                      left: AppSizes.spacing20,
                      right: AppSizes.spacing20,
                      bottom: bottomInset + AppSizes.spacing16,
                      top: bottomInset + AppSizes.spacing16,
                    ),
                    child: GestureDetector(
                      onTap: () {
                       Get.toNamed(AppRoutes.writeReview);
                      },
                      child: Container(
                        height: AppSizes.size50,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacing16,
                          vertical: AppSizes.spacing12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.primary, width: AppSizes.borderWidth2),
                          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                        ),
                        child: Center(
                          child: Text(
                              AppStrings.writeReview,
                              style: AppTextStyles.primaryButtonText
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
