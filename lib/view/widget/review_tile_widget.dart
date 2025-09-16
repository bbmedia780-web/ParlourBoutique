import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../model/review_model.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';
import '../../utility/global.dart';

class ReviewTile extends StatelessWidget {
  final ReviewModel review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppGlobal.commonDivider(
          color: AppColors.lightGrey,
          indent: AppSizes.spacing10,
          endIndent: AppSizes.spacing10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar
            CircleAvatar(
              backgroundImage: AssetImage(review.userAvatarAsset),
              radius: AppSizes.spacing24,
            ),
            const SizedBox(width: AppSizes.spacing12),

            // Review Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          review.userName,
                          style: AppTextStyles.bodyTitle,
                        ),
                      ),
                      Text(review.dateString, style: AppTextStyles.faqsDescriptionText),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing4),

                  // Rating Stars + Score
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < review.rating.floor()
                              ? Icons.star
                              : (review.rating - index >= 0.5
                              ? Icons.star_half
                              : Icons.star_border),
                          color: AppColors.yellowGold,
                          size: AppSizes.spacing16,
                        );
                      }),
                      const SizedBox(width: AppSizes.spacing6),
                      Text(
                          review.rating.toStringAsFixed(1),
                          style: AppTextStyles.faqsDescriptionText
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing8),

                  // Review Text
                  Text(
                      review.reviewText,
                      style: AppTextStyles.reviewTextTitle
                  ),
                ],
              ),
            ),
          ],
        ),
        AppGlobal.commonDivider(
          color: AppColors.lightGrey,
          endIndent: AppSizes.spacing10,
          indent: AppSizes.spacing10,
        ),
      ],
    );
  }
}
