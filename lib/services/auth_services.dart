import 'package:dio/dio.dart';
import '../model/auth/auth_otp_response.dart';
import '../api/base_api.dart';
import '../config/api_config.dart';
import '../model/auth/auth_verify_response.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class AuthServices extends BaseApi {

  Future<AuthOtpResponse> sendOtp(String mobile) async {
    try {
      final response = await dio.post(
        ApiConfig.sendOtp,
        data: {'mobile': mobile},
        options: Options(contentType: Headers.jsonContentType),
      );

      // Directly parse JSON into AuthOtpResponse
      return AuthOtpResponse.fromJson(response.data);

    } catch (error) {
      print('Debug Exception in sendOtp: $error');

      // Return a safe default response
      return AuthOtpResponse(
        success: false,
        message: 'Something went wrong. Please try again.',
        data: null,
      );
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

      return AuthVerifyResponse(
        success: false,
        message: 'Something went wrong. Please try again.',
        data: null,
      );
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
      print('Debug Exception in updateProfile: $error');
      return AuthVerifyResponse(
        success: false,
        message: 'Something went wrong. Please try again.',
        data: null,
      );
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


}
