
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
  final bool showNotch;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.showNotch = false,
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
        fabLocation: showNotch ? StylishBarFabLocation.center : StylishBarFabLocation.end,
        notchStyle: NotchStyle.circle,
        hasNotch: showNotch,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        
        // Items list: with center placeholder when notch is shown
        items: showNotch ? [
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
          _buildCenterPlaceholder(),
          _buildBottomBarItem(
            icon: AppAssets.reels,
            title: AppStrings.reels,
            index: 3,
          ),
          _buildBottomBarItem(
            icon: AppAssets.profile,
            title: 'profile'.tr,
            index: 4,
          ),
        ] : [
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
          _buildBottomBarItem(
            icon: AppAssets.reels,
            title: AppStrings.reels,
            index: 2,
          ),
          _buildBottomBarItem(
            icon: AppAssets.profile,
            title: 'profile'.tr,
            index: 3,
          ),
        ],
      ),
    );
  }

  // ==================== OLD CONDITIONAL CODE - COMMENTED OUT ====================
  // Conditional logic for floating button (not needed anymore)
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(AppSizes.spacing20),
  //         topRight: Radius.circular(AppSizes.spacing20),
  //       ),
  //     ),
  //     child: StylishBottomBar(
  //       backgroundColor: AppColors.extraLightGrey,
  //       option: AnimatedBarOptions(
  //         iconStyle: IconStyle.Default,
  //       ),
  //       // Conditional notch - Shows ONLY when floating button is visible (Rent category)
  //       fabLocation: showNotch ? StylishBarFabLocation.center : StylishBarFabLocation.end,
  //       notchStyle: NotchStyle.circle, // Always set notchStyle (required parameter)
  //       hasNotch: showNotch, // Dynamic notch based on floating button visibility
  //       currentIndex: selectedIndex,
  //       onTap: onItemTapped,
  //       
  //       // ==================== CONDITIONAL ITEMS LIST ====================
  //       // When showNotch is TRUE (Rent category): 5 items with center placeholder
  //       // When showNotch is FALSE (Parlour/Boutique): 4 items evenly distributed
  //       items: showNotch ? [
  //         // RENT CATEGORY - 5 items with center placeholder for floating button
  //         _buildBottomBarItem(
  //           icon: AppAssets.home,
  //           title: 'home'.tr,
  //           index: 0, // Position 0 in bottom bar
  //         ),
  //         _buildBottomBarItem(
  //           icon: AppAssets.category,
  //           title: 'category'.tr,
  //           index: 1, // Position 1 in bottom bar
  //         ),
  //         _buildCenterPlaceholder(), // Center placeholder for floating button spacing
  //         _buildBottomBarItem(
  //           icon: AppAssets.booktab, // Booking tab
  //           title: AppStrings.booking,
  //           index: 2, // Position 2 in bottom bar (maps to controller index 3)
  //         ),
  //         _buildBottomBarItem(
  //           icon: AppAssets.profile,
  //           title: 'profile'.tr,
  //           index: 3, // Position 3 in bottom bar (maps to controller index 4)
  //         ),
  //       ] : [
  //         // PARLOUR/BOUTIQUE CATEGORY - 4 items evenly distributed (no center placeholder)
  //         _buildBottomBarItem(
  //           icon: AppAssets.home,
  //           title: 'home'.tr,
  //           index: 0, // Position 0 in bottom bar
  //         ),
  //         _buildBottomBarItem(
  //           icon: AppAssets.category,
  //           title: 'category'.tr,
  //           index: 1, // Position 1 in bottom bar
  //         ),
  //         _buildBottomBarItem(
  //           icon: AppAssets.booktab, // Booking tab
  //           title: AppStrings.booking,
  //           index: 2, // Position 2 in bottom bar (maps to controller index 3)
  //         ),
  //         _buildBottomBarItem(
  //           icon: AppAssets.profile,
  //           title: 'profile'.tr,
  //           index: 3, // Position 3 in bottom bar (maps to controller index 4)
  //         ),
  //       ],
  //     ),
  //   );
  // }

  BottomBarItem _buildBottomBarItem({
    required String icon,
    required String title,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return BottomBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
        child: Image.asset(
          icon,
          width: AppSizes.spacing24, // Increased size for better visibility
          height: AppSizes.spacing28,
          color: isSelected ? AppColors.primary : AppColors.slightGrey,
        ),
      ),
      selectedIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
        child: Image.asset(
          icon,
          width: AppSizes.spacing24, // Increased size for better visibility
          height: AppSizes.spacing28,
          color: AppColors.primary,
        ),
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

  // Creates empty space in center for floating button
  BottomBarItem _buildCenterPlaceholder() {
    return BottomBarItem(
      icon: const SizedBox(
        width: AppSizes.spacing24,
        height: AppSizes.spacing24,
      ),
      selectedIcon: const SizedBox(
        width: AppSizes.spacing24,
        height: AppSizes.spacing24,
      ),
      title: const Text(''),
      selectedColor: Colors.transparent,
      unSelectedColor: Colors.transparent,
    );
  }

  // ==================== CENTER + BUTTON - COMMENTED OUT ====================
  // BottomBarItem _buildCenterItem() {
  //   return BottomBarItem(
  //     icon: Container(
  //       width: AppSizes.spacing24,
  //       height: AppSizes.spacing24,
  //       decoration: const BoxDecoration(
  //         shape: BoxShape.circle,
  //         gradient: LinearGradient(
  //           colors: [AppColors.rosePink, AppColors.primary],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //       ),
  //       child: const Icon(
  //         Icons.add,
  //         color: Colors.white,
  //         size: AppSizes.spacing20,
  //       ),
  //     ),
  //     selectedIcon: Container(
  //       width: AppSizes.spacing24,
  //       height: AppSizes.spacing24,
  //       decoration: const BoxDecoration(
  //         shape: BoxShape.circle,
  //         gradient: LinearGradient(
  //           colors: [AppColors.rosePink, AppColors.primary],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //       ),
  //       child: const Icon(
  //         Icons.add,
  //         color: Colors.white,
  //         size: AppSizes.spacing20,
  //       ),
  //     ),
  //     title: const Text(AppStrings.emptyString),
  //     selectedColor: AppColors.primary,
  //     unSelectedColor: AppColors.primary,
  //   );
  // }
}
