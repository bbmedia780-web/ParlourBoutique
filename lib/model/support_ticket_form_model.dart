class SupportTicketFormModel {
  final String category;
  final String subject;
  final String description;

  SupportTicketFormModel({
    required this.category,
    required this.subject,
    required this.description,
  });

  SupportTicketFormModel copyWith({
    String? category,
    String? subject,
    String? description,
  }) {
    return SupportTicketFormModel(
      category: category ?? this.category,
      subject: subject ?? this.subject,
      description: description ?? this.description,
    );
  }
}

