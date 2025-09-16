import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../model/settings_model.dart';


class SettingsController extends GetxController {
  // Observable settings list
  final RxList<SettingsModel> settings = <SettingsModel>[].obs;
  
  // Current settings state
  final RxBool isNotificationEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    settings.value = [
      SettingsModel(
        id: 'language',
        title: AppStrings.language,
        icon: 'language',
        type: SettingsType.navigation,
      ),
      SettingsModel(
        id: 'notification',
        title: AppStrings.notification,
        icon: 'notification',
        type: SettingsType.toggle,
        isEnabled: isNotificationEnabled.value,
      ),
    ];
  }



  // Toggle notifications
  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    _updateSetting('notification', value);
    
    // Show feedback
    Get.snackbar(
      'Notifications',
      value ? 'Notifications enabled' : 'Notifications disabled',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    
    // Add your notification logic here
    // _updateNotificationSettings(value);
  }

  // Handle navigation items
  void onSettingTapped(SettingsModel setting) {
    switch (setting.id) {
      case 'language':
        onLanguageTapped();
        break;
    }
  }

  void onLanguageTapped() {
    // Navigate to language selection screen
    Get.toNamed(AppRoutes.languageSelection);
  }

  // Update setting in the list
  void _updateSetting(String id, bool value) {
    final index = settings.indexWhere((setting) => setting.id == id);
    if (index != -1) {
      final updatedSetting = SettingsModel(
        id: settings[index].id,
        title: settings[index].title,
        icon: settings[index].icon,
        type: settings[index].type,
        isEnabled: value,
        value: settings[index].value,
      );
      settings[index] = updatedSetting;
    }
  }

  // Get setting by ID
  SettingsModel? getSettingById(String id) {
    try {
      return settings.firstWhere((setting) => setting.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh settings
  void refreshSettings() {
    _loadSettings();
  }

  @override
  void onClose() {
    // Save settings to persistent storage if needed
    super.onClose();
  }
}
