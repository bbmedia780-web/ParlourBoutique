import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../common/common_button.dart';
import '../../controller/home_controller/filter_controller.dart';
import '../../controller/home_controller/unified_service_data_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilterController>();
    final UnifiedServiceDataController service = Get.find<UnifiedServiceDataController>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.spacing20),
          topRight: Radius.circular(AppSizes.spacing20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header section (without padding)
              Container(
                width: double.infinity,
                height: AppSizes.size50,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing16,
                  vertical: AppSizes.spacing12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: AppSizes.spacing8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(AppSizes.spacing12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: AppSizes.spacing28), // for symmetry
                    Expanded(
                      child: Center(
                        child: Text(
                          AppStrings.filter.tr,
                          style: AppTextStyles.bottomSheetHeading,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.closeBottomSheet,
                      child: Container(
                        width: AppSizes.spacing28,
                        height: AppSizes.spacing28,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.red, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.red,
                          size: AppSizes.spacing16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Rest of the content (with padding)
              Padding(
                padding: const EdgeInsets.all(AppSizes.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacing12),
                    Text(AppStrings.priceRange, style: AppTextStyles.bodyTitle),
                    Obx(() {
                      final values = controller.current.value.priceRange;
                      return Column(
                        children: [
                          RangeSlider(
                            min: 0,
                            max: 50000,
                            divisions: 100,
                            values: values,
                            activeColor: AppColors.primary,
                            onChanged: controller.setPriceRange,
                            inactiveColor: AppColors.extraLightGrey,
                          ),
                          Row(
                            children: [
                              Expanded(child: _box('${values.start.toInt()}')),
                              const SizedBox(width: AppSizes.spacing12),
                              Expanded(child: _box('${values.end.toInt()}')),
                            ],
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: AppSizes.spacing16),

                    Text(AppStrings.offers, style: AppTextStyles.bodyTitle),
                    const SizedBox(height: AppSizes.spacing8),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.toggleOfferOnly,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spacing16,
                            vertical: AppSizes.spacing10,
                          ),
                          decoration: BoxDecoration(
                            color: controller.current.value.offersOnly
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppSizes.spacing8,
                            ),
                            border: controller.current.value.offersOnly
                                ? Border.all(color: AppColors.primary)
                                : Border.all(color: AppColors.mediumGrey),
                          ),
                          child: Text(
                            AppStrings.showOffer,
                            style: controller.current.value.offersOnly
                                ? AppTextStyles.whiteNameText
                                : AppTextStyles.captionMediumTitle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing16),

                    // Hide Service Location for Boutique and Rent (show only for Parlour)
                    Obx(() {
                      final int tabIndex = service.selectedTabIndex.value;
                      final bool isParlour = tabIndex == 0;
                      if (!isParlour) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.serviceLocation,
                            style: AppTextStyles.bodyTitle,
                          ),
                          const SizedBox(height: AppSizes.spacing8),
                          Obx(() {
                            final selected = controller.current.value.serviceLocation;
                            return Row(
                              children: [
                                _chip(
                                  label: AppStrings.homeService,
                                  selected: selected == 'home',
                                  onTap: () => controller.setServiceLocation('home'),
                                ),
                                const SizedBox(width: AppSizes.spacing12),
                                _chip(
                                  label: AppStrings.parlourService,
                                  selected: selected == 'parlour',
                                  onTap: () => controller.setServiceLocation('parlour'),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: AppSizes.spacing16),
                        ],
                      );
                    }),
                    const SizedBox(height: AppSizes.spacing16),

                    Text(AppStrings.categories, style: AppTextStyles.bodyTitle),
                    const SizedBox(height: AppSizes.spacing8),
                    // Boutique gender selector displayed only for Boutique
                    Obx(() {
                      final bool isBoutique = service.selectedTabIndex.value == 1;
                      if (!isBoutique) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.spacing12),
                        child: Row(
                          children: [
                            Obx(() => _chip(
                                  label: 'Male',
                                  selected: controller.boutiqueGender.value == 'male',
                                  onTap: () => controller.setBoutiqueGender('male'),
                                )),
                            const SizedBox(width: AppSizes.spacing12),
                            Obx(() => _chip(
                                  label: 'Female',
                                  selected: controller.boutiqueGender.value == 'female',
                                  onTap: () => controller.setBoutiqueGender('female'),
                                )),
                          ],
                        ),
                      );
                    }),
                    Obx(() {
                      final int tab = service.selectedTabIndex.value;
                      final categories = controller.categoriesForTabWithGender(tab);
                      final selected = controller.selectedCategoryOrNull;
                      return DropdownButtonFormField<String>(
                        value: selected != null && categories.contains(selected) ? selected : null,
                        items: categories
                            .map((c) => DropdownMenuItem<String>(
                                  value: c,
                                  child: Text(c, style: AppTextStyles.captionMediumTitle),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) controller.setSelectedCategory(val);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spacing12,
                            vertical: AppSizes.spacing12,
                          ),
                          // Default border
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.spacing8),
                            borderSide: BorderSide(
                              color: selected != null ? AppColors.primary : Colors.grey, // change based on selection
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.spacing8),
                            borderSide: BorderSide(
                              color: selected != null ? AppColors.primary : Colors.grey, // change based on selection
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.spacing8),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey),
                        isExpanded: true,
                      );
                    }),
                    const SizedBox(height: AppSizes.spacing16),

                    Text(AppStrings.location, style: AppTextStyles.bodyTitle),
                    Obx(() {
                      final d = controller.current.value.maxDistanceKm;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            value: d,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            activeColor: AppColors.primary,
                            onChanged: controller.setDistance,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.zeroKm,
                                style: AppTextStyles.captionTitle,
                              ),
                              Text(
                                AppStrings.km100,
                                style: AppTextStyles.captionTitle,
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: AppSizes.spacing16),

                    AppButton(
                      width: double.infinity,
                      height: AppSizes.spacing45,
                      textStyle: AppTextStyles.buttonText,
                      text: AppStrings.applyFilter,
                      onPressed: () =>
                          Get.back(result: controller.current.value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(String text) {
    return Container(
      height: AppSizes.spacing40,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mediumGrey),
        borderRadius: BorderRadius.circular(AppSizes.spacing8),
      ),
      alignment: Alignment.center,
      child: Text(text, style: AppTextStyles.captionMediumTitle),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing12,
          vertical: AppSizes.spacing8,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.spacing8),
          border: selected
              ? Border.all(color: AppColors.primary)
              : Border.all(color: AppColors.mediumGrey),
        ),
        child: Text(
          label,
          style: selected
              ? AppTextStyles.whiteNameText
              : AppTextStyles.captionMediumTitle,
        ),
      ),
    );
  }
}
