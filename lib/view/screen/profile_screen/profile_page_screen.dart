import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_style.dart';
import '../../../constants/app_strings.dart';
import '../../../controller/profile_controller/profile_controller.dart';
import '../../../controller/auth_controller.dart';
import '../../../utility/global.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final AuthController authController = Get.find<AuthController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizes.spacing20,
            right: AppSizes.spacing20,
            bottom: MediaQuery.of(context).padding.bottom + AppSizes.size80,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.size50),
              _buildProfileHeader(),
              const SizedBox(height: AppSizes.spacing30),
              _buildMenuItems(),
              const SizedBox(height: AppSizes.spacing30),
              _buildPoweredByText(),
              const SizedBox(height: AppSizes.spacing40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Profile Image
        Container(
          width: AppSizes.size120,
          height: AppSizes.size120,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: Image.asset(AppAssets.user, fit: BoxFit.cover),
          ),
        ),

        const SizedBox(height: AppSizes.spacing8),
        // User Name - Display actual user data
        Obx(() => Text(
          authController.userName.value.isNotEmpty ? authController.userName.value : 'Guest',
          style: AppTextStyles.tickerText
        )),

        const SizedBox(height: AppSizes.spacing2),

        // User Mobile Number - Display actual user data
        Obx(() => Text(
          authController.userEmail.value.isNotEmpty
            ? authController.userEmail.value
            : 'Not logged in',
          style: AppTextStyles.hintText
        )),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          image: AppAssets.accountProfile,
          title: AppStrings.accountInformation,
          onTap: () => controller.onMenuItemTapped(AppStrings.menuItemAccount),
        ),


        _buildMenuItem(
          image: AppAssets.favourite,
          title: AppStrings.favourite,
          onTap: () => controller.onMenuItemTapped(AppStrings.menuItemFavourite),
        ),

        _buildMenuItem(
          image: AppAssets.booking,
          title:  AppStrings.booking,
          onTap: () => controller.onMenuItemTapped(AppStrings.menuItemBooking),
        ),

        _buildMenuItem(
          image: AppAssets.payment,
          title:  AppStrings.paymentHistory,
          onTap: () => controller.onMenuItemTapped(AppStrings.menuItemPaymentHistory),
        ),

        _buildMenuItem(
          image: AppAssets.settings,
          title:  AppStrings.setting,
          onTap: () => controller.onMenuItemTapped(AppStrings.menuItemSettings),
        ),
        _buildMenuItem(
          image: AppAssets.helpSupport,
          title: AppStrings.helpSupport,
          onTap: () => controller.onMenuItemTapped(AppStrings.menuItemHelpSupport),
        ),
        _buildMenuItem(
          image: AppAssets.faq,
          title:  AppStrings.faqs,
          onTap: () => controller.onMenuItemTapped(AppStrings.menuItemFaqs),
        ),

        // Divider before logout
        AppGlobal.commonDivider(color: AppColors.lightGrey.withOpacity(0.4)),

        const SizedBox(height: AppSizes.spacing12),

        // Logout item without arrow
        _buildMenuItem(
          image: AppAssets.logout,
          title: AppStrings.logout,
          isLogout: true,
          showArrow: false,
          // new parameter
          onTap: () => controller.onMenuItemTapped(AppStrings.menuItemLogout),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String image,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
    bool showArrow = true, // default true
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: Row(
          children: [
            Image.asset(image, height: AppSizes.spacing36),
            const SizedBox(width: AppSizes.spacing20),
            Expanded(
              child: Text(
                title,
                style: isLogout
                    ? AppTextStyles.redText
                    : AppTextStyles.profilePageText,
              ),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                color: isLogout ? AppColors.red : AppColors.mediumGrey,
                size: AppSizes.spacing16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoweredByText() {
    return Text(
      AppStrings.brightBrewText,
      style: AppTextStyles.hintText,
      textAlign: TextAlign.center,
    );
  }
}
