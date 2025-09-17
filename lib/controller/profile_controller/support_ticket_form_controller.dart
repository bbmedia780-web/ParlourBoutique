import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/global.dart';
import '../../constants/app_colors.dart';
import '../../model/support_ticket_form_model.dart';
import '../../constants/app_strings.dart';

class SupportTicketFormController extends GetxController {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  final Rx<SupportTicketFormModel> formData = SupportTicketFormModel(
    category: AppStrings.appointmentIssue.tr,
    subject: AppStrings.defaultSubject.tr,
    description: AppStrings.defaultDescription.tr,
  ).obs;

  final RxBool isCategoryDropdownOpen = false.obs;
  final RxString selectedCategory = AppStrings.appointmentIssue.obs;

  final List<String> categories = [
    AppStrings.categoryParlourServices,
    AppStrings.categoryBoutiqueOrders,
    AppStrings.appointmentIssue,
    AppStrings.categoryProductInquiry,
    AppStrings.other,
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  void _initializeForm() {
    subjectController.text = formData.value.subject;
    descriptionController.text = formData.value.description;
  }

  void toggleCategoryDropdown() {
    isCategoryDropdownOpen.value = !isCategoryDropdownOpen.value;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    formData.value = formData.value.copyWith(category: category.tr);
    isCategoryDropdownOpen.value = false;
  }

  void updateSubject(String subject) {
    formData.value = formData.value.copyWith(subject: subject);
  }

  void updateDescription(String description) {
    formData.value = formData.value.copyWith(description: description);
  }

  void submitTicket() {
    // Validate form
    if (formData.value.subject.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error.tr, AppStrings.errorPleaseEnterSubject.tr, backgroundColor: AppColors.red);
      return;
    }

    if (formData.value.description.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error.tr, AppStrings.errorPleaseEnterDescription.tr, backgroundColor: AppColors.red);
      return;
    }

    // Submit the ticket
    ShowSnackBar.show(AppStrings.success.tr, AppStrings.successTicketSubmitted.tr, backgroundColor: AppColors.green);

    // Navigate back to help support screen
    Get.back();
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

