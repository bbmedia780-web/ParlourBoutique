import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_style.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

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
      child: StylishBottomBar(
        backgroundColor: AppColors.extraLightGrey,
        option: AnimatedBarOptions(
          iconStyle: IconStyle.Default,
        ),
        fabLocation: StylishBarFabLocation.center,
        notchStyle: NotchStyle.circle,
        hasNotch: true,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          _buildBottomBarItem(
            icon: AppAssets.home,
            title: 'home'.tr,
            index: 0,
          ),
          _buildBottomBarItem(
            icon: AppAssets.category,
            title: 'category'.tr,
            index: 1,
          ),
          _buildCenterItem(),
          _buildBottomBarItem(
            icon: AppAssets.reels,
            title: 'reels'.tr,
            index: 3,
          ),
          _buildBottomBarItem(
            icon: AppAssets.profile,
            title: 'profile'.tr,
            index: 4,
          ),
        ],
      ),
    );
  }

  BottomBarItem _buildBottomBarItem({
    required String icon,
    required String title,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    
    return BottomBarItem(
      icon: Image.asset(
        icon,
        width: AppSizes.spacing24,
        height: AppSizes.spacing24,
        color: isSelected ? AppColors.primary : AppColors.slightGrey,
      ),
      selectedIcon: Image.asset(
        icon,
        width: AppSizes.spacing24,
        height: AppSizes.spacing24,
        color: AppColors.primary,
      ),
      title: Text(
        title,
        style: isSelected 
            ? AppTextStyles.priceText
            : AppTextStyles.hintText,
      ),
      selectedColor: AppColors.primary,
      unSelectedColor: AppColors.slightGrey,
    );
  }

  BottomBarItem _buildCenterItem() {
    return BottomBarItem(
      icon: Container(
        width: AppSizes.spacing24,
        height: AppSizes.spacing24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.rosePink, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: AppSizes.spacing20,
        ),
      ),
      selectedIcon: Container(
        width: AppSizes.spacing24,
        height: AppSizes.spacing24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.rosePink, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: AppSizes.spacing20,
        ),
      ),
      title: const Text(AppStrings.emptyString),
      selectedColor: AppColors.primary,
      unSelectedColor: AppColors.primary,
    );
  }
}
