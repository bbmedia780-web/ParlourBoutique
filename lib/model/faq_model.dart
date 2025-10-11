/// Frequently Asked Questions (FAQ) model
///
/// Represents a single FAQ item with question, answer, and expansion state
class FAQModel {
  final String question;
  final String answer;
  final bool isExpanded;

  FAQModel({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  /// Creates FAQModel from JSON
  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      isExpanded: json['isExpanded'] == true,
    );
  }

  /// Converts FAQModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'isExpanded': isExpanded,
    };
  }

  /// Creates a copy of FAQModel with updated fields
  FAQModel copyWith({
    String? question,
    String? answer,
    bool? isExpanded,
  }) {
    return FAQModel(
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  String toString() => 'FAQModel(question: $question, isExpanded: $isExpanded)';
}
