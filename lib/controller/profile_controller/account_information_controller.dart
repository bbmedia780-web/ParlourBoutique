import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/global.dart';
import '../../constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_strings.dart';

class AccountInformationController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  final Rx<DateTime?> selectedDate =  DateTime.now().obs;
  final RxString selectedImagePath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    dateOfBirthController.text = formatDate(selectedDate.value!);
  }

  void changePhoto() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: Text(AppStrings.chooseFromGallery),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: Text(AppStrings.takePhoto),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2,'0')}-${date.month.toString().padLeft(2,'0')}-${date.year}";
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dateOfBirthController.text = formatDate(picked);  // Update displayed date
    }
  }


  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  void saveAccountInformation() {
    // Validate form
    if (fullNameController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseEnterFullName, backgroundColor: AppColors.red);
      return;
    }

    if (emailController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseEnterEmail, backgroundColor: AppColors.red);
      return;
    }

    // Here you would typically save to backend/database
    ShowSnackBar.show(AppStrings.success, AppStrings.informationSavedSuccessfully, backgroundColor: AppColors.green);

    // Navigate back
    Get.back();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }
}
