import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../api/base_api.dart';
import '../config/api_config.dart';
import '../controller/auth_controller/auth_controller.dart';
import '../model/auth/auth_otp_response.dart';
import '../model/auth/auth_verify_response.dart';
import '../utility/api_error_handler.dart';

/// AuthServices - Handles all authentication-related API calls
///
/// This service extends BaseApi to inherit Dio configuration and
/// provides methods for:
/// - Sending OTP
/// - Verifying OTP
/// - Resending OTP
/// - Updating user profile
/// - Logout
/// - Token refresh
class AuthServices extends BaseApi {
  // ==================== OTP Operations ====================

  /// Sends OTP to the specified mobile number
  ///
  /// Parameters:
  /// - [mobile]: The mobile number to send OTP to
  ///
  /// Returns:
  /// - [AuthOtpResponse] containing success status and message
  Future<AuthOtpResponse> sendOtp(String mobile) async {
    try {
      final response = await dio.post(
        ApiConfig.sendOtp,
        data: {'mobile': mobile},
        options: Options(contentType: Headers.jsonContentType),
      );

      return AuthOtpResponse.fromJson(response.data);
    } catch (error) {
      final message = ApiErrorHandler.handleError(error);
      return AuthOtpResponse(success: false, message: message, data: null);
    }
  }

  /// Verifies the OTP sent to the mobile number
  ///
  /// Parameters:
  /// - [mobile]: The mobile number
  /// - [otp]: The OTP code to verify
  ///
  /// Returns:
  /// - [AuthVerifyResponse] containing tokens and user data on success
  Future<AuthVerifyResponse> verifyOtp(String mobile, String otp) async {
    try {
      final response = await dio.post(
        ApiConfig.verifyOtp,
        data: {
          'mobile': mobile,
          'otp': otp,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      return AuthVerifyResponse.fromJson(response.data);
    } catch (error) {
      final message = ApiErrorHandler.handleError(error);
      return AuthVerifyResponse(success: false, message: message, data: null);
    }
  }

  /// Resends OTP to the specified mobile number
  ///
  /// Parameters:
  /// - [mobile]: The mobile number to resend OTP to
  ///
  /// Returns:
  /// - [AuthOtpResponse] containing success status and message
  Future<AuthOtpResponse> resendOtp(String mobile) async {
    try {
      final response = await dio.post(
        ApiConfig.resendOtp,
        data: {'mobile': mobile},
        options: Options(contentType: Headers.jsonContentType),
      );

      return AuthOtpResponse.fromJson(response.data);
    } catch (error) {
      final message = ApiErrorHandler.handleError(error);
      return AuthOtpResponse(success: false, message: message, data: null);
    }
  }

  // ==================== Profile Operations ====================

  /// Updates user profile details for new users
  ///
  /// Parameters:
  /// - [fullName]: User's full name
  /// - [email]: User's email address
  /// - [gender]: User's gender
  /// - [dateOfBirth]: User's date of birth
  ///
  /// Returns:
  /// - [AuthVerifyResponse] with updated user data
  Future<AuthVerifyResponse> updateProfile({
    required String fullName,
    required String email,
    required String gender,
    required String dateOfBirth,
  }) async {
    try {
      final auth = Get.find<AuthController>();

      final response = await dio.post(
        ApiConfig.completeProfile,
        data: {
          'full_name': fullName,
          'email': email,
          'gender': gender,
          'date_of_birth': dateOfBirth,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: auth.getAuthHeaders(),
        ),
      );

      return AuthVerifyResponse.fromJson(response.data);
    } catch (error) {
      final message = ApiErrorHandler.handleError(error);
      return AuthVerifyResponse(success: false, message: message, data: null);
    }
  }

  // ==================== Logout Operations ====================

  /// Logs out the current user
  ///
  /// Sends logout request to server to invalidate tokens.
  /// Even if API fails, local session should be cleared.
  ///
  /// Returns:
  /// - [bool] indicating if logout was successful on server
  Future<bool> logout() async {
    try {
      final auth = Get.find<AuthController>();

      final response = await dio.post(
        ApiConfig.logout,
        data: {
          'access_token': auth.accessToken.value,
          'refresh_token': auth.refreshToken.value,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: auth.getAuthHeaders(),
          validateStatus: (_) => true,
        ),
      );

      // Parse response
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        return map['success'] == true;
      }

      return response.statusCode == 200;
    } catch (error) {
      // API failed but we should still clear local session
      return false;
    }
  }

  // ==================== Token Operations ====================

  /// Refreshes authentication tokens using refresh token
  ///
  /// Called automatically when API returns 401 Unauthorized.
  ///
  /// Returns:
  /// - [AuthVerifyResponse] with new tokens on success
  /// - [null] if refresh failed
  Future<AuthVerifyResponse?> refreshTokens() async {
    try {
      final auth = Get.find<AuthController>();

      final response = await dio.post(
        ApiConfig.refreshToken,
        data: {
          'refresh_token': auth.refreshToken.value,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Content-Type': 'application/json'},
          validateStatus: (_) => true,
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final parsed = AuthVerifyResponse.fromJson(response.data);
        if (parsed.success && parsed.data != null) {
          return parsed;
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}

