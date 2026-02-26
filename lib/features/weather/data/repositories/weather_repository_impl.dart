import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remote;
  WeatherRepositoryImpl(this._remote);

  @override
  Future<WeatherEntity> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String lang = 'pt_br',
  }) async {
    final dto = await _remote.fetchCurrentWeather(
      lat: lat,
      lon: lon,
      units: units,
      lang: lang,
    );

    final hoursOffset = dto.timezoneOffsetSeconds ~/ 3600;
    final sign = hoursOffset >= 0 ? '+' : '-';
    final timezoneLabel = 'UTC$sign${hoursOffset.abs()}';

    return WeatherEntity(
      lat: dto.lat,
      lon: dto.lon,
      cityName: dto.cityName,
      description: dto.description,
      timezone: timezoneLabel,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        dto.dt * 1000,
        isUtc: true,
      ),
      tempC: dto.temp,
      humidity: dto.humidity,
      windSpeedMs: dto.windSpeedMs,
      visibilityM: dto.visibilityM,
    );
  }
}
