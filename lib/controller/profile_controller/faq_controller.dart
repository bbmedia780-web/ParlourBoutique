import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_strings.dart';
import '../../model/faq_model.dart';

class FAQController extends GetxController {
  // ---------------- Controllers ----------------
  final TextEditingController searchController = TextEditingController();

  // ---------------- State ----------------
  final RxList<FAQModel> allFAQs = <FAQModel>[].obs;
  final RxList<FAQModel> filteredFAQs = <FAQModel>[].obs;
  final RxString searchQuery = ''.obs;

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    _loadFAQs();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ---------------- Initialize FAQs ----------------
  void _loadFAQs() {
    allFAQs.value = [
      FAQModel(question: AppStrings.faqQuestionServices, answer: AppStrings.faqAnswerServices),
      FAQModel(question: AppStrings.faqQuestionAppointmentAdvance, answer: AppStrings.faqAnswerAppointmentAdvance),
      FAQModel(question: AppStrings.faqQuestionHowToBook, answer: AppStrings.faqAnswerHowToBook),
      FAQModel(question: AppStrings.faqQuestionBridalPackages, answer: AppStrings.faqAnswerBridalPackages),
      FAQModel(question: AppStrings.faqQuestionChooseStylist, answer: AppStrings.faqAnswerChooseStylist),
      FAQModel(question: AppStrings.faqQuestionReturnExchange, answer: AppStrings.faqAnswerReturnExchange),
      FAQModel(question: AppStrings.faqQuestionClothingTypes, answer: AppStrings.faqAnswerClothingTypes),
      FAQModel(question: AppStrings.faqQuestionSafetyHygiene, answer: AppStrings.faqAnswerSafetyHygiene),
      FAQModel(question: AppStrings.faqQuestionBrands, answer: AppStrings.faqAnswerBrands),
      FAQModel(question: AppStrings.faqQuestionOperatingHours, answer: AppStrings.faqAnswerOperatingHours),
      FAQModel(question: AppStrings.faqQuestionHomeServices, answer: AppStrings.faqAnswerHomeServices),
      FAQModel(question: AppStrings.faqQuestionPaymentMethods, answer: AppStrings.faqAnswerPaymentMethods),
    ];

    // Initially show all FAQs
    filteredFAQs.value = allFAQs;
  }

  // ---------------- Toggle FAQ Expansion ----------------
  /// Toggle the expanded/collapsed state of an FAQ item
  void toggleFAQ(int index) {
    if (index < 0 || index >= filteredFAQs.length) return;

    final faq = filteredFAQs[index];
    filteredFAQs[index] = faq.copyWith(isExpanded: !faq.isExpanded);
  }

  // ---------------- Search ----------------
  /// Filter FAQs by search query
  void searchFAQs(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredFAQs.value = allFAQs;
      return;
    }

    filteredFAQs.value = allFAQs.where((faq) {
      final q = query.toLowerCase();
      return faq.question.toLowerCase().contains(q) || faq.answer.toLowerCase().contains(q);
    }).toList();
  }

  /// Clear search and show all FAQs
  void clearSearch() {
    searchQuery.value = '';
    filteredFAQs.value = allFAQs;
    searchController.clear();
  }
}
