class DateHelper {
  // Minimum age requirement for the app
  static const int minimumAge = 12;
  
  // Default age for date picker initial date
  static const int defaultAge = 18;


  /// Example: DateTime(2000, 1, 15) -> "15-01-2000"
  static String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }


  /// Example: DateTime(2000, 1, 15) -> "2000-01-15"
  static String formatDateForApi(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  /// Parses date from text field format (DD-MM-YYYY)
  /// Example: "15-01-2000" -> DateTime(2000, 1, 15)
  static DateTime? parseDateFromText(String dateText) {
    try {
      final parts = dateText.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // If parsing fails, return null
    }
    return null;
  }

  /// Calculates age from date of birth
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    // Check if birthday hasn't occurred this year
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }


  /// Returns true if age is >= minimumAge (default 12)
  static bool isAgeValid(DateTime birthDate, {int minAge = minimumAge}) {
    return calculateAge(birthDate) >= minAge;
  }


  /// Returns a date that is [age] years ago from today
  static DateTime getDefaultInitialDate({int age = defaultAge}) {
    return DateTime.now().subtract(Duration(days: 365 * age));
  }


  /// If selectedDate is valid and in the past, returns it
  /// Otherwise returns default initial date
  static DateTime getSmartInitialDate(DateTime? selectedDate, {int defaultAgeYears = defaultAge}) {
    final now = DateTime.now();
    if (selectedDate != null && selectedDate.isBefore(now)) {
      return selectedDate;
    }
    return getDefaultInitialDate(age: defaultAgeYears);
  }
}

