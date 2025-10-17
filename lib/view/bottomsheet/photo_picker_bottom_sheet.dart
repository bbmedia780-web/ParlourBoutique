import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';

class PhotoPickerBottomSheet extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const PhotoPickerBottomSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.spacing20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(
              top: AppSizes.spacing12,
              bottom: AppSizes.spacing20,
            ),
            width: AppSizes.spacing40,
            height: AppSizes.spacing4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppSizes.spacing2),
            ),
          ),
          
          // Title
          Text(
            AppStrings.selectPhoto,
            style: AppTextStyles.titleText,
          ),
          const SizedBox(height: AppSizes.spacing12),
          
          // Gallery Option
          ListTile(
            leading: const Icon(
              Icons.photo_library,
              color: AppColors.primary,
            ),
            title: Text(
              AppStrings.chooseFromGallery,
              style: AppTextStyles.inputText,
            ),
            onTap: () {
              Get.back();
              onGalleryTap();
            },
          ),
          
          // Camera Option
          ListTile(
            leading: const Icon(
              Icons.camera_alt,
              color: AppColors.primary,
            ),
            title: Text(
              AppStrings.takePhoto,
              style: AppTextStyles.inputText,
            ),
            onTap: () {
              Get.back();
              onCameraTap();
            },
          ),
          
          const SizedBox(height: AppSizes.spacing20),
        ],
      ),
    );
  }
}

