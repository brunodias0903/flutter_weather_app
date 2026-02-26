import 'package:dio/dio.dart';

import 'api_config.dart';
import 'dio_interceptors.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(ApiKeyInterceptor());
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
}
