import '../common/app_enums.dart';

class SettingsModel {
  final String id;
  final String title;
  final String icon;
  final SettingsType type;
  final bool isEnabled;
  final String? value;

  SettingsModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.type,
    this.isEnabled = false,
    this.value,
  });

  // Create a copy of the model with updated values
  SettingsModel copyWith({
    String? id,
    String? title,
    String? icon,
    SettingsType? type,
    bool? isEnabled,
    String? value,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      value: value ?? this.value,
    );
  }
}


