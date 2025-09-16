import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';
import 'package:parlour_app/translations/app_translations.dart';
import 'package:parlour_app/utility/localization_service.dart';

import 'binding/app_binding.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize LocalizationService
  final localizationService = LocalizationService();
  Get.put(localizationService, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      initialBinding: AppBinding(),
      // Localization
      translations: AppTranslations(),
      locale: Get.find<LocalizationService>().currentLocale.value,
      fallbackLocale: LocalizationService.defaultLocale,
      supportedLocales: LocalizationService.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
