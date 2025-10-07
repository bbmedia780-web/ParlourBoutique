import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parlour_app/utility/global.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import 'home_controller.dart';
import 'reels_controller.dart';

class MainNavigationController extends GetxController {
  // -------------------- State --------------------
  final RxInt selectedBottomBarIndex = 0.obs;

  // -------------------- Lifecycle --------------------
  @override
  void onInit() {
    super.onInit();
    _setReelsActive(false);
  }

  // -------------------- Navigation --------------------
  /// Handle bottom navigation bar taps
  void onBottomNavItemTapped(int index) {
    selectedBottomBarIndex.value = index;
    _setReelsActive(index == 3); // Reels tab at index 3
  }

  /// Handle Add (+) button tap
  void onAddButtonTapped() {
    final HomeController homeController = Get.find<HomeController>();
    final int topTab = homeController.selectedTopTabIndex.value;

    if (topTab == 2) {
      // Rent tab
      Get.toNamed(AppRoutes.addRentProduct);
    } else {
      // Parlour or Boutique tab
      Get.toNamed(AppRoutes.uploadCreation);
    }
  }

  // -------------------- Reels Handling --------------------
  /// Activate or deactivate Reels tab
  void _setReelsActive(bool isActive) {
    if (Get.isRegistered<ReelsController>()) {
      final ReelsController reelsController = Get.find<ReelsController>();
      reelsController.setActiveTab(isActive);
    }
  }
}
