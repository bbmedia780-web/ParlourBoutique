import 'package:get/get.dart';
import '../../common/app_enums.dart';
import '../../utility/global.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../model/settings_model.dart';

/*class SettingsController extends GetxController {
  // ---------------- State ----------------
  /// List of settings displayed in the UI
  final RxList<SettingsModel> settings = <SettingsModel>[].obs;

  /// Notification toggle state
  final RxBool isNotificationEnabled = true.obs;
  
  /// Dark mode toggle state
  final RxBool isDarkModeEnabled = false.obs;

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  // ---------------- Load Settings ----------------
  /// Initializes settings list with default values
  void _loadSettings() {
    // Dark mode removed; default to disabled
    isDarkModeEnabled.value = false;
    
    settings.value = [
      SettingsModel(
        id: 'dark_mode',
        title: AppStrings.darkMode,
        icon: 'dark_mode',
        type: SettingsType.toggle,
        isEnabled: isDarkModeEnabled.value,
      ),
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

  // ---------------- Actions ----------------
  /// Toggle dark mode setting
  void toggleDarkMode(bool value) {
    isDarkModeEnabled.value = value;
    _updateSetting('dark_mode', value);

    // ThemeController removed; no-op for theme change

    // Show feedback
    ShowToast.info(value ? AppStrings.darkModeEnabled : AppStrings.lightModeEnabled);
  }

  /// Toggle notification setting
  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    _updateSetting('notification', value);

    // Show feedback
    ShowToast.info(value ? AppStrings.notificationEnable : AppStrings.notificationDisabled);

    // TODO: Add notification service logic here
    // _updateNotificationSettings(value);
  }

  /// Handles navigation settings like Language
  void onSettingTapped(SettingsModel setting) {
    switch (setting.id) {
      case 'language':
        _onLanguageTapped();
        break;
    }
  }

  /// Navigate to language selection screen
  void _onLanguageTapped() {
    Get.toNamed(AppRoutes.languageSelection);
  }

  // ---------------- Helpers ----------------
  /// Update specific setting in the list
  void _updateSetting(String id, bool value) {
    final index = settings.indexWhere((s) => s.id == id);
    if (index != -1) {
      settings[index] = settings[index].copyWith(isEnabled: value);
    }
  }

  /// Get a setting by ID
  SettingsModel? getSettingById(String id) {
    try {
      return settings.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Reload settings (e.g., after changes)
  void refreshSettings() {
    _loadSettings();
  }

  @override
  void onClose() {
    // TODO: Save settings to persistent storage if required
    super.onClose();
  }
}*/

class SettingsController extends GetxController {
  // ---------------- State ----------------
  /// List of settings displayed in the UI
  final RxList<SettingsModel> settings = <SettingsModel>[].obs;

  /// Notification toggle state
  final RxBool isNotificationEnabled = true.obs;

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  // ---------------- Load Settings ----------------
  /// Initializes settings list with default values
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

  // ---------------- Actions ----------------
  /// Toggle notification setting
  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    _updateSetting('notification', value);

    // Show feedback
    ShowToast.info(value ? AppStrings.notificationEnable : AppStrings.notificationDisabled);

  }

  /// Handles navigation settings like Language
  void onSettingTapped(SettingsModel setting) {
    if (setting.id == 'language') {
      Get.toNamed(AppRoutes.languageSelection);
    }
  }

  // ---------------- Helpers ----------------
  /// Update specific setting in the list
  void _updateSetting(String id, bool value) {
    final index = settings.indexWhere((s) => s.id == id);
    if (index != -1) {
      settings[index] = settings[index].copyWith(isEnabled: value);
    }
  }

}

