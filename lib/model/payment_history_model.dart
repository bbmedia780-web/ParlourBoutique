class PaymentHistoryModel {
  final String id;
  final String businessName;
  final String businessImage;
  final String date;
  final double amount;
  final bool isCredit; // true for green (credit), false for red (debit)
  final String groupDate; // for grouping transactions

  PaymentHistoryModel({
    required this.id,
    required this.businessName,
    required this.businessImage,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.groupDate,
  });
}
