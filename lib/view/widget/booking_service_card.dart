import 'package:flutter/material.dart';
import '../../common/common_button.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../model/booking_service_model.dart';
import '../../utility/global.dart';

class BookingServiceCard extends StatelessWidget {
  final BookingServiceModel service;
  final VoidCallback onTap;
  final VoidCallback onBookNow;

  const BookingServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.spacing12),
          border: Border.all(color: AppColors.extraLightGrey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.spacing12),
                child: Image.asset(
                  service.image,
                  height: AppSizes.size100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: AppSizes.spacing8),

              // Title
              Text(
                service.title,
                style: AppTextStyles.captionTitle,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSizes.spacing2),

              // Subtitle
              Text(
                service.subtitle,
                style:AppTextStyles.faqsDescriptionText,
                overflow: TextOverflow.ellipsis,
              ),

              AppGlobal.commonDivider(
                color: AppColors.lightGrey,
              ),

              // Price and Book Now Button
              Row(
                children: [
                  Text(
                    '₹${service.price.toStringAsFixed(2)}',
                    style: AppTextStyles.priceText
                  ),
                  const Spacer(),
                  SizedBox(
                    height: AppSizes.spacing22,
                    child: AppButton(
                      text: AppStrings.bookNow,
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacing4),
                      onPressed: onBookNow,
                      isPrimary: true,
                      borderRadius: AppSizes.spacing4,
                      textStyle: AppTextStyles.whiteTinyText
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

