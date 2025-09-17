class ApiConfig {
  // Base URLs
  static const String devBaseUrl = 'https://apiv3.keyurkasvala.com/Users/Auth/';
  static const String liveBaseUrl = 'https://apiv3.keyurkasvala.com/Users/Auth/';

  // Environment toggle
  static const bool useLive = true;

  // Active Base URL
  static String get baseUrl {
    return useLive ? liveBaseUrl : devBaseUrl;
  }
  // API Endpoints
  static const String sendOtp = 'RequestOtp.php';
  static const String verifyOtp = 'VerifyOtp.php';
  static const String resendOtp = 'ResendOtp.php';
  static const String completeProfile = 'CompleteProfile.php';
  static const String logout = 'Logout.php';
  static const String checkTokenStatus = 'CheckTokenStatus.php';
  static const String refreshToken = 'RefreshToken.php';
  static const String getReels = '/reels';
  static const String trendingReels = '/reels/trending';
  static const String searchReels = '/reels/search';
  static const String getReelById = '/reels'; // Append /{id} when calling

  static final String toggleLike = "$baseUrl/reels/like";       // POST, data: {reelId, like}
  static final String toggleFollow = "$baseUrl/reels/follow";
}
