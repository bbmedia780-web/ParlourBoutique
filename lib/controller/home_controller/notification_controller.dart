import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../../model/notification_model.dart';

class NotificationController extends GetxController {
  // -------------------- Text Controllers --------------------
  final TextEditingController searchController = TextEditingController();

  // -------------------- Reactive Variables --------------------
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> filteredNotifications = <NotificationModel>[].obs;
  final RxString searchQuery = ''.obs;

  // -------------------- Lifecycle --------------------
  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // -------------------- Data Loading --------------------
  /// Load sample notifications into the list
  void _loadNotifications() {
    notifications.value = [
      NotificationModel(
        id: '1',
        businessName: AppStrings.meeraBeauty,
        businessImage: AppAssets.beauty1,
        dateTime: AppStrings.notificationDateTime,
        offerDescription: AppStrings.offerDescription,
        callToAction: AppStrings.callToAction,
      ),
      NotificationModel(
        id: '2',
        businessName: AppStrings.roopnikhaar,
        businessImage: AppAssets.beauty2,
        dateTime: AppStrings.notificationDateTime,
        offerDescription: AppStrings.offerDescription,
        callToAction: AppStrings.callToAction,
      ),
      NotificationModel(
        id: '3',
        businessName: AppStrings.polishAndPoise,
        businessImage: AppAssets.parlour,
        dateTime: AppStrings.notificationDateTime,
        offerDescription: AppStrings.offerDescription,
        callToAction: AppStrings.callToAction,
      ),
      NotificationModel(
        id: '4',
        businessName: AppStrings.theBeautyLab,
        businessImage:AppAssets.beauty1,
        dateTime: AppStrings.notificationDateTime,
        offerDescription: AppStrings.offerDescription,
        callToAction: AppStrings.callToAction,
      ),
      NotificationModel(
        id: '5',
        businessName: AppStrings.theStyleStudio,
        businessImage: AppAssets.beauty2,
        dateTime: AppStrings.notificationDateTime,
        offerDescription: AppStrings.offerDescription,
        callToAction: AppStrings.callToAction,
      ),
      NotificationModel(
        id: '6',
        businessName: AppStrings.kanyaKaya,
        businessImage: AppAssets.parlour,
        dateTime: AppStrings.notificationDateTime,
        offerDescription: AppStrings.offerDescription,
        callToAction: AppStrings.callToAction,
      ),
    ];

    // Initially, all notifications are shown in filtered list
    filteredNotifications.value = notifications;
  }
  // -------------------- Search --------------------
  /// Filter notifications based on search query
  void onSearchChanged(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredNotifications.value = notifications;
    } else {
      filteredNotifications.value = notifications.where((notification) {
        final nameMatch = notification.businessName.toLowerCase().contains(query.toLowerCase());
        final offerMatch = notification.offerDescription.toLowerCase().contains(query.toLowerCase());
        return nameMatch || offerMatch;
      }).toList();
    }
  }

  // -------------------- Notification Actions --------------------
  /// Handle tap on a notification item
  void onNotificationTap(NotificationModel notification) {
    print('Notification tapped: ${notification.businessName}');
    // TODO: Add navigation or action logic here
  }

  /// Handle back button tap
  void onBackTap() {
    Get.back();
  }
}
