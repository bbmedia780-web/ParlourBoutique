import 'package:get/get.dart';
import '../utility/global.dart';
import '../utility/validation_helper.dart';
import '../constants/app_colors.dart';
import 'dart:io';
import '../constants/app_strings.dart';
import '../routes/app_routes.dart';

class WriteReviewController extends GetxController {
  final Rx<File?> selectedMedia = Rx<File?>(null);
  final RxString reviewText = ''.obs;
  final RxString reviewError = ''.obs;
  final RxBool isFormValid = false.obs;

  void selectMedia(File file) {
    selectedMedia.value = file;
  }

  void updateReview(String text) {
    reviewText.value = text;
    validateReview();
  }
  
  void validateReview() {
    final error = ValidationHelper.validateReview(reviewText.value);
    reviewError.value = error ?? '';
    updateFormValidity();
  }
  
  void updateFormValidity() {
    isFormValid.value = reviewError.value.isEmpty;
  }

  void submitReview() {
    // Validate review before submission
    validateReview();
    
    if (!isFormValid.value) {
      ShowToast.error(reviewError.value.isNotEmpty ? reviewError.value : 'Please write a review');
      return;
    }
    
    // Add submission logic (API or local save)
    ShowToast.success(AppStrings.submitReviewSuccessfully);
    
    // Navigate to home screen after successful submission
    Get.offAllNamed(AppRoutes.home);
  }

}
