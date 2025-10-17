import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../constants/app_assets.dart';
import '../../controller/network_controller.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ Single Image Instead of Illustration
                    Image.asset(
                      AppAssets.internet, // your image file here
                      width: AppSizes.size250,
                      height: AppSizes.size250,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: AppSizes.spacing40),

                    // Text Section
                    _buildTextContent(),
                  ],
                ),
              ),
            ),

            // Bottom Bar with Retry Button
            _buildBottomBar(networkController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        Text(
          AppStrings.noInternetConnection,
          style: AppTextStyles.appBarText.copyWith(
            color: Colors.grey.shade800,
            fontSize: AppSizes.heading,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spacing16),
        Text(
          AppStrings.noInternetMessage,
          style: AppTextStyles.hintText.copyWith(
            color: Colors.grey.shade600,
            fontSize: AppSizes.body,
            height: AppSizes.lineHeight1_4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBottomBar(NetworkController networkController) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.spacing20),
        child: AppButton(
          text: AppStrings.retry,
          onPressed: () => networkController.retryConnection(),
          isPrimary: true,
          width: double.infinity,
          height: AppSizes.size50,
          isLoading: networkController.isLoadingObs.value,
          textStyle: AppTextStyles.buttonText.copyWith(
            color: Colors.white,
            fontSize: AppSizes.body,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    });
  }
}
