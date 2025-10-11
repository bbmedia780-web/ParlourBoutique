import 'package:dio/dio.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  /// Handles DioException and returns a user-friendly error message
  static String handleError(Object error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return error.toString();
  }

  /// Handles different types of DioException
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please contact support.';

      case DioExceptionType.unknown:
      default:
        if (error.message?.contains('SocketException') == true) {
          return 'No internet connection. Please check your network.';
        }
        return 'Something went wrong. Please try again later.';
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
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 408:
        return 'Request timeout. Please try again.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
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

  /// Checks if error is due to authentication failure
  static bool isAuthError(Object error) {
    if (error is DioException) {
      return error.response?.statusCode == 401;
    }
    return false;
  }
}

