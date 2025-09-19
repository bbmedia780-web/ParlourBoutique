import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/view/screen/profile_screen/profile_page_screen.dart';
import 'package:parlour_app/view/screen/reels_page_screen.dart';
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

  final List<Widget> _screens = [
    HomeScreen(),
    CategoryScreen(),
    Container(),
    ReelsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBody: true,
      body: Obx(() {
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
      bottomNavigationBar: Obx(
            () => CustomBottomNavigationBar(
          selectedIndex: controller.selectedBottomBarIndex.value,
          onItemTapped: controller.onBottomNavItemTapped,
        ),
      ),
    );
  }
}
