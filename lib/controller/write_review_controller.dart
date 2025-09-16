import 'package:get/get.dart';
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
    Get.snackbar(AppStrings.success, AppStrings.submitReviewSuccessfully);
    // Navigate back
    Get.back();
  }

}
