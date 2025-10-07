import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parlour_app/utility/global.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../auth_controller/auth_controller.dart';
import '../home_controller/main_navigation_controller.dart';


class AccountInformationController extends GetxController {
  // -------------------- TextEditingControllers --------------------
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  // -------------------- Rx Variables --------------------
  final Rx<DateTime?> selectedDate = DateTime.now().obs;
  final RxBool isSubmitting = false.obs;
  final RxString selectedImagePath = ''.obs; // Profile image path

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // -------------------- Lifecycle --------------------
  @override
  void onInit() {
    super.onInit();
    bindUserData();
    loadFromPrefs(); // load saved data from shared preferences
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }

  // -------------------- User Data Binding --------------------
  void bindUserData() {
    final auth = Get.find<AuthController>();

    // Bind text fields to AuthController Rx variables
    ever(auth.userName, (_) => fullNameController.text = auth.userName.value);
    ever(auth.userEmail, (_) => emailController.text = auth.userEmail.value);
    ever(auth.userDob, (_) {dateOfBirthController.text = auth.userDob.isNotEmpty ? auth.userDob.value : '';});

    // Initial load (in case values are already available)
    fullNameController.text = auth.userName.value;
    emailController.text = auth.userEmail.value;
    dateOfBirthController.text = auth.userDob.isNotEmpty ? auth.userDob.value : '';
  }

  // -------------------- Image Picker Methods --------------------
  void changePhoto() {
    Get.bottomSheet(
      Container(
        decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.spacing20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: AppSizes.spacing12, bottom: AppSizes.spacing20),
              width: AppSizes.spacing40,
              height: AppSizes.spacing4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(AppSizes.spacing2),
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
            const SizedBox(height: AppSizes.spacing20),
          ],
        ),
      ),
    );
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImagePath.value = image.path;
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) selectedImagePath.value = image.path;
  }

  // -------------------- Date Picker --------------------
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
      dateOfBirthController.text = "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
    }
  }

  // -------------------- Save Info --------------------
  Future<void> saveInformation() async {
    if (!_validateInputs()) return;

    isSubmitting.value = true;

    try {
      final auth = Get.find<AuthController>();
      final mainNavController = Get.find<MainNavigationController>();

      // 🔄 Save using AuthController method
      await auth.saveUserProfile(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        dob: dateOfBirthController.text.trim(),
        gender: auth.userGender.value,
        image: selectedImagePath.value,
      );

      isSubmitting.value = false;

      // ✅ Show success message
      ShowSnackBar.show(
        AppStrings.success,
        "Information saved successfully",
        backgroundColor: AppColors.green,
      );

      // Close keyboard if open
      FocusManager.instance.primaryFocus?.unfocus();

      // ✅ Switch to profile tab
      mainNavController.selectedBottomBarIndex.value = 4;

      // ✅ Pop back to MainNavigationScreen
      Get.until((route) => route.settings.name == AppRoutes.home);
    } catch (e) {
      isSubmitting.value = false;
      ShowSnackBar.show(
        AppStrings.error,
        "Failed to save information",
        backgroundColor: AppColors.red,
      );
    }
  }

  /// ✅ Input validation helper
  bool _validateInputs() {
    if (fullNameController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseEnterFullName,
          backgroundColor: AppColors.red);
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseEnterEmail,
          backgroundColor: AppColors.red);
      return false;
    }
    if (dateOfBirthController.text.trim().isEmpty) {
      ShowSnackBar.show(AppStrings.error, AppStrings.pleaseSelectDateOfBirth,
          backgroundColor: AppColors.red);
      return false;
    }
    return true;
  }


  // -------------------- Load Info from SharedPreferences --------------------
  Future<void> loadFromPrefs() async {
    final auth = Get.find<AuthController>();
    
    // Load from AuthController (which loads from SharedPreferences on init)
    if (auth.userName.value.isNotEmpty) {
      fullNameController.text = auth.userName.value;
    }
    if (auth.userEmail.value.isNotEmpty) {
      emailController.text = auth.userEmail.value;
    }
    if (auth.userDob.value.isNotEmpty) {
      dateOfBirthController.text = auth.userDob.value;
    }
    if (auth.userImage.value.isNotEmpty) {
      selectedImagePath.value = auth.userImage.value;
    }
  }

}

