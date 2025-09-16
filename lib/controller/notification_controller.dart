import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  final searchController = TextEditingController();
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> filteredNotifications = <NotificationModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    // Sample notification data based on the screenshot
    notifications.value = [
      NotificationModel(
        id: '1',
        businessName: 'Meera Beauty',
        businessImage: 'assets/images/beauty1.png',
        dateTime: '26 Jun, 2025 | 10:00 am',
        offerDescription: 'Pamper yourself today — enjoy 20% off on facials and spa',
        callToAction: 'Walk in or book now',
      ),
      NotificationModel(
        id: '2',
        businessName: 'Roopnikhaar',
        businessImage: 'assets/images/beauty2.png',
        dateTime: '26 Jun, 2025 | 10:00 am',
        offerDescription: 'Pamper yourself today — enjoy 20% off on facials and spa',
        callToAction: 'Walk in or book now',
      ),
      NotificationModel(
        id: '3',
        businessName: 'Polish & Poise',
        businessImage: 'assets/images/parlour.png',
        dateTime: '26 Jun, 2025 | 10:00 am',
        offerDescription: 'Pamper yourself today — enjoy 20% off on facials and spa',
        callToAction: 'Walk in or book now',
      ),
      NotificationModel(
        id: '4',
        businessName: 'The Beauty Lab',
        businessImage: 'assets/images/beauty1.png',
        dateTime: '26 Jun, 2025 | 10:00 am',
        offerDescription: 'Pamper yourself today — enjoy 20% off on facials and spa',
        callToAction: 'Walk in or book now',
      ),
      NotificationModel(
        id: '5',
        businessName: 'The Style Studio',
        businessImage: 'assets/images/beauty2.png',
        dateTime: '26 Jun, 2025 | 10:00 am',
        offerDescription: 'Pamper yourself today — enjoy 20% off on facials and spa',
        callToAction: 'Walk in or book now',
      ),
      NotificationModel(
        id: '6',
        businessName: 'Kanya Kaya',
        businessImage: 'assets/images/parlour.png',
        dateTime: '26 Jun, 2025 | 10:00 am',
        offerDescription: 'Pamper yourself today — enjoy 20% off on facials and spa',
        callToAction: 'Walk in or book now',
      ),
    ];
    filteredNotifications.value = notifications;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredNotifications.value = notifications;
    } else {
      filteredNotifications.value = notifications
          .where((notification) =>
              notification.businessName.toLowerCase().contains(query.toLowerCase()) ||
              notification.offerDescription.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void onNotificationTap(NotificationModel notification) {
    // Handle notification tap - you can add navigation logic here
    print('Notification tapped: ${notification.businessName}');
  }

  void onBackTap() {
    Get.back();
  }
}
