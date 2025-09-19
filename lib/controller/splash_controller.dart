import 'package:get/get.dart';
import '../routes/app_routes.dart';
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

      // Check login status
      final prefsLoggedIn = authController.isLoggedIn.value;

      if (prefsLoggedIn) {
        // Already loaded user data in onInit of AuthController
        if (authController.hasValidToken()) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          // try refresh tokens if available
          final refreshed = await authController.refreshTokens();
          if (refreshed) {
            Get.offAllNamed(AppRoutes.home);
          } else {
            Get.offAllNamed(AppRoutes.welcome);
          }
        }
      } else {
        Get.offAllNamed(AppRoutes.welcome);
      }
    } catch (e) {
      print('Error during auto-login check: $e');
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
