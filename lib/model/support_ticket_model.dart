/// Support ticket model for managing user support requests
///
/// Represents a support ticket with issue details, status, and selection state
class SupportTicketModel {
  final String id;
  final String ticketNumber;
  final String issue;
  final String date;
  final String status; // e.g., 'Open', 'In Progress', 'Resolved', 'Closed'
  final bool isSelected;

  SupportTicketModel({
    required this.id,
    required this.ticketNumber,
    required this.issue,
    required this.date,
    required this.status,
    this.isSelected = false,
  });

  /// Creates SupportTicketModel from JSON
  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id']?.toString() ?? '',
      ticketNumber: json['ticketNumber']?.toString() ?? '',
      issue: json['issue']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Open',
      isSelected: json['isSelected'] == true,
    );
  }

  /// Converts SupportTicketModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'issue': issue,
      'date': date,
      'status': status,
      'isSelected': isSelected,
    };
  }

  /// Creates a copy of SupportTicketModel with updated fields
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

  @override
  String toString() => 'SupportTicketModel(ticketNumber: $ticketNumber, status: $status)';
}
