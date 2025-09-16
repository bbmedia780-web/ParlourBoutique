import 'package:dio/dio.dart';
import '../../config/api_config.dart';

class BaseApi {
  late final Dio dio;

  BaseApi() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
