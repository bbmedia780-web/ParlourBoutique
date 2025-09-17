import 'package:get/get.dart';
import '../utility/global.dart';
import '../constants/app_colors.dart';
import 'dart:io';
import '../constants/app_strings.dart';

class WriteReviewController extends GetxController {
  final Rx<File?> selectedMedia = Rx<File?>(null);
  final RxString reviewText = ''.obs;

  void selectMedia(File file) {
    selectedMedia.value = file;
  }

  void updateReview(String text) {
    reviewText.value = text;
  }

  void submitReview() {
    // Add submission logic (API or local save)
    ShowSnackBar.show(AppStrings.success, AppStrings.submitReviewSuccessfully, backgroundColor: AppColors.green);
    // Navigate back
    Get.back();
  }

}
