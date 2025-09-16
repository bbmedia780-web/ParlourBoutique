import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/filter_model.dart';
import '../constants/app_strings.dart';

class FilterController extends GetxController {
  final Rx<FilterModel> current = FilterModel.initial.obs;
  // Boutique-only UI state: 'male' or 'female'
  final RxString boutiqueGender = 'male'.obs;

  // Category sources kept here for both types
  final List<String> parlourCategories = const [
    AppStrings.chipHairCut,
    AppStrings.chipFacialCleanup,
    AppStrings.chipMassageSpa,
    AppStrings.chipManicurePedicure,
    AppStrings.chipMakeupBridal,
    AppStrings.chipHairColorHighlights,
    AppStrings.chipThreadingWaxing,
  ];

  final List<String> boutiqueCategories = const [
    AppStrings.chipCustomizable,
    AppStrings.chipIndoWestern,
    AppStrings.chipBridalCholi,
    AppStrings.chipEmbroidery,
    AppStrings.chipFormalWear,
    AppStrings.chipTrendy,
  ];

  // Boutique gender-wise groupings (simple partition using available strings)
  final List<String> boutiqueMaleCategories = const [
    AppStrings.chipFormalWear,
    AppStrings.chipIndoWestern,
    AppStrings.chipTrendy,
  ];

  final List<String> boutiqueFemaleCategories = const [
    AppStrings.chipBridalCholi,
    AppStrings.chipCustomizable,
    AppStrings.chipEmbroidery,
  ];

  List<String> categoriesForTab(int selectedTabIndex) {
    return selectedTabIndex == 0 ? parlourCategories : boutiqueCategories;
  }

  List<String> categoriesForTabWithGender(int selectedTabIndex) {
    if (selectedTabIndex == 1) {
      return boutiqueGender.value == 'male'
          ? boutiqueMaleCategories
          : boutiqueFemaleCategories;
    }
    return categoriesForTab(selectedTabIndex);
  }

  void setBoutiqueGender(String gender) {
    boutiqueGender.value = gender;
  }

  void toggleOfferOnly() {
    current.value = current.value.copyWith(offersOnly: !current.value.offersOnly);
  }

  void setPriceRange(RangeValues values) {
    current.value = current.value.copyWith(priceRange: values);
  }

  void setServiceLocation(String value) {
    current.value = current.value.copyWith(serviceLocation: value);
  }

  void toggleCategory(String category) {
    final updated = Set<String>.from(current.value.selectedCategories);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    current.value = current.value.copyWith(selectedCategories: updated);
  }

  // For dropdown (single select) use only one selected category
  void setSelectedCategory(String category) {
    current.value = current.value.copyWith(selectedCategories: {category});
  }

  String? get selectedCategoryOrNull {
    if (current.value.selectedCategories.isEmpty) return null;
    return current.value.selectedCategories.first;
  }

  void setDistance(double km) {
    current.value = current.value.copyWith(maxDistanceKm: km);
  }

  void reset() {
    current.value = FilterModel.initial;
  }

  void closeBottomSheet() {
    Get.back();
  }
}


