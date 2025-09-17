import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_style.dart';
import '../routes/app_routes.dart';
import '../services/auth_services.dart';
import '../utility/global.dart';
import 'auth_controller.dart';

class InformationController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();

  final RxString selectedGender = "".obs;
  final Rx<DateTime?> selectedDate =  DateTime.now().obs;
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
    dateOfBirthController.text = formatDate(selectedDate.value!);
    genderController.text = selectedGender.value;
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
                  ? Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                selectedGender.value = gender;
                genderController.text = gender;  // Update displayed gender
                Get.back();
              },
            )),
            SizedBox(height: AppSizes.spacing20),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void continueToNext() async {
    if (isSubmitting.value) return; // prevent multiple taps
    // Validate form
    if (fullNameController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error,AppStrings.pleaseEnterFullName, backgroundColor: Colors.red);
      return;
    }
    
    if (emailController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error,AppStrings.pleaseEnterEmail, backgroundColor: Colors.red);
      return;
    }
    
    if (dateOfBirthController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error,AppStrings.pleaseSelectDateOfBirth, backgroundColor: Colors.red);
      return;
    }
    
    if (genderController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error,AppStrings.pleaseSelectGender, backgroundColor: Colors.red);
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
        ShowSnackBar.show(AppStrings.error, response.message.isNotEmpty ? response.message : AppStrings.failedUpdateProfile, backgroundColor: Colors.red);
        return;
      }

      // Save returned data (fallback to entered info if API lacks userDetails)
      final auth = Get.find<AuthController>();
      bool saved = false;
      if (response.data != null && response.data!.userDetails != null &&
          (response.data!.userDetails!.fullName.isNotEmpty || response.data!.userDetails!.email.isNotEmpty)) {
        saved = await auth.saveLoginDataFromApi(response.data!);
      } else {
        saved = await auth.saveLoginData(
          mobile: auth.mobileNumber.value,
          accessToken: response.data?.accessToken,
          refreshToken: response.data?.refreshToken,
          tokenType: response.data?.tokenType ?? 'Bearer',
          expiresIn: response.data?.expiresIn ?? 0,
          userId: response.data?.userId.toString(),
          name: fullNameController.text.trim(),
          email: emailController.text.trim(),
          gender: apiGender,
          dob: apiDob,
          profileCompleted: true,
        );
      }
      if (!saved) {
        ShowSnackBar.show(AppStrings.warning,AppStrings.failedSaveProfileData, backgroundColor: Colors.red);
      }
      await auth.refreshFromPrefs();
      ShowSnackBar.show(AppStrings.success,AppStrings.informationSavedSuccessfully, backgroundColor: Colors.green);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      ShowSnackBar.show(AppStrings.error, e.toString(), backgroundColor: Colors.red);
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