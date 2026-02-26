import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final double lat;
  final double lon;
  final String cityName;
  final String description;
  final String timezone;

  final DateTime updatedAt;
  final double tempC;
  final int humidity;
  final double windSpeedMs;
  final int visibilityM;

  const WeatherEntity({
    required this.lat,
    required this.lon,
    required this.cityName,
    required this.description,
    required this.timezone,
    required this.updatedAt,
    required this.tempC,
    required this.humidity,
    required this.windSpeedMs,
    required this.visibilityM,
  });

  @override
  List<Object?> get props => [
    lat,
    lon,
    cityName,
    description,
    timezone,
    updatedAt,
    tempC,
    humidity,
    windSpeedMs,
    visibilityM,
  ];
}
