import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';
import 'package:parlour_app/translations/app_translations.dart';
import 'package:parlour_app/utility/localization_service.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'binding/app_binding.dart';
import 'view/widget/network_wrapper.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ==================== MEMORY OPTIMIZATION ====================
  // Configure image cache to prevent OOM errors
  PaintingBinding.instance.imageCache.maximumSize = 100; // Limit number of images in cache
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB cache limit

  // Configure status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

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
        builder: (context, child) => NetworkWrapper(
          child: ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 450, name: MOBILE),
              Breakpoint(start: 451, end: 800, name: TABLET),
              Breakpoint(start: 801, end: 1200, name: DESKTOP),
              Breakpoint(start: 1201, end: double.infinity, name: '4K'),
            ],
          ),
        ),
      );
  }

  // Removed explicit theming to disable light/dark modes
}
