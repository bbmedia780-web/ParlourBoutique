import 'package:get/get.dart';
import '../../model/language_model.dart';
import '../../utility/localization_service.dart';


class LanguageController extends GetxController {
  final RxList<LanguageModel> languages = <LanguageModel>[].obs;
  final RxString selectedLanguageId = 'en'.obs;
  late LocalizationService localizationService;

  @override
  void onInit() {
    super.onInit();
    localizationService = Get.find<LocalizationService>();
    _loadLanguages();
  }

  void _loadLanguages() {
    final currentLanguageCode = localizationService.currentLanguageCode;

    // Ensure radio group reflects current app language
    selectedLanguageId.value = currentLanguageCode;
    
    languages.value = [
      LanguageModel(
        id: 'en',
        name: 'English',
        nativeName: 'English',
        isSelected: currentLanguageCode == 'en',
      ),
      LanguageModel(
        id: 'gu',
        name: 'Gujarati',
        nativeName: 'ગુજરાતી',
        isSelected: currentLanguageCode == 'gu',
      ),
      LanguageModel(
        id: 'hi',
        name: 'Hindi',
        nativeName: 'हिन्दी',
        isSelected: currentLanguageCode == 'hi',
      ),
      LanguageModel(
        id: 'mr',
        name: 'Marathi',
        nativeName: 'મરાઠી',
        isSelected: currentLanguageCode == 'mr',
      ),
      LanguageModel(
        id: 'pa',
        name: 'Punjabi',
        nativeName: 'ਪੰਜਾਬੀ',
        isSelected: currentLanguageCode == 'pa',
      ),
      LanguageModel(
        id: 'ur',
        name: 'Urdu',
        nativeName: 'اردو',
        isSelected: currentLanguageCode == 'ur',
      ),
    ];
  }

  void selectLanguage(String languageId) {
    // Update all languages to unselected
    for (int i = 0; i < languages.length; i++) {
      languages[i] = languages[i].copyWith(isSelected: false);
    }

    // Find and select the chosen language
    final index = languages.indexWhere((lang) => lang.id == languageId);
    if (index != -1) {
      languages[index] = languages[index].copyWith(isSelected: true);
      selectedLanguageId.value = languageId;
    }
  }

  void saveLanguage() async {
    try {
      // Get the selected language locale
      final selectedLanguage = languages.firstWhere((lang) => lang.isSelected);
      final locale = localizationService.getLocaleByLanguageCode(selectedLanguage.id);
      
      // Change the app language
      await localizationService.changeLanguage(locale);

      // Ensure controller state matches saved locale
      selectedLanguageId.value = selectedLanguage.id;
      
      Get.snackbar(
        'language_changed'.tr,
        'language_updated'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      // Navigate back
      Get.back();
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  LanguageModel? getSelectedLanguage() {
    try {
      return languages.firstWhere((lang) => lang.isSelected);
    } catch (e) {
      return null;
    }
  }
}
