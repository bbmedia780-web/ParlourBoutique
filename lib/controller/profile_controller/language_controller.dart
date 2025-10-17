import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../model/language_model.dart';
import '../../utility/global.dart';
import '../../utility/localization_service.dart';

class LanguageController extends GetxController {
  // ---------------- State ----------------
  /// List of available languages
  final RxList<LanguageModel> languages = <LanguageModel>[].obs;

  /// Currently selected language ID
  final RxString selectedLanguageId = 'en'.obs;

  /// Localization service for changing app language
  late LocalizationService localizationService;

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    localizationService = Get.find<LocalizationService>();
    _loadLanguages();
  }

  // ---------------- Load Languages ----------------
  /// Initialize available languages and mark current app language as selected
  void _loadLanguages() {
    final currentLanguageCode = localizationService.currentLanguageCode;
    selectedLanguageId.value = currentLanguageCode;

    languages.value = [
      LanguageModel(id: 'en', name: 'English', nativeName: 'English', isSelected: currentLanguageCode == 'en'),
      LanguageModel(id: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', isSelected: currentLanguageCode == 'gu'),
      LanguageModel(id: 'hi', name: 'Hindi', nativeName: 'हिन्दी', isSelected: currentLanguageCode == 'hi'),
      LanguageModel(id: 'mr', name: 'Marathi', nativeName: 'मरााठी', isSelected: currentLanguageCode == 'mr'),
      LanguageModel(id: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', isSelected: currentLanguageCode == 'pa'),
      LanguageModel(id: 'ur', name: 'Urdu', nativeName: 'اردو', isSelected: currentLanguageCode == 'ur'),
    ];
  }

  // ---------------- Actions ----------------
  /// Select a language by its ID
  void selectLanguage(String languageId) {
    // Unselect all languages first
    for (int i = 0; i < languages.length; i++) {
      languages[i] = languages[i].copyWith(isSelected: false);
    }

    // Mark chosen language as selected
    final index = languages.indexWhere((lang) => lang.id == languageId);
    if (index != -1) {
      languages[index] = languages[index].copyWith(isSelected: true);
      selectedLanguageId.value = languageId;
    }
  }

  /// Save the selected language and update the app locale
  void saveLanguage() async {
    try {
      final selectedLanguage = languages.firstWhere((lang) => lang.isSelected);
      final locale = localizationService.getLocaleByLanguageCode(selectedLanguage.id);

      // Change app language
      await localizationService.changeLanguage(locale);

      // Update controller state
      selectedLanguageId.value = selectedLanguage.id;

      // Toast message removed - Success toasts are disabled per requirement

      Get.back(); // Navigate back
    } catch (e) {
      ShowToast.error(AppStrings.somethingWentWrong);
    }
  }

  /// Get the currently selected language model
  LanguageModel? getSelectedLanguage() {
    try {
      return languages.firstWhere((lang) => lang.isSelected);
    } catch (e) {
      return null;
    }
  }
}
