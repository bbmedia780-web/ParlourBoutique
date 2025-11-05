import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/view/screen/profile_screen/profile_page_screen.dart';
import 'package:parlour_app/view/screen/reels_page_screen.dart';
import '../../controller/home_controller/main_navigation_controller.dart';
// import '../../controller/home_controller/home_controller.dart'; // Commented out - Not needed for simple 4-tab navigation
import '../../common/custom_bottom_navigation_bar.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import 'category_page_screen.dart';
import 'home_page_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  MainNavigationScreen({super.key});

  final MainNavigationController controller = Get.find<MainNavigationController>();

  final List<Widget> _screens = [
    HomeScreen(),
    CategoryScreen(),
    Container(),
    ReelsScreen(),
    ProfileScreen(),
  ];

  // Map bottom bar position to controller index (with center placeholder)
  int _getControllerIndex(int bottomBarPosition) {
    switch (bottomBarPosition) {
      case 0: return 0; // Home
      case 1: return 1; // Category
      case 3: return 3; // Reels (after center placeholder)
      case 4: return 4; // Profile
      default: return 0;
    }
  }

  // Map controller index to bottom bar position (with center placeholder)
  int _getBottomBarPosition(int controllerIndex) {
    switch (controllerIndex) {
      case 0: return 0; // Home
      case 1: return 1; // Category
      case 3: return 3; // Reels (after center placeholder)
      case 4: return 4; // Profile
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false, // Prevents keyboard from pushing up bottom nav
      extendBody: true,
      body: SafeArea(
        child: Obx(() {
        int selectedIndex = controller.selectedBottomBarIndex.value;

        int screenIndex;
        switch (selectedIndex) {
          case 0:
            screenIndex = 0;
            break;
          case 1:
            screenIndex = 1;
            break;
          case 2:
            screenIndex = 0;
            break;
          case 3:
            screenIndex = 2;
            break;
          case 4:
            screenIndex = 3;
            break;
          default:
            screenIndex = 0;
        }

        return IndexedStack(
          index: screenIndex,
          children: [
            _screens[0],
            _screens[1],
            _screens[3],
            _screens[4],
          ],
        );
        }),
      ),

      // Floating Action Button - visible on all tabs, centered
      floatingActionButton: Container(
        width: AppSizes.spacing54,
        height: AppSizes.spacing54,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.rosePink, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
      
      // Bottom Navigation Bar with center notch and placeholder
      bottomNavigationBar: Obx(() {
        return CustomBottomNavigationBar(
          selectedIndex: _getBottomBarPosition(controller.selectedBottomBarIndex.value),
          onItemTapped: (position) {
            // Ignore center placeholder tap
            if (position == 2) return;
            controller.onBottomNavItemTapped(_getControllerIndex(position));
          },
          showNotch: true,
        );
      })
    );
  }
}
