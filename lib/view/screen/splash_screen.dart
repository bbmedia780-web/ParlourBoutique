import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/constants/app_assets.dart';
import 'package:parlour_app/constants/app_sizes.dart';
import '../../../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(SplashController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
         AppAssets.logo,
          width: AppSizes.size300,
          height: AppSizes.size300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
