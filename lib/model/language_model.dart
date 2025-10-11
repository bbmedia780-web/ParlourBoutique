/// Language model for multi-language support
///
/// Represents a language option with ID, English name, native name, and selection state
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

  /// Creates LanguageModel from JSON
  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nativeName: json['nativeName']?.toString() ?? '',
      isSelected: json['isSelected'] == true,
    );
  }

  /// Converts LanguageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nativeName': nativeName,
      'isSelected': isSelected,
    };
  }

  /// Creates a copy of LanguageModel with updated fields
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

  @override
  String toString() => 'LanguageModel(id: $id, name: $name, isSelected: $isSelected)';
}
