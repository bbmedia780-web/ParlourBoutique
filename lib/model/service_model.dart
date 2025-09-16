class ServiceModel {
  final String title;
  final String icon;
  final String type; // 'parlour' or 'boutique'
  final bool isSelected;

  ServiceModel({
    required this.title,
    required this.icon,
    required this.type,
    this.isSelected = false,
  });

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
}
