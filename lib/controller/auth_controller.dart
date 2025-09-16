import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_services.dart';
import '../utility/shared_prefs_util.dart';
import '../routes/app_routes.dart';
import '../model/auth/auth_verify_response.dart';

/// Controller to manage authentication state and user session
class AuthController extends GetxController {
  // Preference keys
  static const String _keyMobileNumber = 'mobile_number';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyTokenType = 'token_type';
  static const String _keyExpiresIn = 'expires_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserGender = 'user_gender';
  static const String _keyUserDob = 'user_dob';
  static const String _keyProfileCompleted = 'profile_completed';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyLoginTime = 'login_time';

  // Observable variables for authentication state
  final RxBool isLoggedIn = false.obs;
  final RxString mobileNumber = ''.obs;
  final RxString accessToken = ''.obs;
  final RxString refreshToken = ''.obs;
  final RxString tokenType = ''.obs;
  final RxInt expiresIn = 0.obs;
  final RxString userId = ''.obs;
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userGender = ''.obs;
  final RxString userDob = ''.obs;
  final RxBool profileCompleted = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  /// Expose a way for other parts of the app to refresh cached fields
  Future<void> refreshFromPrefs() async {
    await _loadUserData();
  }

  /// Save user login data to SharedPreferences directly
  Future<bool> saveLoginData({
    required String mobile,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    String? userId,
    String? name,
    String? email,
    String? gender,
    String? dob,
    bool? profileCompleted,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Future<bool>> writes = [
        prefs.setString(_keyMobileNumber, mobile),
        prefs.setBool(_keyIsLoggedIn, true),
        prefs.setInt(_keyLoginTime, DateTime.now().millisecondsSinceEpoch),
      ];
      if (accessToken != null) {
        writes.add(prefs.setString(_keyAccessToken, accessToken));
      }
      if (refreshToken != null) {
        writes.add(prefs.setString(_keyRefreshToken, refreshToken));
      }
      if (tokenType != null) {
        writes.add(prefs.setString(_keyTokenType, tokenType));
      }
      if (expiresIn != null) {
        writes.add(prefs.setInt(_keyExpiresIn, expiresIn));
      }
      if (userId != null) {
        writes.add(prefs.setString(_keyUserId, userId));
      }
      if (name != null) {
        writes.add(prefs.setString(_keyUserName, name));
      }
      if (email != null) {
        writes.add(prefs.setString(_keyUserEmail, email));
      }
      if (gender != null) {
        writes.add(prefs.setString(_keyUserGender, gender));
      }
      if (dob != null) {
        writes.add(prefs.setString(_keyUserDob, dob));
      }
      if (profileCompleted != null) {
        writes.add(prefs.setBool(_keyProfileCompleted, profileCompleted));
      }
      await Future.wait(writes);

      // Update observables
      isLoggedIn.value = true;
      mobileNumber.value = mobile;
      this.accessToken.value = accessToken ?? '';
      this.refreshToken.value = refreshToken ?? '';
      this.tokenType.value = tokenType ?? 'Bearer';
      this.expiresIn.value = expiresIn ?? 0;
      this.userId.value = userId ?? '';
      userName.value = name ?? '';
      userEmail.value = email ?? '';
      userGender.value = gender ?? '';
      userDob.value = dob ?? '';
      this.profileCompleted.value = profileCompleted ?? false;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Save full API response
  Future<bool> saveLoginDataFromApi(UserData data) async {
    return saveLoginData(
      mobile: data.mobile,
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
      tokenType: data.tokenType,
      expiresIn: data.expiresIn,
      userId: data.userId.toString(),
      name: data.userDetails?.fullName,
      email: data.userDetails?.email,
      gender: data.userDetails?.gender,
      dob: data.userDetails?.dateOfBirth,
      profileCompleted: data.profileCompleted,
    );
  }

  /// Load user data from SharedPreferences on app start
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      isLoggedIn.value = loggedIn;

      if (loggedIn) {
        mobileNumber.value = prefs.getString(_keyMobileNumber) ?? '';
        accessToken.value = prefs.getString(_keyAccessToken) ?? '';
        refreshToken.value = prefs.getString(_keyRefreshToken) ?? '';
        tokenType.value = prefs.getString(_keyTokenType) ?? 'Bearer';
        expiresIn.value = prefs.getInt(_keyExpiresIn) ?? 0;
        userId.value = prefs.getString(_keyUserId) ?? '';
        userName.value = prefs.getString(_keyUserName) ?? '';
        userEmail.value = prefs.getString(_keyUserEmail) ?? '';
        userGender.value = prefs.getString(_keyUserGender) ?? '';
        userDob.value = prefs.getString(_keyUserDob) ?? '';
        profileCompleted.value = prefs.getBool(_keyProfileCompleted) ?? false;
      }
    } catch (_) {
      isLoggedIn.value = false;
    }
  }

  /// Get auth token
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  /// Get user id
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  /// Check if user is logged in (optionally check session validity)
  Future<bool> isUserLoggedIn({Duration? sessionDuration}) async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!loggedIn) return false;

    if (sessionDuration != null) {
      final ts = prefs.getInt(_keyLoginTime);
      if (ts == null) return false;
      final loginTime = DateTime.fromMillisecondsSinceEpoch(ts);
      final now = DateTime.now();
      if (now.difference(loginTime) >= sessionDuration) return false;
    }
    return true;
  }

  /// Clear all user data on logout
  Future<void> logout() async {
    try {
      isLoading.value = true;
      // Call API (optional) and clear local session always
      await AuthServices().logout();
      await SharedPrefsUtil.clearSession();

      isLoggedIn.value = false;
      mobileNumber.value = '';
      accessToken.value = '';
      refreshToken.value = '';
      tokenType.value = '';
      expiresIn.value = 0;
      userId.value = '';
      userName.value = '';
      userEmail.value = '';
      userGender.value = '';
      userDob.value = '';
      profileCompleted.value = false;

      Get.offAllNamed(AppRoutes.signIn);
      Get.snackbar('Success', 'Logged out successfully');
    } finally {
      isLoading.value = false;
    }
  }

  /// Force logout without UI copy
  Future<void> forceLogout({String? reason}) async {
    await SharedPrefsUtil.clearSession();

    isLoggedIn.value = false;
    mobileNumber.value = '';
    accessToken.value = '';
    refreshToken.value = '';
    tokenType.value = '';
    expiresIn.value = 0;
    userId.value = '';
    userName.value = '';
    userEmail.value = '';
    userGender.value = '';
    userDob.value = '';
    profileCompleted.value = false;

    Get.offAllNamed(AppRoutes.signIn);
    if (reason != null) {
      Get.snackbar('Session Expired', reason);
    }
  }

  /// Check if we have a valid in-memory token
  bool hasValidToken() {
    return accessToken.value.isNotEmpty;
  }

  /// Get auth headers for API calls
  Map<String, String> getAuthHeaders() {
    return {
      'Authorization': '${tokenType.value.isNotEmpty ? tokenType.value : 'Bearer'} ${accessToken.value}',
      'Content-Type': 'application/json',
    };
  }
}
