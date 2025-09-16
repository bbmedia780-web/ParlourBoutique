class AuthVerifyResponse {
  final bool success;
  final String message;
  final UserData? data;

  AuthVerifyResponse({required this.success, required this.message, this.data});

  factory AuthVerifyResponse.fromJson(Map<String, dynamic> json) {
    return AuthVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final int userId;
  final String mobile;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;
  final bool verified;
  final bool profileCompleted;
  final UserDetails? userDetails;

  UserData({
    required this.userId,
    required this.mobile,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    required this.verified,
    required this.profileCompleted,
    this.userDetails,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'] ?? 0,
      mobile: json['mobile'] ?? '',
      accessToken: json['access_token'] ?? (json['token'] ?? ''),
      refreshToken: json['refresh_token'] ?? '',
      expiresIn: json['expires_in'] is int
          ? json['expires_in']
          : int.tryParse('${json['expires_in'] ?? 0}') ?? 0,
      tokenType: json['token_type'] ?? 'Bearer',
      verified: json['verified'] ?? false,
      profileCompleted: json['profile_completed'] ?? false,
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : null,
    );
  }
}

class UserDetails {
  final String fullName;
  final String email;
  final String gender;
  final String dateOfBirth;

  UserDetails({
    required this.fullName,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
    );
  }
}
