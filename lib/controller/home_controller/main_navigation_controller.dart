import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parlour_app/utility/global.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../controller/auth_controller/auth_controller.dart';
import '../../controller/guest_mode_controller.dart';
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

  // -------------------- Reset --------------------
  /// Reset navigation to home tab (index 0)
  void resetToHome() {
    selectedBottomBarIndex.value = 0;
    _setReelsActive(false);
    
    // Reset home controller state when navigating to home
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.resetHomeState();
    }
  }

  // -------------------- Navigation --------------------
  /// Handle bottom navigation bar taps
  void onBottomNavItemTapped(int index) {
    // Check if user is trying to access restricted features as guest
    if (_isRestrictedTab(index)) {
      _handleRestrictedAccess(index);
      return;
    }
    
    selectedBottomBarIndex.value = index;
    // _setReelsActive(index == 3); // Commented out - Reels replaced with Booking
    _setReelsActive(false); // Reels always inactive now
    
    // Reset home state when navigating to home tab (index 0)
    if (index == 0 && Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.resetHomeState();
    }
  }

  /// Check if a tab is restricted for guest users
  bool _isRestrictedTab(int index) {
    // Category (1), Booking (3), and Profile (4) are restricted for guests
    return index == 1 || index == 3 || index == 4;
  }

  /// Handle restricted access for guest users
  void _handleRestrictedAccess(int index) {
    final authController = Get.find<AuthController>();
    
    if (!authController.isLoggedIn.value) {
      // User is guest, show login bottom sheet
      final guestController = Get.find<GuestModeController>();
      guestController.showLoginBottomSheet();
    } else {
      // User is logged in, allow access
      selectedBottomBarIndex.value = index;
      // _setReelsActive(index == 3); // Commented out - Reels replaced with Booking
      _setReelsActive(false); // Reels always inactive now
    }
  }

  /// Handle Add (+) button tap
  void onAddButtonTapped() {
    final authController = Get.find<AuthController>();
    
    if (!authController.isLoggedIn.value) {
      // User is guest, show login bottom sheet
      final guestController = Get.find<GuestModeController>();
      guestController.showLoginBottomSheet();
      return;
    }

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
