/// Response model for OTP send API
///
/// Contains the success status, message, and data related to OTP sending
class AuthOtpResponse {
  final bool success;
  final String message;
  final AuthOtpData? data;

  AuthOtpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Creates AuthOtpResponse from JSON
  factory AuthOtpResponse.fromJson(Map<String, dynamic> json) {
    return AuthOtpResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: json['data'] != null ? AuthOtpData.fromJson(json['data']) : null,
    );
  }

  /// Converts AuthOtpResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() => 'AuthOtpResponse(success: $success, message: $message)';
}

/// OTP data model containing user and OTP details
class AuthOtpData {
  final int userId;
  final String mobile;
  final bool otpSent;
  final String otp; // For testing only; server returns it in sample

  AuthOtpData({
    required this.userId,
    required this.mobile,
    required this.otpSent,
    required this.otp,
  });

  /// Creates AuthOtpData from JSON
  factory AuthOtpData.fromJson(Map<String, dynamic> json) {
    return AuthOtpData(
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      mobile: (json['mobile'] ?? '').toString(),
      otpSent: json['otp_sent'] == true,
      otp: (json['otp'] ?? '').toString(),
    );
  }

  /// Converts AuthOtpData to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'mobile': mobile,
      'otp_sent': otpSent,
      'otp': otp,
    };
  }

  @override
  String toString() => 'AuthOtpData(userId: $userId, mobile: $mobile, otpSent: $otpSent)';
}


