import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controller/guest_mode_controller.dart';
import '../home_controller/home_controller.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() {
    Future.delayed(const Duration(seconds: 3), () {
      _checkAutoLogin();
    });
  }

  Future<void> _checkAutoLogin() async {
    try {
      // Since AuthController is already registered in AppBinding
      final authController = Get.find<AuthController>();
      final guestController = Get.find<GuestModeController>();

      // Check if this is first time user
      final isFirstTime = await authController.isFirstTimeUser();
      
      if (isFirstTime) {
        // First time user, always show welcome screen
        guestController.enterGuestMode();
        Get.offAllNamed(AppRoutes.welcome);
        return;
      }

      // Check login status for returning users
      final prefsLoggedIn = authController.isLoggedIn.value;

      if (prefsLoggedIn) {
        // Already loaded user data in onInit of AuthController
        if (authController.hasValidToken()) {
          // User is logged in, exit guest mode and go to home
          guestController.exitGuestMode();
          _resetHomeAndNavigate();
        } else {
          // try refresh tokens if available
          final refreshed = await authController.refreshTokens();
          if (refreshed) {
            guestController.exitGuestMode();
            _resetHomeAndNavigate();
          } else {
            // Token refresh failed, go to home as guest
            guestController.enterGuestMode();
            _resetHomeAndNavigate();
          }
        }
      } else {
        // No login data, go to home as guest (returning user who logged out)
        guestController.enterGuestMode();
        _resetHomeAndNavigate();
      }
    } catch (e) {
      print('Error during auto-login check: $e');
      // On error, go to welcome screen as guest
      final guestController = Get.find<GuestModeController>();
      guestController.enterGuestMode();
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
  
  /// Helper method to reset home state before navigating
  void _resetHomeAndNavigate() {
    try {
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.resetHomeState();
      }
    } catch (e) {
      print('HomeController not found: $e');
    }
    Get.offAllNamed(AppRoutes.home);
  }
}
