/// Payment method model for managing payment options
///
/// Represents a payment method with type (card, UPI, etc.), masked details, and selection state
class PaymentMethodModel {
  final String id;
  final String type; // e.g., 'credit_card', 'debit_card', 'upi', 'wallet'
  final String name;
  final String maskedNumber; // e.g., '**** **** **** 1234'
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

  /// Creates PaymentMethodModel from JSON
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      maskedNumber: json['maskedNumber']?.toString() ?? '',
      logo: json['logo']?.toString(),
      isSelected: json['isSelected'] == true,
    );
  }

  /// Converts PaymentMethodModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'maskedNumber': maskedNumber,
      'logo': logo,
      'isSelected': isSelected,
    };
  }

  /// Creates a copy of PaymentMethodModel with updated fields
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

  @override
  String toString() => 'PaymentMethodModel(id: $id, type: $type, name: $name, isSelected: $isSelected)';
}


