/*
import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../controller/auth_controller.dart';
import 'package:get/get.dart' hide Response;

class BaseApi {
  final Dio dio;

  BaseApi() : dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  )) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (Get.isRegistered<AuthController>()) {
          final auth = Get.find<AuthController>();
          final headers = auth.getAuthHeaders();
          if (headers['Authorization'] != null) {
            options.headers.addAll(headers);
          }
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401 && Get.isRegistered<AuthController>()) {
          final auth = Get.find<AuthController>();
          final refreshed = await auth.tryRefreshTokens();
          if (refreshed) {
            final response = await _retry(e.requestOptions);
            return handler.resolve(response);
          } else {
            // Optional: Force logout logic or alert user
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) {
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
*/

import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../controller/auth_controller/auth_controller.dart';
import 'package:get/get.dart' hide Response;

class BaseApi {
  final Dio dio;

  BaseApi()
      : dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  )) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Directly get AuthController since it is always registered
          final auth = Get.find<AuthController>();
          final headers = auth.getAuthHeaders();
          if (headers['Authorization'] != null) {
            options.headers.addAll(headers);
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          // Handle 401 Unauthorized
          if (e.response?.statusCode == 401) {
            final auth = Get.find<AuthController>();
            final refreshed = await auth.refreshTokens();
            if (refreshed) {
              // Retry original request with new token
              final response = await _retry(e.requestOptions);
              return handler.resolve(response);
            } else {
              // Optional: force logout or notify user
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) {
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
