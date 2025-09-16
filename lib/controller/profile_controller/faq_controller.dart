import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_strings.dart';
import '../../model/faq_model.dart';


class FAQController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<FAQModel> allFAQs = <FAQModel>[].obs;
  final RxList<FAQModel> filteredFAQs = <FAQModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFAQs();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _initializeFAQs() {
    allFAQs.value = [
      FAQModel(
        question: AppStrings.faqQuestionServices,
        answer: AppStrings.faqAnswerServices,
      ),
      FAQModel(
        question: AppStrings.faqQuestionAppointmentAdvance,
        answer: AppStrings.faqAnswerAppointmentAdvance,
      ),
      FAQModel(
        question: AppStrings.faqQuestionHowToBook,
        answer: AppStrings.faqAnswerHowToBook,
      ),
      FAQModel(
        question: AppStrings.faqQuestionBridalPackages,
        answer: AppStrings.faqAnswerBridalPackages,
      ),
      FAQModel(
        question: AppStrings.faqQuestionChooseStylist,
        answer: AppStrings.faqAnswerChooseStylist,
      ),
      FAQModel(
        question: AppStrings.faqQuestionReturnExchange,
        answer: AppStrings.faqAnswerReturnExchange,
      ),
      FAQModel(
        question: AppStrings.faqQuestionClothingTypes,
        answer: AppStrings.faqAnswerClothingTypes,
      ),
      FAQModel(
        question: AppStrings.faqQuestionSafetyHygiene,
        answer: AppStrings.faqAnswerSafetyHygiene,
      ),
      FAQModel(
        question: AppStrings.faqQuestionBrands,
        answer: AppStrings.faqAnswerBrands,
      ),
      FAQModel(
        question: AppStrings.faqQuestionOperatingHours,
        answer: AppStrings.faqAnswerOperatingHours,
      ),
      FAQModel(
        question: AppStrings.faqQuestionHomeServices,
        answer: AppStrings.faqAnswerHomeServices,
      ),
      FAQModel(
        question: AppStrings.faqQuestionPaymentMethods,
        answer: AppStrings.faqAnswerPaymentMethods,
      ),
    ];
    filteredFAQs.value = allFAQs;
  }

  void toggleFAQ(int index) {
    if (index < filteredFAQs.length) {
      final faq = filteredFAQs[index];
      filteredFAQs[index] = faq.copyWith(isExpanded: !faq.isExpanded);
    }
  }

  void searchFAQs(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredFAQs.value = allFAQs;
    } else {
      filteredFAQs.value = allFAQs
          .where((faq) =>
              faq.question.toLowerCase().contains(query.toLowerCase()) ||
              faq.answer.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    filteredFAQs.value = allFAQs;
  }
}
