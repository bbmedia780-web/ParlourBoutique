import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/filter_model.dart';
import '../../constants/app_strings.dart';

class FilterController extends GetxController {

  // -------------------- Current Filter State --------------------
  final Rx<FilterModel> current = FilterModel.initial.obs;

  // -------------------- Boutique-specific State --------------------
  final RxString boutiqueGender = 'male'.obs; // 'male' or 'female'

  // -------------------- Category Sources --------------------
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

  // -------------------- Category Helpers --------------------

  /// Get categories for a selected tab (0 = parlour, 1 = boutique).
  List<String> categoriesForTab(int selectedTabIndex) {
    return selectedTabIndex == 0 ? parlourCategories : boutiqueCategories;
  }

  /// Get categories considering boutique gender filter.
  List<String> categoriesForTabWithGender(int selectedTabIndex) {
    if (selectedTabIndex == 1) {
      return boutiqueGender.value == 'male'
          ? boutiqueMaleCategories
          : boutiqueFemaleCategories;
    }
    return categoriesForTab(selectedTabIndex);
  }

  // -------------------- State Updates --------------------

  void setBoutiqueGender(String gender) {
    boutiqueGender.value = gender;
  }

  void toggleOfferOnly() {
    current.value = current.value.copyWith(
      offersOnly: !current.value.offersOnly,
    );
  }

  void setPriceRange(RangeValues values) {
    current.value = current.value.copyWith(priceRange: values);
  }

  void setServiceLocation(String location) {
    current.value = current.value.copyWith(serviceLocation: location);
  }

  void setDistance(double km) {
    current.value = current.value.copyWith(maxDistanceKm: km);
  }

  void toggleCategory(String category) {
    final updated = Set<String>.from(current.value.selectedCategories);
    updated.contains(category) ? updated.remove(category) : updated.add(category);

    current.value = current.value.copyWith(selectedCategories: updated);
  }

  /// Set single selected category (dropdown-like behavior).
  void setSelectedCategory(String category) {
    current.value = current.value.copyWith(selectedCategories: {category});
  }

  /// Get first selected category or `null` if none.
  String? get selectedCategoryOrNull {
    return current.value.selectedCategories.isEmpty
        ? null
        : current.value.selectedCategories.first;
  }

  void reset() {
    current.value = FilterModel.initial;
  }

  void closeBottomSheet() {
    Get.back();
  }
}
