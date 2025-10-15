import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utility/shared_prefs_util.dart';
import '../home_controller/main_navigation_controller.dart';

class WelcomeController extends GetxController {
  var currentPage = 0.obs;

  final int pageCount = 3;


  void setPage(int index) {
    currentPage.value = index;
  }

  void nextPage(PageController controller, int pageCount) {
    if (currentPage.value < pageCount - 1) {
      controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }
  }

  void skipToEnd(PageController controller, int pageCount) {
    controller.jumpToPage(pageCount - 1);
  }

  void onGetStarted() async {
    // Mark first-time experience as completed
    await SharedPrefsUtil.markFirstTimeCompleted();
    
    // Navigate to HomeScreen as guest user
    Get.offAllNamed(AppRoutes.home);
    
    // Reset navigation to home tab (index 0) after welcome screen
    Future.delayed(const Duration(milliseconds: 100), () {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().resetToHome();
      }
    });
  }
}


