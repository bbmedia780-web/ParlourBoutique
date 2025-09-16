import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  /// Initialize app and check for auto-login
  void _initializeApp() {
    // Wait for 3 seconds for splash screen
    Future.delayed(const Duration(seconds: 3), () {
      // Check if user is already logged in
      _checkAutoLogin();
    });
  }
  
  /// Check for auto-login and navigate accordingly
  void _checkAutoLogin() async {
    try {
      // Initialize AuthController
      if (!Get.isRegistered<AuthController>()) {
        Get.put(AuthController());
      }
      
      final authController = Get.find<AuthController>();
      final isLoggedIn = await authController.isUserLoggedIn();
      
      if (isLoggedIn) {
        await authController.refreshFromPrefs();
        ///User is logged in, navigate to home screen
        Get.offAllNamed(AppRoutes.home);
      } else {
        /// User is not logged in, navigate to welcome screen
        Get.offAllNamed(AppRoutes.welcome);
      }
    } catch (e) {
      print('Error during auto-login check: $e');
      // On error, navigate to welcome screen
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
