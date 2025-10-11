import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../config/api_config.dart';
import '../controller/auth_controller/auth_controller.dart';

class BaseApi {
  /// Dio instance for making HTTP requests
  final Dio dio;

  /// Constructor - Initializes Dio with base configuration and interceptors
  BaseApi()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  /// Setup Dio interceptors for logging and auth handling
  void _setupInterceptors() {
    // Add logging interceptor (only in debug mode for production)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );

    // Add authentication and error handling interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  /// Request interceptor - Adds authentication headers
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get auth headers from AuthController
      final auth = Get.find<AuthController>();
      final headers = auth.getAuthHeaders();

      // Add authorization header if available
      if (headers['Authorization'] != null) {
        options.headers.addAll(headers);
      }
    } catch (e) {
      // AuthController not found - proceed without auth headers
    }

    return handler.next(options);
  }

  /// Error interceptor - Handles token refresh on 401 errors
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - Token expired
    if (error.response?.statusCode == 401) {
      try {
        final auth = Get.find<AuthController>();
        final refreshed = await auth.refreshTokens();

        if (refreshed) {
          // Token refreshed successfully - retry the original request
          final response = await _retryRequest(error.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        // Token refresh failed or AuthController not found
        // Continue with the error
      }
    }

    return handler.next(error);
  }

  /// Retries a failed request with updated headers
  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

