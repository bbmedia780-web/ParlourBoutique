class NotificationModel {
  final String id;
  final String businessName;
  final String businessImage;
  final String dateTime;
  final String offerDescription;
  final String callToAction;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.businessName,
    required this.businessImage,
    required this.dateTime,
    required this.offerDescription,
    required this.callToAction,
    this.isRead = false,
  });
}
