/// Response model for OTP verification API
///
/// Contains the authentication result after OTP verification
class AuthVerifyResponse {
  final bool success;
  final String message;
  final UserData? data;

  AuthVerifyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Creates AuthVerifyResponse from JSON
  factory AuthVerifyResponse.fromJson(Map<String, dynamic> json) {
    return AuthVerifyResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  /// Converts AuthVerifyResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() => 'AuthVerifyResponse(success: $success, message: $message)';
}

/// User data model containing authentication tokens and user info
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

  /// Creates UserData from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      mobile: json['mobile']?.toString() ?? '',
      accessToken: json['access_token']?.toString() ?? (json['token']?.toString() ?? ''),
      refreshToken: json['refresh_token']?.toString() ?? '',
      expiresIn: int.tryParse(json['expires_in']?.toString() ?? '0') ?? 0,
      tokenType: json['token_type']?.toString() ?? 'Bearer',
      verified: json['verified'] == true,
      profileCompleted: json['profile_completed'] == true,
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : null,
    );
  }

  /// Converts UserData to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'mobile': mobile,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'token_type': tokenType,
      'verified': verified,
      'profile_completed': profileCompleted,
      'user_details': userDetails?.toJson(),
    };
  }

  @override
  String toString() => 'UserData(userId: $userId, mobile: $mobile, verified: $verified)';
}

/// User details model containing profile information
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

  /// Creates UserDetails from JSON
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString() ?? '',
    );
  }

  /// Converts UserDetails to JSON
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    };
  }

  /// Creates a copy of UserDetails with updated fields
  UserDetails copyWith({
    String? fullName,
    String? email,
    String? gender,
    String? dateOfBirth,
  }) {
    return UserDetails(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  String toString() => 'UserDetails(fullName: $fullName, email: $email)';
}
