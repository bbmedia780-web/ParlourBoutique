/// Notification model for displaying user notifications
///
/// Contains notification details including business info, offers, and read status
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

  /// Creates NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      businessName: json['businessName']?.toString() ?? '',
      businessImage: json['businessImage']?.toString() ?? '',
      dateTime: json['dateTime']?.toString() ?? '',
      offerDescription: json['offerDescription']?.toString() ?? '',
      callToAction: json['callToAction']?.toString() ?? '',
      isRead: json['isRead'] == true,
    );
  }

  /// Converts NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessName': businessName,
      'businessImage': businessImage,
      'dateTime': dateTime,
      'offerDescription': offerDescription,
      'callToAction': callToAction,
      'isRead': isRead,
    };
  }

  /// Creates a copy of NotificationModel with updated fields
  NotificationModel copyWith({
    String? id,
    String? businessName,
    String? businessImage,
    String? dateTime,
    String? offerDescription,
    String? callToAction,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      businessImage: businessImage ?? this.businessImage,
      dateTime: dateTime ?? this.dateTime,
      offerDescription: offerDescription ?? this.offerDescription,
      callToAction: callToAction ?? this.callToAction,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() => 'NotificationModel(id: $id, businessName: $businessName, isRead: $isRead)';
}
