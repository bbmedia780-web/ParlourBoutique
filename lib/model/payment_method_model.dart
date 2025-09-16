class PaymentMethodModel {
  final String id;
  final String type;
  final String name;
  final String maskedNumber;
  final String? logo;
  final bool isSelected;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.name,
    required this.maskedNumber,
    this.logo,
    this.isSelected = false,
  });

  PaymentMethodModel copyWith({
    String? id,
    String? type,
    String? name,
    String? maskedNumber,
    String? logo,
    bool? isSelected,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      logo: logo ?? this.logo,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}


