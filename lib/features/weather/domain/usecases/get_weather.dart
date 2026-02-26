import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository _repo;
  GetWeather(this._repo);

  Future<WeatherEntity> call({
    required double lat,
    required double lon,
    String units = 'metric',
    String lang = 'pt_br',
  }) {
    return _repo.getWeather(
      lat: lat,
      lon: lon,
      units: units,
      lang: lang,
    );
  }
}
