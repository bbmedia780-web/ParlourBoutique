import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends GetxService {
  static const String _languageKey = 'selected_language';
  static const String _countryCodeKey = 'selected_country_code';
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('gu', 'IN'), // Gujarati
    Locale('hi', 'IN'), // Hindi
    Locale('mr', 'IN'), // Marathi
    Locale('pa', 'IN'), // Punjabi
    Locale('ur', 'PK'), // Urdu
  ];

  // Default locale
  static const Locale defaultLocale = Locale('en', 'US');

  // Observable current locale
  final Rx<Locale> currentLocale = defaultLocale.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  // Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'en';
      final countryCode = prefs.getString(_countryCodeKey) ?? 'US';
      
      final locale = Locale(languageCode, countryCode);
      if (supportedLocales.contains(locale)) {
        currentLocale.value = locale;
        _updateAppLocale(locale);
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  // Save language to SharedPreferences
  Future<void> _saveLanguage(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
      await prefs.setString(_countryCodeKey, locale.countryCode ?? '');
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  // Change app language
  Future<void> changeLanguage(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      currentLocale.value = locale;
      await _saveLanguage(locale);
      _updateAppLocale(locale);
    }
  }

  // Update app locale using GetX
  void _updateAppLocale(Locale locale) {
    Get.updateLocale(locale);
  }

  // Get current language code
  String get currentLanguageCode => currentLocale.value.languageCode;

  // Check if a language is currently selected
  bool isLanguageSelected(String languageCode) {
    return currentLocale.value.languageCode == languageCode;
  }

  // Get locale by language code
  Locale getLocaleByLanguageCode(String languageCode) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => defaultLocale,
    );
  }
}
