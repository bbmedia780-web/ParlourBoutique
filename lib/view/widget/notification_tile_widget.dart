import 'package:flutter/material.dart';
import 'package:parlour_app/constants/app_text_style.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../model/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacing16,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.extraLightGrey,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: AppSizes.size50,
              height: AppSizes.size50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(notification.businessImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: AppSizes.spacing12),

            // Right Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with Provider Name and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          notification.businessName,
                          style: AppTextStyles.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: AppSizes.spacing8),

                      // Date
                      Text(
                        notification.dateTime,
                        style: AppTextStyles.greyVerySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing4),

                  // Description
                  Text(
                    notification.offerDescription,
                    style: AppTextStyles.grayTiny,
                    softWrap: true,
                  ),

                  const SizedBox(height: AppSizes.spacing4),

                  // Call to Action
                  Text(
                    notification.callToAction,
                    style: AppTextStyles.grayTiny,
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

