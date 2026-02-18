import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/view/screen/profile_screen/profile_page_screen.dart';
import 'package:parlour_app/view/screen/reels/reels_binding.dart';
import 'package:parlour_app/view/screen/reels/reels_controller.dart';
import 'package:parlour_app/view/screen/reels/reels_screen.dart';
import '../../controller/home_controller/main_navigation_controller.dart';
import '../../common/custom_bottom_navigation_bar.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import 'category_page_screen.dart';
import 'home_page_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  MainNavigationScreen({super.key});

  final MainNavigationController controller =
  Get.put(MainNavigationController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBody: true,
      body: Obx(() {
        int selectedIndex = controller.selectedBottomBarIndex.value;

        return IndexedStack(
          index: selectedIndex,
          children: [
            HomeScreen(),
            CategoryScreen(),
            Container(), // Add screen
            ReelsScreen(
              isActive: selectedIndex == 3, // 👈 VERY IMPORTANT
            ),
            ProfileScreen(),
          ],
        );
      }),

      floatingActionButton: Container(
        width: AppSizes.spacing54,
        height: AppSizes.spacing54,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.rosePink, AppColors.primary],
          ),
        ),
        child: RawMaterialButton(
          onPressed: () {
            controller.onAddButtonTapped();
          },
          elevation: 0,
          fillColor: Colors.transparent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: AppSizes.spacing28,
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Obx(
            () => CustomBottomNavigationBar(
          selectedIndex: controller.selectedBottomBarIndex.value,
          onItemTapped: controller.onBottomNavItemTapped,
        ),
      ),
    );
  }
}
