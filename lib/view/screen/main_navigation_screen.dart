import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/view/screen/profile_screen/profile_page_screen.dart';
// import 'package:parlour_app/view/screen/reels_page_screen.dart'; // Commented out - Reels removed
import 'package:parlour_app/view/screen/profile_screen/booking_page_view.dart'; // Added - Booking screen
import '../../controller/home_controller/main_navigation_controller.dart';
// import '../../controller/home_controller/home_controller.dart'; // Commented out - Not needed for simple 4-tab navigation
import '../../common/custom_bottom_navigation_bar.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import 'category_page_screen.dart';
import 'home_page_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  MainNavigationScreen({super.key});

  //final MainNavigationController controller = Get.put(MainNavigationController(), permanent: true);
  final MainNavigationController controller = Get.find<MainNavigationController>();

  final List<Widget> _screens = [
    HomeScreen(),
    CategoryScreen(),
    Container(),
    // ReelsScreen(), // Commented out - Reels removed
    BookingPageView(), // Added - Booking screen instead of Reels
    ProfileScreen(),
  ];

  // Map bottom bar position to controller index (without center button)
  int _getControllerIndex(int bottomBarPosition) {
    switch (bottomBarPosition) {
      case 0: return 0; // Home
      case 1: return 1; // Category
      case 2: return 3; // Booking (replaced Reels)
      case 3: return 4; // Profile
      default: return 0;
    }
  }

  // Map controller index to bottom bar position
  int _getBottomBarPosition(int controllerIndex) {
    switch (controllerIndex) {
      case 0: return 0; // Home
      case 1: return 1; // Category
      case 3: return 2; // Booking (replaced Reels)
      case 4: return 3; // Profile
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

      // ==================== FLOATING ACTION BUTTON - COMMENTED OUT ====================
      // Removed - Using simple 4-tab navigation
      // floatingActionButton: Obx(() {
      //   // Get current bottom navigation tab
      //   final isOnHomeTab = controller.selectedBottomBarIndex.value == 0;
      //   
      //   // Get current category tab from HomeController
      //   // 0 = Parlour, 1 = Boutique, 2 = Rent
      //   final homeController = Get.find<HomeController>();
      //   final isRentCategory = homeController.selectedTopTabIndex.value == 2;
      //   
      //   // Show floating button ONLY when:
      //   // 1. User is on Home tab (bottom navigation)
      //   // 2. AND Rent category is selected (top tabs)
      //   final shouldShowButton = isOnHomeTab && isRentCategory;
      //   
      //   if (shouldShowButton) {
      //     // Show the floating button for Rent category
      //     return Container(
      //       width: AppSizes.spacing54,
      //       height: AppSizes.spacing54,
      //       decoration: const BoxDecoration(
      //         shape: BoxShape.circle,
      //         gradient: LinearGradient(
      //           colors: [AppColors.rosePink, AppColors.primary],
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //         ),
      //       ),
      //       child: RawMaterialButton(
      //         onPressed: () {
      //           controller.onAddButtonTapped();
      //         },
      //         elevation: 0,
      //         fillColor: Colors.transparent,
      //         child: const Icon(
      //           Icons.add,
      //           color: Colors.white,
      //           size: AppSizes.spacing28,
      //         ),
      //       ),
      //     );
      //   } else {
      //     // Hide button when not on Rent category
      //     return const SizedBox.shrink();
      //   }
      // }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // ==================== BOTTOM NAVIGATION BAR ====================
      // Simple 4-tab navigation: Home, Category, Booking, Profile
      bottomNavigationBar: Obx(() {
        return CustomBottomNavigationBar(
          selectedIndex: _getBottomBarPosition(controller.selectedBottomBarIndex.value),
          onItemTapped: (position) => controller.onBottomNavItemTapped(_getControllerIndex(position)),
        );
      }),
      
      // OLD CODE - Conditional logic (commented out)
      // bottomNavigationBar: Obx(() {
      //   // Calculate if floating button is visible
      //   final isOnHomeTab = controller.selectedBottomBarIndex.value == 0;
      //   final homeController = Get.find<HomeController>();
      //   final isRentCategory = homeController.selectedTopTabIndex.value == 2;
      //   final shouldShowNotch = isOnHomeTab && isRentCategory;
      //   
      //   return CustomBottomNavigationBar(
      //     selectedIndex: _getBottomBarPosition(controller.selectedBottomBarIndex.value),
      //     onItemTapped: (position) => controller.onBottomNavItemTapped(_getControllerIndex(position)),
      //     showNotch: shouldShowNotch, // Show notch only when floating button is visible
      //   );
      // }),
      );
  }
}
