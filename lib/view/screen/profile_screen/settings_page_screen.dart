import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/app_enums.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/profile_controller/settings_controller.dart';
import '../../../model/settings_model.dart';
import '../../../utility/global.dart';


class SettingsPageView extends StatelessWidget {
  SettingsPageView({super.key});

  final SettingsController controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
          size: AppSizes.spacing20,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
          'setting'.tr,
          style: AppTextStyles.appBarText
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
      child: Obx(() => _buildSettingsList()),
    );
  }

  Widget _buildSettingsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
      itemCount: controller.settings.length,
      separatorBuilder: (context, index) => _buildDivider(),
      itemBuilder: (context, index) {
        final setting = controller.settings[index];
        return _buildSettingItem(setting);
      },
    );
  }

  Widget _buildSettingItem(SettingsModel setting) {
    return InkWell(
      onTap: setting.type == SettingsType.navigation
          ? () => controller.onSettingTapped(setting)
          : null,
      borderRadius: BorderRadius.circular(AppSizes.spacing12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacing2,
          horizontal: AppSizes.spacing4,
        ),
        child: Row(
          children: [
            // Icon Container
            _buildIconContainer(setting),

            const SizedBox(width: AppSizes.spacing16),

            // Content
            Expanded(
              child: Text(
                  _getTranslatedTitle(setting.id),
                  style: AppTextStyles.profilePageText
              ),
            ),

            // Control
            _buildControl(setting),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(SettingsModel setting) {
    return Container(
      width: AppSizes.spacing48,
      height: AppSizes.spacing48,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(setting.icon),
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
      ),
      child: Center(
        child: _buildIcon(setting.icon),
      ),
    );
  }

  Widget _buildIcon(String iconType) {
    switch (iconType) {
      case 'language':
        return Container(
          width: AppSizes.spacing24,
          height: AppSizes.spacing24,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSizes.spacing4),
          ),
          child: Center(
            child: Text(
              'Aa',
              style: AppTextStyles.whiteSmallText,
            ),
          ),
        );
      case 'notification':
        return const Icon(
          Icons.notifications,
          color: AppColors.kellyGreen,
          size: AppSizes.spacing24,
        );
      default:
        return const Icon(
          Icons.dark_mode,
          color: AppColors.mediumGrey,
          size: AppSizes.spacing24,
        );
    }
  }

  Color _getIconBackgroundColor(String iconType) {
    switch (iconType) {
      case 'language':
        return AppColors.primary.withValues(alpha: 0.1);
      case 'notification':
        return AppColors.kellyGreen.withValues(alpha: 0.1);
      default:
        return AppColors.lightGrey.withValues(alpha: 0.5);
    }
  }

  Widget _buildControl(SettingsModel setting) {
    switch (setting.type) {
      case SettingsType.toggle:
        return Transform.scale(
          scale: 0.8,
          child: Switch(
            value: setting.isEnabled,
            onChanged: (value) => _handleToggle(setting, value),
            activeColor: AppColors.primary,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.lightGrey,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      case SettingsType.navigation:
        // Removed language value rendering to hide 'English'
        return const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.mediumGrey,
          size: AppSizes.spacing16,
        );
      case SettingsType.info:
        // Info type: Display value if available, otherwise show nothing
        if (setting.value != null && setting.value!.isNotEmpty) {
          return Text(
            setting.value!,
            style: AppTextStyles.hintText,
          );
        }
        return const SizedBox.shrink();
    }
  }

  void _handleToggle(SettingsModel setting, bool value) {
    switch (setting.id) {
      case 'notification':
        controller.toggleNotification(value);
        break;
    }
  }

  Widget _buildDivider() {
    return AppGlobal.commonDivider(
      color: AppColors.lightGrey,
    );
  }

  String _getTranslatedTitle(String settingId) {
    switch (settingId) {
      case 'language':
        return 'language'.tr;
      case 'notification':
        return 'notification'.tr;
      default:
        return settingId;
    }
  }
}