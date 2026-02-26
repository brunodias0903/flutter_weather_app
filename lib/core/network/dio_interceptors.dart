import 'package:dio/dio.dart';

import 'api_config.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (ApiConfig.apiKey.isEmpty) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'OPENWEATHER_API_KEY nao definida no .env ou --dart-define.',
        ),
      );
      return;
    }

    options.queryParameters.putIfAbsent('appid', () => ApiConfig.apiKey);
    super.onRequest(options, handler);
  }
}
