/// Service model representing a service type with icon
///
/// Used for categorizing services into parlour, boutique, or rent types
class ServiceModel {
  final String title;
  final String icon;
  final String type; // 'parlour', 'boutique', or 'rent'
  final bool isSelected;

  ServiceModel({
    required this.title,
    required this.icon,
    required this.type,
    this.isSelected = false,
  });

  /// Creates ServiceModel from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      title: json['title']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      type: json['type']?.toString() ?? 'parlour',
      isSelected: json['isSelected'] == true,
    );
  }

  /// Converts ServiceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'type': type,
      'isSelected': isSelected,
    };
  }

  /// Creates a copy of ServiceModel with updated fields
  ServiceModel copyWith({
    String? title,
    String? icon,
    String? type,
    bool? isSelected,
  }) {
    return ServiceModel(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() => 'ServiceModel(title: $title, type: $type, isSelected: $isSelected)';
}
