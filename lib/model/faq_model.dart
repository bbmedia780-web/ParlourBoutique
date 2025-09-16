class FAQModel {
  final String question;
  final String answer;
  final bool isExpanded;

  FAQModel({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

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
}
