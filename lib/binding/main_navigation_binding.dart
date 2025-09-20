import 'package:get/get.dart';
import '../controller/home_controller/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainNavigationController(), permanent: true);
  }
}
