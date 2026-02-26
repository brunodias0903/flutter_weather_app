import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../domain/usecases/get_weather.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeather _getWeather;
  WeatherCubit(this._getWeather) : super(WeatherInitial());

  Future<void> load(
    double lat,
    double lon, {
    String lang = 'pt_br',
  }) async {
    emit(WeatherLoading());
    try {
      final weather = await _getWeather(
        lat: lat,
        lon: lon,
        units: 'metric',
        lang: lang,
      );
      emit(WeatherLoaded(weather));
    } on DioException catch (e) {
      final data = e.response?.data;
      final apiMessage = data is Map<String, dynamic> ? data['message'] : null;
      final message = apiMessage?.toString() ?? e.message ?? e.toString();
      emit(WeatherError('Erro da API: $message'));
    } catch (e) {
      emit(WeatherError('Erro inesperado: $e'));
    }
  }
}
