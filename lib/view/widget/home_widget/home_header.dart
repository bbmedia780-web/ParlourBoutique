import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/view/widget/home_widget/unified_banner.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/auth_controller/auth_controller.dart';
import '../../../controller/home_controller/home_controller.dart';
import '../../../controller/home_controller/unified_service_data_controller.dart';
import '../../../view/bottomsheet/filter_bottom_sheet.dart';
import '../../../controller/home_controller/filter_controller.dart';

class HomeHeader extends StatelessWidget {
  final HomeController controller;
  final AuthController authController;
  final UnifiedServiceDataController unifiedServiceController;

  const HomeHeader({
    super.key,
    required this.controller,
    required this.authController,
    required this.unifiedServiceController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.size380,
      child: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.white, AppColors.lightPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.spacing24),
                bottomRight: Radius.circular(AppSizes.spacing24),
              ),
            ),
          ),

          // ✅ Floating Icons
          Positioned(
            bottom: AppSizes.size110,
            left: AppSizes.size120,
            child: Image.asset(AppAssets.spiral, height: AppSizes.spacing12),
          ),
          Positioned(
            bottom: AppSizes.spacing20,
            right: AppSizes.spacing30,
            child: Image.asset(AppAssets.heart, height: AppSizes.spacing12),
          ),
          Positioned(
            bottom: AppSizes.spacing62,
            right: AppSizes.spacing40,
            child: Image.asset(AppAssets.infinity, height: AppSizes.spacing8),
          ),
          Positioned(
            bottom: AppSizes.spacing35,
            left: AppSizes.size150,
            child: Image.asset(AppAssets.plus, height: AppSizes.spacing10),
          ),
          Positioned(
            bottom: AppSizes.size90,
            left: AppSizes.size180,
            child: Image.asset(AppAssets.bubble, height: AppSizes.spacing12),
          ),
          Positioned(
            bottom: AppSizes.size110,
            right: AppSizes.spacing20,
            child: Image.asset(AppAssets.bubble, height: AppSizes.spacing14),
          ),

          // Content
          Padding(
            padding: EdgeInsets.only(
              left: AppSizes.spacing20,
              right: AppSizes.spacing20,
              top: MediaQuery.of(context).padding.top + AppSizes.spacing6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: AppSizes.spacing16),
                _buildTabs(),
                const SizedBox(height: AppSizes.spacing16),
                _buildSearchAndFilter(),
                const SizedBox(height: AppSizes.spacing8),
                UnifiedBanner(
                  unifiedController: unifiedServiceController,
                  homeController: controller,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            AppAssets.user,
            height: AppSizes.spacing45,
            width: AppSizes.spacing45,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: AppSizes.spacing8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                authController.userName.value.isNotEmpty
                    ? authController.userName.value
                    : 'Guest',
                style: AppTextStyles.captionTitle,
              )),
              Obx(() => Text(
                authController.mobile.value.isNotEmpty
                    ? authController.mobile.value
                    : AppStrings.userAddress,
                style: AppTextStyles.faqsDescriptionText,
              )),
            ],
          ),
        ),
        IconButton(
          onPressed: controller.onNotificationTap,
          icon: Image.asset(AppAssets.notification, height: AppSizes.spacing32),
        ),
        IconButton(
          onPressed: controller.onChatTap,
          icon: Image.asset(AppAssets.message, height: AppSizes.spacing32),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Obx(() {
      final selected = controller.selectedTopTabIndex.value;
      return Row(
        children: [
          _tabItem(AppStrings.parlourTab, AppAssets.parlour, 0, selected == 0),
          const SizedBox(width: AppSizes.spacing8),
          _tabItem(AppStrings.rentTab, AppAssets.rentIcon, 2, selected == 2),
        ],
      );
    });
  }

  Widget _tabItem(String title, String icon, int index, bool selected) {
    return GestureDetector(
      onTap: () {
        controller.onTopTabSelected(index);
        unifiedServiceController.loadDataByTab(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: AppSizes.size100,
        height: AppSizes.size80,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
            colors: [AppColors.rosePink, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          )
              : null,
          color: selected ? null : Colors.white,
          border: selected
              ? null
              : Border.all(color: AppColors.lightGrey, width: 1.2),
          borderRadius: BorderRadius.circular(AppSizes.spacing15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: AppSizes.spacing45),
            Text(title,
                style: selected
                    ? AppTextStyles.whiteNameText
                    : AppTextStyles.captionTitle),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: AppSizes.size50,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.mediumGrey),
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
            child: Row(
              children: [
                Image.asset(AppAssets.search,
                    width: AppSizes.spacing20, color: AppColors.mediumGrey),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: AppStrings.searchBridalMakeup,
                      border: InputBorder.none,
                      hintStyle: AppTextStyles.reviewTextTitle,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.onMicrophoneTap,
                  child: Image.asset(AppAssets.mic,
                      width: AppSizes.spacing20, color: AppColors.mediumGrey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Container(
          width: AppSizes.size50,
          height: AppSizes.size50,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mediumGrey),
            borderRadius: BorderRadius.circular(AppSizes.spacing8),
          ),
          child: IconButton(
            onPressed: () {
              if (!Get.isRegistered<FilterController>()) {
                Get.put(FilterController());
              }
              Get.bottomSheet(const FilterBottomSheet(),
                  isScrollControlled: true);
            },
            icon: Image.asset(AppAssets.filterBlack,
                width: AppSizes.spacing20, height: AppSizes.spacing20),
          ),
        ),
      ],
    );
  }
}



