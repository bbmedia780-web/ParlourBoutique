
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: AppSizes.size60,
              height: AppSizes.size60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: AppColors.primary,
                        width: AppSizes.borderWidth1_5,
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacing2),
                child: ClipOval(
                  child: Image.asset(
                    icon,
                    width: AppSizes.size50,
                    height: AppSizes.size50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          SizedBox(
            width: AppSizes.size80,
            child: Text(
              title,
              style: isSelected
                  ? AppTextStyles.smallTitle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    )
                  : AppTextStyles.smallTitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
