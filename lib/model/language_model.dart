class LanguageModel {
  final String id;
  final String name;
  final String nativeName;
  final bool isSelected;

  LanguageModel({
    required this.id,
    required this.name,
    required this.nativeName,
    this.isSelected = false,
  });

  LanguageModel copyWith({
    String? id,
    String? name,
    String? nativeName,
    bool? isSelected,
  }) {
    return LanguageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
