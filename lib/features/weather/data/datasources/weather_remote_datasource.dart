import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../models/onecall_response_model.dart';

abstract class WeatherRemoteDataSource {
  Future<CurrentWeatherResponseModel> fetchCurrentWeather({
    required double lat,
    required double lon,
    String units,
    String lang,
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio _dio;
  WeatherRemoteDataSourceImpl(this._dio);

  @override
  Future<CurrentWeatherResponseModel> fetchCurrentWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String lang = 'pt_br',
  }) async {
    final res = await _dio.get(
      ApiConfig.weatherPath,
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'units': units,
        'lang': lang,
      },
    );

    return CurrentWeatherResponseModel.fromJson(
      res.data as Map<String, dynamic>,
    );
  }
}
