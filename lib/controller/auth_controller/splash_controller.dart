import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controller/guest_mode_controller.dart';
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

      // Check login status
      final prefsLoggedIn = authController.isLoggedIn.value;

      if (prefsLoggedIn) {
        // Already loaded user data in onInit of AuthController
        if (authController.hasValidToken()) {
          // User is logged in, exit guest mode and go to home
          guestController.exitGuestMode();
          Get.offAllNamed(AppRoutes.home);
        } else {
          // try refresh tokens if available
          final refreshed = await authController.refreshTokens();
          if (refreshed) {
            guestController.exitGuestMode();
            Get.offAllNamed(AppRoutes.home);
          } else {
            // Token refresh failed, go to welcome screen
            guestController.enterGuestMode();
            Get.offAllNamed(AppRoutes.welcome);
          }
        }
      } else {
        // No login data, go to welcome screen as guest
        guestController.enterGuestMode();
        Get.offAllNamed(AppRoutes.welcome);
      }
    } catch (e) {
      print('Error during auto-login check: $e');
      // On error, go to welcome screen as guest
      final guestController = Get.find<GuestModeController>();
      guestController.enterGuestMode();
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
