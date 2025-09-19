import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../utility/global.dart';
import '../auth_controller.dart';


class AccountInformationController extends GetxController {
  // -------------------- TextEditingControllers --------------------
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  // -------------------- Rx Variables --------------------
  final RxString selectedGender = ''.obs;
  final Rx<DateTime?> selectedDate = DateTime.now().obs;
  final RxBool isSubmitting = false.obs;
  final RxString selectedImagePath = ''.obs; // Profile image path

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // -------------------- Lifecycle --------------------
  @override
  void onInit() {
    super.onInit();
    _bindUserData();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }

  // -------------------- User Data Binding --------------------
  void _bindUserData() {
    final auth = Get.find<AuthController>();

    // Bind text fields to AuthController Rx variables
    ever(auth.userName, (_) => fullNameController.text = auth.userName.value);
    ever(auth.userEmail, (_) => emailController.text = auth.userEmail.value);
    ever(auth.userDob, (_) {
      dateOfBirthController.text =
      auth.userDob.isNotEmpty ? auth.userDob.value : formatDate(DateTime.now());
    });
    ever(auth.userGender, (_) => selectedGender.value = auth.userGender.value);

    // Initial load (in case values are already available)
    fullNameController.text = auth.userName.value;
    emailController.text = auth.userEmail.value;
    dateOfBirthController.text =
    auth.userDob.isNotEmpty ? auth.userDob.value : formatDate(DateTime.now());
    selectedGender.value = auth.userGender.value;
  }

  // -------------------- Image Picker Methods --------------------
  void changePhoto() {
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

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImagePath.value = image.path;
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) selectedImagePath.value = image.path;
  }


  // -------------------- Save Info --------------------
  void saveInformation() {
    ShowSnackBar.show(
      AppStrings.success,
      AppStrings.informationUpToDate,
      backgroundColor: AppColors.green,
    );
  }

  // -------------------- Helper --------------------
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}

