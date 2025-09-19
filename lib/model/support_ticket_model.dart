class SupportTicketModel {
  final String id;
  final String ticketNumber;
  final String issue;
  final String date;
  final String status;
  final bool isSelected;

  SupportTicketModel({
    required this.id,
    required this.ticketNumber,
    required this.issue,
    required this.date,
    required this.status,
    this.isSelected = false,
  });

  SupportTicketModel copyWith({
    String? id,
    String? ticketNumber,
    String? issue,
    String? date,
    String? status,
    bool? isSelected,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      issue: issue ?? this.issue,
      date: date ?? this.date,
      status: status ?? this.status,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
