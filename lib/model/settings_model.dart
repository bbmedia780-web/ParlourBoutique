import '../common/app_enums.dart';

/// Settings model for managing app settings
///
/// Represents a setting option with type, enabled state, and optional value
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

  /// Creates SettingsModel from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      type: _parseSettingsType(json['type']),
      isEnabled: json['isEnabled'] == true,
      value: json['value']?.toString(),
    );
  }

  /// Helper method to parse SettingsType from string
  static SettingsType _parseSettingsType(dynamic value) {
    if (value == null) return SettingsType.toggle;
    final typeStr = value.toString().toLowerCase();
    switch (typeStr) {
      case 'toggle':
        return SettingsType.toggle;
      case 'navigation':
        return SettingsType.navigation;
      case 'info':
        return SettingsType.info;
      default:
        return SettingsType.toggle;
    }
  }

  /// Converts SettingsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'type': type.toString().split('.').last,
      'isEnabled': isEnabled,
      'value': value,
    };
  }

  /// Creates a copy of the model with updated values
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

  @override
  String toString() => 'SettingsModel(id: $id, title: $title, type: $type, isEnabled: $isEnabled)';
}


