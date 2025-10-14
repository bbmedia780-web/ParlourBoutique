import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/global.dart';
import '../../constants/app_colors.dart';
import '../../model/support_ticket_form_model.dart';
import '../../constants/app_strings.dart';

class SupportTicketFormController extends GetxController {
  // -------------------- Text Controllers --------------------
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  // -------------------- Reactive Data --------------------
  final Rx<SupportTicketFormModel> formData = SupportTicketFormModel(
    category: AppStrings.appointmentIssue.tr,
    subject: AppStrings.defaultSubject.tr,
    description: AppStrings.defaultDescription.tr,
  ).obs;

  final RxBool isCategoryDropdownOpen = false.obs;
  final RxString selectedCategory = AppStrings.appointmentIssue.obs;

  // -------------------- Available Categories --------------------
  final List<String> categories = [
    AppStrings.categoryParlourServices,
    AppStrings.categoryBoutiqueOrders,
    AppStrings.appointmentIssue,
    AppStrings.categoryProductInquiry,
    AppStrings.other,
  ];

  // -------------------- Lifecycle --------------------
  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  void _initializeForm() {
    subjectController.text = formData.value.subject;
    descriptionController.text = formData.value.description;
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // -------------------- Category Handling --------------------
  void toggleCategoryDropdown() {
    isCategoryDropdownOpen.value = !isCategoryDropdownOpen.value;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    formData.value = formData.value.copyWith(category: category.tr);
    isCategoryDropdownOpen.value = false;
  }

  // -------------------- Form Updates --------------------
  void updateSubject(String subject) {
    formData.value = formData.value.copyWith(subject: subject);
  }

  void updateDescription(String description) {
    formData.value = formData.value.copyWith(description: description);
  }

  // -------------------- Form Submission --------------------
  void submitTicket() {
    // Validate subject
    if (formData.value.subject.trim().isEmpty) {
      ShowToast.error(AppStrings.errorPleaseEnterSubject.tr);
      return;
    }

    // Validate description
    if (formData.value.description.trim().isEmpty) {
      ShowToast.error(AppStrings.errorPleaseEnterDescription.tr);
      return;
    }

    // Show success message
    ShowToast.success(AppStrings.successTicketSubmitted.tr);

    // Navigate back to help & support screen
    Get.back();
  }
}
