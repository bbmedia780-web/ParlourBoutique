import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_style.dart';
import '../routes/app_routes.dart';
import '../services/auth_services.dart';
import 'auth_controller.dart';

class InformationController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();
  
  final RxString selectedGender = AppStrings.female.obs;
  final Rx<DateTime?> selectedDate = DateTime(2024, 6, 22).obs;
  final RxBool isSubmitting = false.obs;
  final AuthServices _authServices = AuthServices();
  
  final List<String> genderOptions = [
    AppStrings.female,
    AppStrings.male,
    AppStrings.other,
  ];
  
  @override
  void onInit() {
    super.onInit();
    // Set initial values
    selectedGender.value = AppStrings.female;
    selectedDate.value = DateTime(2000, 6, 22);
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
              primary: Color(0xFFD74C7C), // AppColors.primary
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dateOfBirthController.text = AppStrings.formatDate(picked);
    }
  }
  
  void selectGender() {
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
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              AppStrings.selectGender,
              style: AppTextStyles.titleText,
            ),
            const SizedBox(height: 20),
            ...genderOptions.map((gender) => ListTile(
              title: Text(gender),
              trailing: selectedGender.value == gender
                  ? const Icon(Icons.person, color: Color(0xFFD74C7C))
                  : null,
              onTap: () {
                selectedGender.value = gender;
                genderController.text = gender;
                Get.back();
              },
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
  
  void continueToNext() async {
    // Validate form
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar(AppStrings.error, AppStrings.pleaseEnterFullName);
      return;
    }
    
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(AppStrings.error, AppStrings.pleaseEnterEmail);
      return;
    }
    
    if (dateOfBirthController.text.trim().isEmpty) {
      Get.snackbar(AppStrings.error, AppStrings.pleaseSelectDateOfBirth);
      return;
    }
    
    if (genderController.text.trim().isEmpty) {
      Get.snackbar(AppStrings.error, AppStrings.pleaseSelectGender);
      return;
    }
    
    try {
      isSubmitting.value = true;
      // Normalize values for API
      final String apiGender = (selectedGender.value).toLowerCase();
      final String apiDob = selectedDate.value != null
          ? "${selectedDate.value!.year.toString().padLeft(4, '0')}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}"
          : dateOfBirthController.text.trim();

      final response = await _authServices.updateProfile(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        gender: apiGender,
        dateOfBirth: apiDob,
      );

      if (!response.success || response.data == null) {
        Get.snackbar(AppStrings.error, response.message.isNotEmpty ? response.message : 'Failed to update profile');
        return;
      }

      // Save returned data and navigate to home
      final auth = Get.find<AuthController>();
      final saved = await auth.saveLoginDataFromApi(response.data!);
      if (!saved) {
        Get.snackbar('Warning', 'Profile updated but failed to save data locally');
      }
      await auth.refreshFromPrefs();

      Get.snackbar(AppStrings.success, AppStrings.informationSavedSuccessfully);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar(AppStrings.error, e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
  
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    super.onClose();
  }
} 