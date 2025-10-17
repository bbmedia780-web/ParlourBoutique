import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common_text_form_field.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../../controller/home_controller/notification_controller.dart';
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
          icon: Icon(
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
    return Obx(() => CommonTextField(
      controller: controller.searchController,
      hintText: AppStrings.searchHere,
      keyboardType: TextInputType.text,
      cursorColor: AppColors.grey,
      onChanged: controller.onSearchChanged,
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
      suffixIcon: controller.searchQuery.value.isNotEmpty
          ? IconButton(
              icon: Icon(
                Icons.clear,
                color: AppColors.mediumGrey,
                size: AppSizes.spacing20,
              ),
              onPressed: controller.clearSearch,
            )
          : null,
    )).paddingSymmetric(horizontal: AppSizes.spacing18);
  }

  Widget _buildNotificationList() {
    return Obx(() {
      if (controller.filteredNotifications.isEmpty && controller.searchQuery.value.isNotEmpty) {
        // Show no results message when search has no matches
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: AppSizes.spacing48,
                color: AppColors.mediumGrey,
              ),
              const SizedBox(height: AppSizes.spacing16),
              Text(
                'No notifications found',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: AppSizes.spacing8),
              Text(
                'Try searching with different keywords',
                style: AppTextStyles.hintText,
              ),
            ],
          ),
        );
      }
      
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing18),
        itemCount: controller.filteredNotifications.length,
        separatorBuilder: (context, index) =>
        const Divider(height: AppSizes.borderWidth1, color: AppColors.extraLightGrey),
        itemBuilder: (context, index) {
          final notification = controller.filteredNotifications[index];
          return NotificationTile(
            notification: notification,
            onTap: () => controller.onNotificationTap(notification),
          );
        },
      );
    });
  }
}

