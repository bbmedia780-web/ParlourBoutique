import 'package:flutter/material.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/home_controller/home_controller.dart';
import '../../../view/bottomsheet/filter_bottom_sheet.dart';
import 'package:get/get.dart';

class FloatingSearchBarWidget extends StatelessWidget {
  final HomeController controller;

  const FloatingSearchBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSizes.spacing8,
        bottom: AppSizes.spacing8,
        left: AppSizes.spacing18,
        right: AppSizes.spacing18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: AppSizes.size50,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.mediumGrey),
                borderRadius: BorderRadius.circular(AppSizes.spacing8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
              child: Row(
                children: [
                  Image.asset(
                    AppAssets.search,
                    width: AppSizes.spacing20,
                    color: AppColors.mediumGrey,
                  ),
                  const SizedBox(width: AppSizes.spacing12),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      cursorColor: AppColors.primary,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        // Dismiss keyboard when search is submitted
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: AppStrings.searchBridalMakeup,
                        border: InputBorder.none,
                        hintStyle: AppTextStyles.reviewTextTitle,
                      ),
                    ),
                  ),
                  /*GestureDetector(
                    onTap: controller.onMicrophoneTap,
                    child: Image.asset(
                      AppAssets.mic,
                      width: AppSizes.spacing20,
                      color: AppColors.mediumGrey,
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Container(
            width: AppSizes.size50,
            height: AppSizes.size50,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.mediumGrey),
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Get.bottomSheet(
                  const FilterBottomSheet(),
                  isScrollControlled: true,
                );
              },
              icon: Image.asset(
                AppAssets.filterBlack,
                width: AppSizes.spacing20,
                height: AppSizes.spacing20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
