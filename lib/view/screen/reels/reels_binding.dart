import 'package:get/get.dart';
import 'package:parlour_app/view/screen/reels/reels_controller.dart';

class ReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReelsController());
  }
}

