import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';

class GenderBottomSheet extends StatelessWidget {
  final RxString selectedGender;
  final List<String> genderOptions;
  final Function(String)? onGenderSelected;

  const GenderBottomSheet({
    super.key,
    required this.selectedGender,
    required this.genderOptions,
    this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.spacing20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width:  AppSizes.spacing40,
            height:  AppSizes.spacing4,
            margin: const EdgeInsets.symmetric(vertical: AppSizes.spacing12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular( AppSizes.spacing2),
            ),
          ),
          // Title
          Text(
            AppStrings.selectGender,
            style: AppTextStyles.titleText,
          ),
          const SizedBox(height: AppSizes.spacing20),
          // Gender Options
          ...genderOptions.map((gender) => Obx(() => ListTile(
            title: Text(
              gender,
              style: AppTextStyles.inputText,
            ),
            trailing: selectedGender.value == gender
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () {
              selectedGender.value = gender;
              onGenderSelected?.call(gender);
              Get.back();
            },
          ))),
          const SizedBox(height: AppSizes.spacing20),
        ],
      ),
    );
  }
}
