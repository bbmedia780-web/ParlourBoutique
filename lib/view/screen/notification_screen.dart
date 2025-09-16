import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common_text_form_field.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../../controller/notification_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_style.dart';
import '../../constants/app_sizes.dart';
import '../widget/notification_tile_widget.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: AppSizes.spacing20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
            AppStrings.notification,
            style: AppTextStyles.appBarText
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildNotificationList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return  CommonTextField(
      controller: controller.searchController,
      hintText: AppStrings.searchHere,
      keyboardType: TextInputType.text,
      cursorColor: AppColors.grey,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.search,
                width: AppSizes.spacing16,
                height: AppSizes.spacing16,
                fit: BoxFit.cover,
                scale: AppSizes.scaleSize,
                color: AppColors.mediumGrey,
              ),
            ],
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: AppSizes.spacing18);
  }

  Widget _buildNotificationList() {
    return Obx(() => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing18),
        itemCount: controller.notifications.length,
        separatorBuilder: (context, index) =>
        const Divider(height: 1, color: AppColors.extraLightGrey),
        itemBuilder: (context, index) {
          final notification = controller.notifications[index];
          return NotificationTile(
            notification: notification,
            onTap: () => controller.onNotificationTap(notification),
          );
        },
      ),
    );
  }
}

