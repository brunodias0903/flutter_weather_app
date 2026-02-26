import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeather({
    required double lat,
    required double lon,
    String units,
    String lang,
  });
}
