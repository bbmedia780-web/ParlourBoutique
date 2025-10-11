/// Support ticket form model for creating support tickets
///
/// Represents form data for submitting a new support ticket
class SupportTicketFormModel {
  final String category;
  final String subject;
  final String description;

  SupportTicketFormModel({
    required this.category,
    required this.subject,
    required this.description,
  });

  /// Creates SupportTicketFormModel from JSON
  factory SupportTicketFormModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketFormModel(
      category: json['category']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  /// Converts SupportTicketFormModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'subject': subject,
      'description': description,
    };
  }

  /// Creates a copy of SupportTicketFormModel with updated fields
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

  @override
  String toString() => 'SupportTicketFormModel(category: $category, subject: $subject)';
}

