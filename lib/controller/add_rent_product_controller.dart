import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// Removed Fluttertoast in favor of app-wide ShowToast utility

import '../constants/app_strings.dart';
import '../utility/global.dart';
import 'home_controller/rent_service_controller.dart';
import 'home_controller/unified_service_data_controller.dart';

class AddRentProductController extends GetxController {
  final RxList<File> selectedImages = <File>[].obs;

  final RxString productName = ''.obs;
  final RxString category = ''.obs;
  final RxDouble rentPerDay = 0.0.obs;
  final RxDouble discountPercent = 0.0.obs;
  final RxString details = ''.obs;
  final RxString address = ''.obs;

  final ImagePicker _picker = ImagePicker();

  // Text controllers to match CommonTextField structure
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Rent categories data (UI reads from here)
  final List<String> rentCategories =  [
    AppStrings.siderCholi,
    AppStrings.lehenga,
    AppStrings.saree,
    AppStrings.gown,
    AppStrings.suit,
  ];

  void selectCategory(String? value) {
    category.value = value ?? '';
  }

  Future<void> pickImage() async {
    if (selectedImages.length >= 5) return;
    final XFile? x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) selectedImages.add(File(x.path));
  }

  void removeImageAt(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<void> save() async {
    // Sync values from text controllers
    productName.value = nameController.text.trim();
    rentPerDay.value = double.tryParse(rentController.text.replaceAll(',', '')) ?? 0.0;
    // Allow users to type values like "10" or "10%"; strip non-numeric chars
    final String _discRaw = discountController.text;
    final String _discDigits = _discRaw.replaceAll(RegExp(r'[^0-9\.]'), '');
    discountPercent.value = double.tryParse(_discDigits) ?? 0.0;
    details.value = detailsController.text.trim();
    address.value = addressController.text.trim();

    // Validate required fields
    if (productName.value.isEmpty) {
      ShowToast.error('Please enter product name');
      return;
    }

    if (category.value.isEmpty) {
      ShowToast.error('Please select a category');
      return;
    }

    if (selectedImages.isEmpty) {
      ShowToast.error('Please upload at least one image');
      return;
    }

    if (rentPerDay.value <= 0) {
      ShowToast.error('Please enter a valid rent amount');
      return;
    }
    if (address.value.isEmpty) {
      ShowToast.error(AppStrings.pleaseEnterAddress);
      return;
    }

    // Save to RentServiceController
    try {
      final rentServiceController = Get.find<RentServiceController>();
      final success = await rentServiceController.saveProduct(
        productName: productName.value,
        category: category.value,
        rentPerDay: rentPerDay.value,
        discountPercent: discountPercent.value,
        details: details.value,
        location: address.value,
        images: selectedImages.toList(),
      );

      if (success) {
        ShowToast.success(AppStrings.productSavedSuccessfully);
        // Notify UnifiedServiceDataController to refresh rent data
        try {
          final unifiedController = Get.find<UnifiedServiceDataController>();
          if (unifiedController.selectedTabIndex.value == 2) {
            unifiedController.loadDataByTab(2); // Reload rent tab
          }
        } catch (_) {}
        Get.back();
      } else {
        ShowToast.error('Failed to save product. Please try again.');
      }
    } catch (e) {
      ShowToast.error('Error saving product: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    rentController.dispose();
    discountController.dispose();
    detailsController.dispose();
    addressController.dispose();
    super.onClose();
  }
}


