import 'package:dio/dio.dart';
import '../model/auth/auth_otp_response.dart';
import '../api/base_api.dart';
import '../config/api_config.dart';
import '../model/auth/auth_verify_response.dart';
import 'package:get/get.dart';
import '../controller/auth_controller/auth_controller.dart';

class AuthServices extends BaseApi {

  /// send otp
  Future<AuthOtpResponse> sendOtp(String mobile) async {
    try {
      final response = await dio.post(
        ApiConfig.sendOtp,
        data: {'mobile': mobile},
        options: Options(contentType: Headers.jsonContentType),
      );
      return AuthOtpResponse.fromJson(response.data);

    } catch (error) {
      final message = _mapDioError(error);
      return AuthOtpResponse(success: false, message: message, data: null);
    }
  }

  /// ✅ Verify OTP API
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
      print('Debug Exception in verifyOtp: $error');
      final message = _mapDioError(error);
      return AuthVerifyResponse(success: false, message: message, data: null);
    }
  }

  /// Resend otp
  Future<AuthOtpResponse> resendOtp(String mobile) async {
    try {
      final response = await dio.post(
        ApiConfig.resendOtp,
        data: {'mobile': mobile},
        options: Options(contentType: Headers.jsonContentType),
      );
      return AuthOtpResponse.fromJson(response.data);

    } catch (error) {
      final message = _mapDioError(error);
      return AuthOtpResponse(success: false, message: message, data: null);
    }
  }


  /// Update user profile details for new users
  Future<AuthVerifyResponse> updateProfile({
    required String fullName,
    required String email,
    required String gender,
    required String dateOfBirth,
  }) async {
    try {
      final auth = Get.find<AuthController>();
      print('🔧 Sending update profile API request...');
      print('📋 Data: fullName=$fullName, email=$email, gender=$gender, dob=$dateOfBirth');
      print('🔑 Auth Headers: ${auth.getAuthHeaders()}');

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

      print('✅ API Response Status: ${response.statusCode}');
      print('📊 API Response Body: ${response.data}');

      return AuthVerifyResponse.fromJson(response.data);
    } catch (error) {
      print('Debug Exception in updateProfile: $error');
      final message = _mapDioError(error);
      return AuthVerifyResponse(success: false, message: message, data: null);
    }
  }

  /// Logout API
  Future<bool> logout() async {
    try {
      final auth = Get.find<AuthController>();
      final response = await dio.post(
        ApiConfig.logout,
        data: {
          // Sending tokens in body to be safe with PHP backend handlers
          'access_token': auth.accessToken.value,
          'refresh_token': auth.refreshToken.value,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: auth.getAuthHeaders(),
          // Do not throw on non-2xx; we handle success boolean from body
          validateStatus: (_) => true,
        ),
      );

      // Expecting { success: boolean, message: string, data: any }
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        return map['success'] == true;
      }
      return response.statusCode == 200;
    } catch (error) {
      // Even if API fails, we'll proceed to clear local session per guide
      return false;
    }
  }

  /// Check token validity
/*
  Future<bool> checkTokenStatus() async {
    try {
      final auth = Get.find<AuthController>();
      final response = await dio.post(
        ApiConfig.checkTokenStatus,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: auth.getAuthHeaders(),
          validateStatus: (_) => true,
        ),
      );
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        return map['valid'] == true;
      }
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
*/

  /// Refresh tokens
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


  String _mapDioError(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError) {
        return 'Something went wrong. Please check your connection.';
      }
      try {
        final data = error.response?.data;
        if (data is Map<String, dynamic>) {
          if (data['message'] is String && (data['message'] as String).isNotEmpty) {
            return data['message'] as String;
          }
        }
      } catch (_) {}
      return error.message ?? 'Request failed';
    }
    return error.toString();
  }

}
