import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../controller/network_controller.dart';
import '../constants/app_strings.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  /// Handles DioException and returns a user-friendly error message
  static String handleError(Object error) {
    if (error is DioException) {
      // Update network controller with connection status
      _updateNetworkStatus(error);
      return _handleDioError(error);
    }
    return error.toString();
  }

  /// Update network controller based on error type
  static void _updateNetworkStatus(DioException error) {
    try {
      final networkController = Get.find<NetworkController>();

      if (isNoInternetError(error)) {
        networkController.isConnectedObs.value = false;
      }
    } catch (e) {}
  }

  /// Handles different types of DioException
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppStrings.connectionTimeout;

      case DioExceptionType.connectionError:
        return AppStrings.noInternetConnection2;

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return AppStrings.requestCancelled;

      case DioExceptionType.badCertificate:
        return AppStrings.certificateError;

      case DioExceptionType.unknown:
      default:
        if (error.message?.contains('SocketException') == true) {
          return AppStrings.noInternetNetwork;
        }
        return AppStrings.somethingWentWrongTryLater;
    }
  }

  /// Handles HTTP response errors based on status code
  static String _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // Try to extract error message from response
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    // Default messages based on status code
    switch (statusCode) {
      case 400:
        return AppStrings.badRequest;
      case 401:
        return AppStrings.unauthorized;
      case 403:
        return AppStrings.accessForbidden;
      case 404:
        return AppStrings.resourceNotFound;
      case 408:
        return AppStrings.requestTimeout;
      case 429:
        return AppStrings.tooManyRequests;
      case 500:
        return AppStrings.serverError;
      case 502:
        return AppStrings.badGateway;
      case 503:
        return AppStrings.serviceUnavailable;
      default:
        return AppStrings.somethingWentWrongTryAgain;
    }
  }

  /// Checks if error is due to no internet connection
  static bool isNoInternetError(Object error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
          error.message?.contains('SocketException') == true;
    }
    return false;
  }


}

