class AuthOtpResponse {
  final bool success;
  final String message;
  final AuthOtpData? data;

  AuthOtpResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthOtpResponse.fromJson(Map<String, dynamic> json) {
    return AuthOtpResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: json['data'] != null ? AuthOtpData.fromJson(json['data']) : null,
    );
  }
}

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

  factory AuthOtpData.fromJson(Map<String, dynamic> json) {
    return AuthOtpData(
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      mobile: (json['mobile'] ?? '').toString(),
      otpSent: json['otp_sent'] == true,
      otp: (json['otp'] ?? '').toString(),
    );
  }
}


