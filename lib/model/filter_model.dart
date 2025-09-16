import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

/// Simple filter data model to be used by both Parlour and Boutique flows
class FilterModel {
  final RangeValues priceRange;
  final bool offersOnly;
  final String serviceLocation; // "home" or "parlour"
  final Set<String> selectedCategories; // tag style categories
  final double maxDistanceKm; // 0..100

  const FilterModel({
    required this.priceRange,
    required this.offersOnly,
    required this.serviceLocation,
    required this.selectedCategories,
    required this.maxDistanceKm,
  });

  FilterModel copyWith({
    RangeValues? priceRange,
    bool? offersOnly,
    String? serviceLocation,
    Set<String>? selectedCategories,
    double? maxDistanceKm,
  }) {
    return FilterModel(
      priceRange: priceRange ?? this.priceRange,
      offersOnly: offersOnly ?? this.offersOnly,
      serviceLocation: serviceLocation ?? this.serviceLocation,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }

  static FilterModel get initial => FilterModel(
        priceRange: const RangeValues(10000, 15000),
        offersOnly: false,
        serviceLocation: AppStrings.defaultServiceLocation,
        selectedCategories: <String>{},
        maxDistanceKm: 50,
      );
}


