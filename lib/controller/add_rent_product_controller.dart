import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddRentProductController extends GetxController {
  final RxList<File> selectedImages = <File>[].obs;

  final RxString productName = ''.obs;
  final RxString category = ''.obs;
  final RxDouble rentPerDay = 0.0.obs;
  final RxDouble discountPercent = 0.0.obs;
  final RxString details = ''.obs;

  final ImagePicker _picker = ImagePicker();

  // Text controllers to match CommonTextField structure
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  // Rent categories data (UI reads from here)
  final List<String> rentCategories = const [
    'Sider Choli',
    'Lehenga',
    'Saree',
    'Gown',
    'Suit',
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

  void save() {
    // Sync values from text controllers
    productName.value = nameController.text.trim();
    rentPerDay.value = double.tryParse(rentController.text.replaceAll(',', '')) ?? 0.0;
    discountPercent.value = double.tryParse(discountController.text) ?? 0.0;
    details.value = detailsController.text.trim();

    // Hook for API integration; for now simply pop
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    rentController.dispose();
    discountController.dispose();
    detailsController.dispose();
    super.onClose();
  }
}


