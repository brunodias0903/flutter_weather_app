class CurrentWeatherResponseModel {
  final double lat;
  final double lon;
  final int timezoneOffsetSeconds;
  final int dt;
  final String cityName;
  final String description;
  final double temp;
  final int humidity;
  final double windSpeedMs;
  final int visibilityM;

  CurrentWeatherResponseModel({
    required this.lat,
    required this.lon,
    required this.timezoneOffsetSeconds,
    required this.dt,
    required this.cityName,
    required this.description,
    required this.temp,
    required this.humidity,
    required this.windSpeedMs,
    required this.visibilityM,
  });

  factory CurrentWeatherResponseModel.fromJson(Map<String, dynamic> json) {
    final coord = (json['coord'] as Map<String, dynamic>? ?? const {});
    final main = (json['main'] as Map<String, dynamic>? ?? const {});
    final wind = (json['wind'] as Map<String, dynamic>? ?? const {});
    final weather = (json['weather'] as List<dynamic>? ?? const []);
    final weatherFirst =
        weather.isNotEmpty
            ? (weather.first as Map<String, dynamic>? ?? const {})
            : const <String, dynamic>{};

    return CurrentWeatherResponseModel(
      lat: (coord['lat'] as num).toDouble(),
      lon: (coord['lon'] as num).toDouble(),
      timezoneOffsetSeconds: (json['timezone'] as num).toInt(),
      dt: (json['dt'] as num).toInt(),
      cityName: json['name'] as String? ?? '',
      description: weatherFirst['description'] as String? ?? '',
      temp: (main['temp'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      windSpeedMs: (wind['speed'] as num?)?.toDouble() ?? 0,
      visibilityM: (json['visibility'] as num?)?.toInt() ?? 0,
    );
  }
}
