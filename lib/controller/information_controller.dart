import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_text_style.dart';
import '../services/auth_services.dart';
import '../constants/app_strings.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../routes/app_routes.dart';
import '../utility/global.dart';
import 'auth_controller.dart';

class InformationController extends GetxController {
  // ---------------- Controllers ----------------
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();

  // ---------------- State ----------------
  final RxString selectedGender = "".obs;
  final Rx<DateTime?> selectedDate = DateTime.now().obs;
  final RxBool isSubmitting = false.obs;

  final List<String> genderOptions = [
    AppStrings.female,
    AppStrings.male,
    AppStrings.other,
  ];

  final _authServices = AuthServices();

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  // ---------------- Reset for new user ----------------
  void reset() {
    fullNameController.clear();
    emailController.clear();
    dateOfBirthController.clear();
    genderController.clear();

    selectedGender.value = '';
    selectedDate.value = DateTime.now();
    isSubmitting.value = false;
  }

  // ---------------- Load User Data ----------------
  void _loadUserData() {
    final auth = Get.find<AuthController>();

    fullNameController.text = auth.userName.value;
    emailController.text = auth.userEmail.value;

    // DOB
    if (auth.userDob.isNotEmpty) {
      dateOfBirthController.text = auth.userDob.value;
    } else {
      dateOfBirthController.text = formatDate(selectedDate.value!);
    }

    // Gender
    if (auth.userGender.isNotEmpty) {
      selectedGender.value = auth.userGender.value;
      genderController.text = auth.userGender.value;
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

  // ---------------- Helpers ----------------
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  // ---------------- UI Actions ----------------
  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
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
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateOfBirthController.text = formatDate(picked);
    }
  }

  void selectGender() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: AppSizes.spacing12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(AppStrings.selectGender, style: AppTextStyles.titleText),
            const SizedBox(height: AppSizes.spacing20),
            ...genderOptions.map((gender) => ListTile(
              title: Text(gender),
              trailing: selectedGender.value == gender
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                selectedGender.value = gender;
                genderController.text = gender;
                Get.back();
              },
            )),
            const SizedBox(height: AppSizes.spacing20),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ---------------- Continue ----------------
  Future<void> continueToNext() async {
    if (isSubmitting.value) return;

    // Validate
    if (fullNameController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseEnterFullName,
          backgroundColor: Colors.red);
      return;
    }
    if (emailController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseEnterEmail,
          backgroundColor: Colors.red);
      return;
    }
    if (dateOfBirthController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseSelectDateOfBirth,
          backgroundColor: Colors.red);
      return;
    }
    if (genderController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseSelectGender,
          backgroundColor: Colors.red);
      return;
    }

    try {
      isSubmitting.value = true;
      final auth = Get.find<AuthController>();

      final apiGender = selectedGender.value.toLowerCase();
      final apiDob =
          "${selectedDate.value!.year.toString().padLeft(4, '0')}-"
          "${selectedDate.value!.month.toString().padLeft(2, '0')}-"
          "${selectedDate.value!.day.toString().padLeft(2, '0')}";

      final response = await _authServices.updateProfile(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        gender: apiGender,
        dateOfBirth: apiDob,
      );

      if (!response.success || response.data == null) {
        ShowSnackBar.show(
          AppStrings.error,
          response.message.isNotEmpty
              ? response.message
              : AppStrings.failedUpdateProfile,
          backgroundColor: Colors.red,
        );
        return;
      }

      // ---------------- Save user info locally for first-time login ----------------
      await auth.saveUserProfile(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        gender: selectedGender.value,
        dob: dateOfBirthController.text.trim(),
      );

      ShowSnackBar.show(
        AppStrings.success,
        AppStrings.informationSavedSuccessfully,
        backgroundColor: Colors.green,
      );

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      ShowSnackBar.show(AppStrings.error, e.toString(),
          backgroundColor: Colors.red);
    } finally {
      isSubmitting.value = false;
    }
  }
}

