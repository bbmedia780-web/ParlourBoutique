import 'package:flutter/material.dart';

// ==================== String Extensions ====================

extension StringExtension on String {
  /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Checks if string is a valid mobile number (10 digits)
  bool get isValidMobile {
    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    return mobileRegex.hasMatch(this);
  }

  /// Returns true if string is null or empty
  bool get isNullOrEmpty => trim().isEmpty;

  /// Returns true if string is not null and not empty
  bool get isNotNullOrEmpty => trim().isNotEmpty;
}

// ==================== Number Extensions ====================

extension IntExtension on int {
  /// Converts price to formatted string with rupee symbol
  String get toRupees => '₹$this';

  /// Formats number with commas (e.g., 1000 -> 1,000)
  String get withCommas {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

extension DoubleExtension on double {
  /// Converts price to formatted string with rupee symbol
  String get toRupees => '₹${toStringAsFixed(2)}';

  /// Formats rating to 1 decimal place
  String get formatRating => toStringAsFixed(1);
}

// ==================== Widget Extensions ====================

extension WidgetExtension on Widget {
  /// Adds padding to a widget
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  /// Adds symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  /// Adds custom padding
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Centers the widget
  Widget get center => Center(child: this);

  /// Makes widget expand in Flex layouts
  Widget get expanded => Expanded(child: this);

  /// Wraps widget in a Flexible
  Widget flexible({int flex = 1}) {
    return Flexible(flex: flex, child: this);
  }

  /// Adds visibility control
  Widget visible(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: this,
    );
  }

  /// Adds GestureDetector with onTap
  Widget onTap(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}

// ==================== Context Extensions ====================

extension ContextExtension on BuildContext {
  /// Returns MediaQuery size
  Size get screenSize => MediaQuery.of(this).size;

  /// Returns screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Returns screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Returns theme data
  ThemeData get theme => Theme.of(this);

  /// Returns text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Removes focus from text fields
  void unfocus() => FocusScope.of(this).unfocus();

  /// Shows snackbar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }
}

// ==================== DateTime Extensions ====================

extension DateTimeExtension on DateTime {
  /// Formats date as "dd MMM, yyyy" (e.g., "15 Jan, 2024")
  String get formatDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '$day ${months[month - 1]}, $year';
  }

  /// Formats time as "hh:mm AM/PM" (e.g., "02:30 PM")
  String get formatTime {
    final hour = this.hour > 12 ? this.hour - 12 : this.hour;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}

// ==================== List Extensions ====================

extension ListExtension<T> on List<T> {
  /// Returns true if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Returns true if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Safely gets element at index, returns null if out of bounds
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}

