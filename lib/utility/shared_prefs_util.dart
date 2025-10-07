import 'package:shared_preferences/shared_preferences.dart';

/// Central utility to manage SharedPreferences keys and common operations
class SharedPrefsUtil {
  // Keys mirrored from AuthController
  static const String keyMobileNumber = 'mobile_number';
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyTokenType = 'token_type';
  static const String keyExpiresIn = 'expires_in';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUserGender = 'user_gender';
  static const String keyUserDob = 'user_dob';
  static const String keyUserImage = 'user_image';
  static const String keyProfileCompleted = 'profile_completed';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyLoginTime = 'login_time';

  /// Clears all session-related keys from SharedPreferences
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    print('[SharedPrefsUtil] 🔄 Clearing session keys from SharedPreferences...');
    await Future.wait([
      prefs.remove(keyMobileNumber),
      prefs.remove(keyAccessToken),
      prefs.remove(keyRefreshToken),
      prefs.remove(keyTokenType),
      prefs.remove(keyExpiresIn),
      prefs.remove(keyUserId),
      prefs.remove(keyUserName),
      prefs.remove(keyUserEmail),
      prefs.remove(keyUserGender),
      prefs.remove(keyUserDob),
      prefs.remove(keyUserImage),
      prefs.remove(keyProfileCompleted),
      prefs.remove(keyIsLoggedIn),
      prefs.remove(keyLoginTime),
    ]);
    print('[SharedPrefsUtil] ✅ Session cleared.');
  }
}


