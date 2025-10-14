import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

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

  void onGetStarted(){
    // Navigate to HomeScreen as guest user
    Get.offAllNamed(AppRoutes.home);
  }
}


