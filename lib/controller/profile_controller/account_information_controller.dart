import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../utility/global.dart';
import '../../utility/date_helper.dart';
import '../../view/bottomsheet/photo_picker_bottom_sheet.dart';
import '../auth_controller/auth_controller.dart';
import '../home_controller/main_navigation_controller.dart';

/// Account Information Controller
/// 
/// Manages user profile information editing including:
/// - Name, email, date of birth
/// - Profile photo selection (camera/gallery)
/// - Data validation and persistence
/// - Age validation (minimum 12 years)
class AccountInformationController extends GetxController {
  // ---------------- Controllers ----------------
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  // ---------------- State ----------------
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxBool isSubmitting = false.obs;
  final RxString selectedImagePath = ''.obs;

  // ---------------- Dependencies ----------------
  final ImagePicker _picker = ImagePicker();

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    _bindUserData();
    _loadUserProfile();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  /// Disposes all text editing controllers
  void _disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
  }

  // ---------------- Data Loading ----------------
  
  /// Binds user data from AuthController to text fields
  /// 
  /// Sets up reactive listeners that update text fields when
  /// AuthController data changes
  void _bindUserData() {
    final auth = Get.find<AuthController>();

    // Bind text fields to AuthController reactive variables
    ever(auth.userName, (_) => fullNameController.text = auth.userName.value);
    ever(auth.userEmail, (_) => emailController.text = auth.userEmail.value);
    ever(auth.userDob, (_) => _updateDateOfBirth(auth.userDob.value));

    // Initial data load
    _loadInitialData(auth);
  }

  /// Loads initial data from AuthController
  void _loadInitialData(AuthController auth) {
    fullNameController.text = auth.userName.value;
    emailController.text = auth.userEmail.value;
    _updateDateOfBirth(auth.userDob.value);
  }

  /// Updates date of birth field and selectedDate state
  void _updateDateOfBirth(String dobString) {
    if (dobString.isEmpty) {
      dateOfBirthController.clear();
      selectedDate.value = null;
      return;
    }

    dateOfBirthController.text = dobString;
    final parsedDate = DateHelper.parseDateFromText(dobString);
    if (parsedDate != null) {
      selectedDate.value = parsedDate;
    }
  }

  /// Loads user profile from SharedPreferences via AuthController
  Future<void> _loadUserProfile() async {
    final auth = Get.find<AuthController>();

    if (auth.userName.value.isNotEmpty) {
      fullNameController.text = auth.userName.value;
    }
    if (auth.userEmail.value.isNotEmpty) {
      emailController.text = auth.userEmail.value;
    }
    if (auth.userDob.value.isNotEmpty) {
      _updateDateOfBirth(auth.userDob.value);
    }
    if (auth.userImage.value.isNotEmpty) {
      selectedImagePath.value = auth.userImage.value;
    }
  }

  // ---------------- Image Picker ----------------
  
  /// Shows photo picker bottom sheet with gallery and camera options
  void changePhoto() {
    Get.bottomSheet(
      PhotoPickerBottomSheet(
        onGalleryTap: pickImageFromGallery,
        onCameraTap: pickImageFromCamera,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Picks image from device gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      ShowToast.error(AppStrings.failedToPickImage);
    }
  }

  /// Captures image from device camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      ShowToast.error(AppStrings.failedToPickImage);
    }
  }

  // ---------------- Date Selection ----------------
  
  /// Shows date picker and validates age
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
      _handleDateSelection(picked);
    }
  }

  /// Handles date selection and validation
  void _handleDateSelection(DateTime picked) {
    selectedDate.value = picked;
    dateOfBirthController.text = DateHelper.formatDate(picked);

    // Validate age immediately after date selection
    if (!DateHelper.isAgeValid(picked)) {
      // Only show error toast, success toast removed per requirement
      ShowToast.error(AppStrings.ageValidationError);
    }
  }

  // ---------------- Save Information ----------------
  
  /// Validates and saves user profile information
  Future<void> saveInformation() async {
    if (!_validateAllInputs()) return;

    try {
      isSubmitting.value = true;
      await _saveUserProfile();
      _handleSuccessfulSave();
    } catch (e) {
      _handleSaveError(e);
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Saves user profile using AuthController
  Future<void> _saveUserProfile() async {
    final auth = Get.find<AuthController>();

    await auth.saveUserProfile(
      name: fullNameController.text.trim(),
      email: emailController.text.trim(),
      dob: dateOfBirthController.text.trim(),
      gender: auth.userGender.value,
      image: selectedImagePath.value,
    );
  }

  /// Handles successful profile save
  void _handleSuccessfulSave() {
    // Toast message removed - Success toasts are disabled per requirement
    FocusManager.instance.primaryFocus?.unfocus();
    _navigateToProfile();
  }

  /// Handles profile save error
  void _handleSaveError(dynamic error) {
    ShowToast.error(AppStrings.failedToSaveInformation);
  }

  /// Navigates back to profile tab
  void _navigateToProfile() {
    try {
      final mainNavController = Get.find<MainNavigationController>();
      mainNavController.selectedBottomBarIndex.value = 4;
      Get.until((route) => route.settings.name == AppRoutes.home);
    } catch (e) {
      // MainNavigationController not found, just go back
      Get.back();
    }
  }

  // ---------------- Validation ----------------
  

  /// Returns true if all validations pass, false otherwise
  bool _validateAllInputs() {
    if (!_validateFullName()) return false;
    if (!_validateEmail()) return false;
    if (!_validateDateOfBirth()) return false;
    if (!_validateAge()) return false;
    return true;
  }

  /// Validates full name field
  bool _validateFullName() {
    if (fullNameController.text.trim().isEmpty) {
      ShowToast.error(AppStrings.pleaseEnterFullName);
      return false;
    }
    return true;
  }

  /// Validates email field
  bool _validateEmail() {
    if (emailController.text.trim().isEmpty) {
      ShowToast.error(AppStrings.pleaseEnterEmail);
      return false;
    }
    return true;
  }

  /// Validates date of birth field
  bool _validateDateOfBirth() {
    if (dateOfBirthController.text.trim().isEmpty) {
      ShowToast.error(AppStrings.pleaseSelectDateOfBirth);
      return false;
    }
    return true;
  }

  /// Validates age requirement (minimum 12 years)
  bool _validateAge() {
    DateTime? birthDate = selectedDate.value;

    // Try to parse from text field if selectedDate is null
    if (birthDate == null && dateOfBirthController.text.isNotEmpty) {
      birthDate = DateHelper.parseDateFromText(dateOfBirthController.text);
    }

    if (birthDate != null && !DateHelper.isAgeValid(birthDate)) {
      ShowToast.error(AppStrings.ageValidationError);
      return false;
    }

    return true;
  }
}


