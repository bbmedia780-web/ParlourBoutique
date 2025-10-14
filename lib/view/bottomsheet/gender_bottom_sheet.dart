import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';

class GenderBottomSheet extends StatelessWidget {
  final RxString selectedGender;
  final List<String> genderOptions;

  const GenderBottomSheet({
    super.key,
    required this.selectedGender,
    required this.genderOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: AppSizes.spacing12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text("Select Gender", style: AppTextStyles.titleText),
          const SizedBox(height: AppSizes.spacing20),
          ...genderOptions.map((gender) => ListTile(
            title: Text(gender),
            trailing: selectedGender.value == gender
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () {
              selectedGender.value = gender;
              Get.back();
            },
          )),
          const SizedBox(height: AppSizes.spacing20),
        ],
      ),
    );
  }
}
