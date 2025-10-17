import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_text_style.dart';
import '../../services/auth_services.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../utility/global.dart';
import '../../utility/validation_helper.dart';
import '../../utility/form_focus_helper.dart';
import '../../utility/date_helper.dart';
import '../../view/bottomsheet/gender_bottom_sheet.dart';
import '../home_controller/home_controller.dart';
import 'auth_controller.dart';

class InformationController extends GetxController {
  // ---------------- Controllers ----------------
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();
  
  // ---------------- Focus Nodes ----------------
  final fullNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final dateOfBirthFocusNode = FocusNode();
  final genderFocusNode = FocusNode();

  // ---------------- State ----------------
  final RxString selectedGender = "".obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxBool isSubmitting = false.obs;
  
  // ---------------- Validation States ----------------
  final RxString fullNameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString dateOfBirthError = ''.obs;
  final RxString genderError = ''.obs;
  final RxBool isFormValid = false.obs;

  final List<String> genderOptions = [
    AppStrings.female,
    AppStrings.male,
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
    selectedDate.value = null;
    isSubmitting.value = false;
    
    // Reset validation states
    fullNameError.value = '';
    emailError.value = '';
    dateOfBirthError.value = '';
    genderError.value = '';
    isFormValid.value = false;
  }

  // ---------------- Load User Data ----------------
  void _loadUserData() {
    final auth = Get.find<AuthController>();

    fullNameController.text = auth.userName.value;
    emailController.text = auth.userEmail.value;

    // DOB
    if (auth.userDob.isNotEmpty) {
      dateOfBirthController.text = auth.userDob.value;
      // Parse the existing DOB if available
      try {
        final parts = auth.userDob.value.split('-');
        if (parts.length == 3) {
          selectedDate.value = DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      } catch (e) {
        // If parsing fails, keep selectedDate as null
        selectedDate.value = null;
      }
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
    
    // Dispose focus nodes
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    dateOfBirthFocusNode.dispose();
    genderFocusNode.dispose();
    
    super.onClose();
  }

  // ---------------- Validation Methods ----------------
  /// Validates full name field
  void validateFullName() {
    final error = ValidationHelper.validateName(fullNameController.text);
    fullNameError.value = error ?? '';
    updateFormValidity();
  }
  
  /// Validates email field
  void validateEmail() {
    final error = ValidationHelper.validateEmail(emailController.text);
    emailError.value = error ?? '';
    updateFormValidity();
  }
  
  /// Validates date of birth field
  void validateDateOfBirth() {
    final error = ValidationHelper.validateDate(dateOfBirthController.text);
    dateOfBirthError.value = error ?? '';
    updateFormValidity();
  }
  
  /// Validates gender selection
  void validateGender() {
    final error = ValidationHelper.validateDropdown(selectedGender.value, 'gender');
    genderError.value = error ?? '';
    updateFormValidity();
  }
  
  /// Updates form validity based on all field validations
  void updateFormValidity() {
    isFormValid.value = fullNameError.value.isEmpty &&
        emailError.value.isEmpty &&
        dateOfBirthError.value.isEmpty &&
        genderError.value.isEmpty;
  }
  
  /// Validates all form fields
  bool validateForm() {
    validateFullName();
    validateEmail();
    validateDateOfBirth();
    validateGender();
    return isFormValid.value;
  }
  
  /// Gets all focus nodes for form fields
  List<FocusNode> getFocusNodes() {
    return [
      fullNameFocusNode,
      emailFocusNode,
      dateOfBirthFocusNode,
      genderFocusNode,
    ];
  }
  
  /// Gets all validation errors
  List<String?> getValidationErrors() {
    return [
      fullNameError.value.isNotEmpty ? fullNameError.value : null,
      emailError.value.isNotEmpty ? emailError.value : null,
      dateOfBirthError.value.isNotEmpty ? dateOfBirthError.value : null,
      genderError.value.isNotEmpty ? genderError.value : null,
    ];
  }

  // ---------------- Helpers ----------------
  
  /// Formats date to DD-MM-YYYY format
  String formatDate(DateTime date) {
    return DateHelper.formatDate(date);
  }

  // ---------------- Age Validation ----------------
  
  /// Calculates age from birth date
  int calculateAge(DateTime birthDate) {
    return DateHelper.calculateAge(birthDate);
  }

  /// Validates if age meets minimum requirement (12 years)
  bool isAgeValid(DateTime birthDate) {
    return DateHelper.isAgeValid(birthDate);
  }

  // ---------------- UI Actions ----------------
  Future<void> selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = DateHelper.getSmartInitialDate(selectedDate.value);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
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
      
      // Validate date after selection
      validateDateOfBirth();
      
      // Validate age after date selection
      if (!isAgeValid(picked)) {
        // Only show error toast, success toast removed per requirement
        ShowToast.error(AppStrings.ageValidationError);
      }
    }
  }

  /// Shows gender selection bottom sheet
  void selectGender() {
    Get.bottomSheet(
      GenderBottomSheet(
        selectedGender: selectedGender,
        genderOptions: genderOptions,
        onGenderSelected: (String gender) {
          genderController.text = gender;
          validateGender(); // Validate after selection
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ---------------- Continue ----------------
  Future<void> continueToNext(BuildContext context, ScrollController scrollController) async {
    if (isSubmitting.value) return;

    // Validate all form fields
    if (!validateForm()) {
      // Scroll to first invalid field
      FormFocusHelper.scrollToFirstInvalidField(
        context: context,
        scrollController: scrollController,
        focusNodes: getFocusNodes(),
        validationErrors: getValidationErrors(),
      );
      
      // Show first error message
      final firstError = ValidationHelper.getFirstError(getValidationErrors());
      
      if (firstError != null && firstError.isNotEmpty) {
        ShowToast.error(firstError);
      }
      return;
    }
    
    // Additional age validation
    if (selectedDate.value != null && !isAgeValid(selectedDate.value!)) {
      ShowToast.error(AppStrings.ageValidationError);
      return;
    }

    try {
      isSubmitting.value = true;
      final auth = Get.find<AuthController>();

      final apiGender = selectedGender.value.toLowerCase();
      final apiDob = DateHelper.formatDateForApi(selectedDate.value!);

      final response = await _authServices.updateProfile(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        gender: apiGender,
        dateOfBirth: apiDob,
      );

      if (!response.success || response.data == null) {
        ShowToast.error(response.message.isNotEmpty
            ? response.message
            : AppStrings.failedUpdateProfile);
        return;
      }

      // ---------------- Save user info locally for first-time login ----------------
      await auth.saveUserProfile(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        gender: selectedGender.value,
        dob: dateOfBirthController.text.trim(),
      );

      // Toast message removed - Success toasts are disabled per requirement

      // Reset home state before navigating to home after profile completion
      if (Get.isRegistered<HomeController>()) {
        try {
          final homeController = Get.find<HomeController>();
          homeController.resetHomeState();
        } catch (e) {
          print('HomeController not found: $e');
        }
      }

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      ShowToast.error(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}


