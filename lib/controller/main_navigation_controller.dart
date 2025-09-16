import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'home_controller.dart';
import 'reels_controller.dart';

class MainNavigationController extends GetxController {
  final RxInt selectedBottomBarIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _setReelsActive(false);
  }

  void onBottomNavItemTapped(int index) {
    selectedBottomBarIndex.value = index;
    _setReelsActive(index == 3);
  }

  void onAddButtonTapped() {
    // Open Add screen depends on current top tab
    final HomeController homeController = Get.find<HomeController>();
    final int topTab = homeController.selectedTopTabIndex.value;
    if (topTab == 2) {
      Get.toNamed(AppRoutes.addRentProduct);
    } else {
      Get.toNamed(AppRoutes.uploadCreation);
    }
  }

  void _setReelsActive(bool isActive) {
    if (Get.isRegistered<ReelsController>()) {
      final ReelsController reelsController = Get.find<ReelsController>();
      reelsController.setActiveTab(isActive);
    }
  }
}
