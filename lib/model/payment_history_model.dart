/// Payment history model for displaying transaction records
///
/// Represents a payment transaction with business details, amount, and type
class PaymentHistoryModel {
  final String id;
  final String businessName;
  final String businessImage;
  final String date;
  final double amount;
  final bool isCredit; // true for credit/income (green), false for debit/expense (red)
  final String groupDate; // for grouping transactions by date

  PaymentHistoryModel({
    required this.id,
    required this.businessName,
    required this.businessImage,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.groupDate,
  });

  /// Creates PaymentHistoryModel from JSON
  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['id']?.toString() ?? '',
      businessName: json['businessName']?.toString() ?? '',
      businessImage: json['businessImage']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      amount: _parseDouble(json['amount']),
      isCredit: json['isCredit'] == true,
      groupDate: json['groupDate']?.toString() ?? '',
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Converts PaymentHistoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessName': businessName,
      'businessImage': businessImage,
      'date': date,
      'amount': amount,
      'isCredit': isCredit,
      'groupDate': groupDate,
    };
  }

  /// Creates a copy of PaymentHistoryModel with updated fields
  PaymentHistoryModel copyWith({
    String? id,
    String? businessName,
    String? businessImage,
    String? date,
    double? amount,
    bool? isCredit,
    String? groupDate,
  }) {
    return PaymentHistoryModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      businessImage: businessImage ?? this.businessImage,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      isCredit: isCredit ?? this.isCredit,
      groupDate: groupDate ?? this.groupDate,
    );
  }

  @override
  String toString() => 'PaymentHistoryModel(id: $id, amount: $amount, isCredit: $isCredit)';
}
