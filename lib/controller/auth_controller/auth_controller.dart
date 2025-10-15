/*
import 'package:get/get.dart';
import 'package:parlour_app/controller/sign_in_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_services.dart';
import '../utility/shared_prefs_util.dart';
import '../routes/app_routes.dart';
import '../model/auth/auth_verify_response.dart';
import '../services/auth_services.dart';
import '../utility/global.dart';
import '../constants/app_strings.dart';
import '../constants/app_colors.dart';

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

  /// Update tokens only
  Future<bool> updateTokens({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(_keyAccessToken, accessToken),
        prefs.setString(_keyRefreshToken, refreshToken),
        prefs.setString(_keyTokenType, tokenType),
        prefs.setInt(_keyExpiresIn, expiresIn),
      ]);
      this.accessToken.value = accessToken;
      this.refreshToken.value = refreshToken;
      this.tokenType.value = tokenType;
      this.expiresIn.value = expiresIn;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Try to refresh tokens
  Future<bool> tryRefreshTokens() async {
    try {
      if (refreshToken.value.isEmpty) return false;
      final service = AuthServices();
      final refreshed = await service.refreshTokens();
      if (refreshed != null && refreshed.success && refreshed.data != null) {
        final data = refreshed.data!;
        final updated = await updateTokens(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
          tokenType: data.tokenType,
          expiresIn: data.expiresIn,
        );
        return updated;
      }
      return false;
    } catch (_) {
      return false;
    }
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
      print('[AuthController] 🚪 Logout initiated');
      // Call Logout API and ignore failures per guide
      final apiResult = await AuthServices().logout();
      print('[AuthController] 📡 Logout API called → success=$apiResult');

      // Clear persisted session
      await SharedPrefsUtil.clearSession();

      // Reset in-memory observables
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

      // Also clear SignIn phone controller if registered
      if (Get.isRegistered<SignInController>()) {
        try {
          final signIn = Get.find<SignInController>();
          signIn.phoneController.text = '';
          print('[AuthController] 🧹 Cleared phone controller');
        } catch (_) {}
      }

      // Navigate to Welcome screen so next launch starts fresh
      print('[AuthController] 🧭 Navigating to Welcome screen');
      Get.offAllNamed(AppRoutes.welcome);
      ShowToast.success(AppStrings.logoutSuccess);
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
      ShowToast.warning(reason);
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
*/

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_services.dart';
import '../../utility/shared_prefs_util.dart';
import '../../routes/app_routes.dart';
import '../../model/auth/auth_verify_response.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../utility/global.dart';
import '../../controller/guest_mode_controller.dart';
import '../home_controller/main_navigation_controller.dart';
import 'sign_in_controller.dart';

class AuthController extends GetxController {
  // ------------------ 🔑 Keys ------------------
  static const _kMobile = 'mobile_number';
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kType = 'token_type';
  static const _kExpiry = 'expires_in';
  static const _kUserId = 'user_id';
  static const _kName = 'user_name';
  static const _kEmail = 'user_email';
  static const _kGender = 'user_gender';
  static const _kDob = 'user_dob';
  static const _kImage = 'user_image';
  static const _kProfileDone = 'profile_completed';
  static const _kLoggedIn = 'is_logged_in';
  static const _kLoginTime = 'login_time';

  // ------------------ 📌 State ------------------
  final isLoggedIn = false.obs;
  final isLoading = false.obs;

  final mobile = ''.obs;
  final accessToken = ''.obs;
  final refreshToken = ''.obs;
  final tokenType = 'Bearer'.obs;
  final expiresIn = 0.obs;

  final userId = ''.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userGender = ''.obs;
  final userDob = ''.obs;
  final userImage = ''.obs;
  final profileCompleted = false.obs;

  // ------------------ 🚀 Lifecycle ------------------
  @override
  void onInit() {
    super.onInit();
    _loadFromPrefs();
  }

  // ------------------ 🆕 First Time User ------------------
  /// Check if this is the first time user is opening the app
  Future<bool> isFirstTimeUser() async {
    return await SharedPrefsUtil.isFirstTimeUser();
  }

  // ------------------ 📥 Load ------------------
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool(_kLoggedIn) ?? false;
    if (!isLoggedIn.value) return;

    mobile.value = prefs.getString(_kMobile) ?? '';
    accessToken.value = prefs.getString(_kAccess) ?? '';
    refreshToken.value = prefs.getString(_kRefresh) ?? '';
    tokenType.value = prefs.getString(_kType) ?? 'Bearer';
    expiresIn.value = prefs.getInt(_kExpiry) ?? 0;
    userId.value = prefs.getString(_kUserId) ?? '';
    userName.value = prefs.getString(_kName) ?? '';
    userEmail.value = prefs.getString(_kEmail) ?? '';
    userGender.value = prefs.getString(_kGender) ?? '';
    userDob.value = prefs.getString(_kDob) ?? '';
    userImage.value = prefs.getString(_kImage) ?? '';
    profileCompleted.value = prefs.getBool(_kProfileDone) ?? false;
  }

  // ------------------ 💾 Save ------------------
  Future<void> _saveToPrefs({
    required String mobile,
    required String access,
    required String refresh,
    String tokenType = 'Bearer',
    int expiry = 0,
    String uid = '',
    String name = '',
    String email = '',
    String gender = '',
    String dob = '',
    String image = '',
    bool profileDone = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(_kLoggedIn, true),
      prefs.setInt(_kLoginTime, DateTime.now().millisecondsSinceEpoch),
      prefs.setString(_kMobile, mobile),
      prefs.setString(_kAccess, access),
      prefs.setString(_kRefresh, refresh),
      prefs.setString(_kType, tokenType),
      prefs.setInt(_kExpiry, expiry),
      prefs.setString(_kUserId, uid),
      prefs.setString(_kName, name),
      prefs.setString(_kEmail, email),
      prefs.setString(_kGender, gender),
      prefs.setString(_kDob, dob),
      prefs.setString(_kImage, image),
      prefs.setBool(_kProfileDone, profileDone),
    ]);

    // update live values
    isLoggedIn.value = true;
    this.mobile.value = mobile;
    accessToken.value = access;
    refreshToken.value = refresh;
    this.tokenType.value = tokenType;
    expiresIn.value = expiry;
    userId.value = uid;
    userName.value = name;
    userEmail.value = email;
    userGender.value = gender;
    userDob.value = dob;
    userImage.value = image;
    profileCompleted.value = profileDone;
  }

  // ------------------ 🔐 Auth Flow ------------------
  Future<bool> login(UserData data) async {
    try {
      await _saveToPrefs(
        mobile: data.mobile,
        access: data.accessToken,
        refresh: data.refreshToken,
        tokenType: data.tokenType,
        expiry: data.expiresIn,
        uid: data.userId.toString(),
        name: data.userDetails?.fullName ?? '',
        email: data.userDetails?.email ?? '',
        gender: data.userDetails?.gender ?? '',
        dob: data.userDetails?.dateOfBirth ?? '',
        profileDone: data.profileCompleted,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ------------------ 📝 Save Profile (first-time or update) ------------------
  Future<void> saveUserProfile({
    required String name,
    required String email,
    required String gender,
    required String dob,
    String image = '',
  }) async {
    userName.value = name;
    userEmail.value = email;
    userGender.value = gender;
    userDob.value = dob;
    userImage.value = image;
    profileCompleted.value = true;

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_kName, name),
      prefs.setString(_kEmail, email),
      prefs.setString(_kGender, gender),
      prefs.setString(_kDob, dob),
      prefs.setString(_kImage, image),
      prefs.setBool(_kProfileDone, true),
    ]);
  }

  Future<bool> refreshTokens() async {
    if (refreshToken.value.isEmpty) return false;
    final res = await AuthServices().refreshTokens();
    if (res != null && res.success && res.data != null) {
      final d = res.data!;
      await _saveToPrefs(
        mobile: mobile.value,
        access: d.accessToken,
        refresh: d.refreshToken,
        tokenType: d.tokenType,
        expiry: d.expiresIn,
        uid: userId.value,
        name: userName.value,
        email: userEmail.value,
        gender: userGender.value,
        dob: userDob.value,
        image: userImage.value,
        profileDone: profileCompleted.value,
      );
      return true;
    }
    return false;
  }

  // ------------------ 🚪 Logout ------------------
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await AuthServices().logout(); // API call, ignore failures
      await SharedPrefsUtil.clearSession();

      // reset state
      isLoggedIn.value = false;
      mobile.value = '';
      accessToken.value = '';
      refreshToken.value = '';
      tokenType.value = 'Bearer';
      expiresIn.value = 0;
      userId.value = '';
      userName.value = '';
      userEmail.value = '';
      userGender.value = '';
      userDob.value = '';
      userImage.value = '';
      profileCompleted.value = false;

      // Enter guest mode
      if (Get.isRegistered<GuestModeController>()) {
        Get.find<GuestModeController>().enterGuestMode();
      }

      if (Get.isRegistered<SignInController>()) {
        Get.find<SignInController>().phoneController.clear();
      }

      // Navigate to home as guest instead of welcome screen
      Get.offAllNamed(AppRoutes.home);
      
      // Reset navigation to home tab (index 0) after logout
      Future.delayed(const Duration(milliseconds: 100), () {
        if (Get.isRegistered<MainNavigationController>()) {
          Get.find<MainNavigationController>().resetToHome();
        }
      });
      
      ShowToast.success(AppStrings.logoutSuccess);
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ 🛠 Helpers ------------------
  bool hasValidToken() => accessToken.value.isNotEmpty;

  Map<String, String> getAuthHeaders() => {
    'Authorization': '$tokenType ${accessToken.value}',
    'Content-Type': 'application/json',
  };
}
