import 'package:flutter/material.dart';

import '../../domain/entities/weather_entity.dart';
import 'weather_current_summary.dart';
import 'weather_forecast_section.dart';
import 'weather_formatters.dart';
import 'weather_header.dart';
import 'weather_language.dart';
import 'weather_metrics_section.dart';
import 'weather_models.dart';

class WeatherHome extends StatelessWidget {
  const WeatherHome({
    super.key,
    required this.weather,
    required this.apiError,
    required this.locationError,
    required this.isLoading,
    required this.language,
    required this.onToggleLanguage,
    required this.onReloadLocation,
    required this.onRefresh,
  });

  final WeatherEntity? weather;
  final String? apiError;
  final String? locationError;
  final bool isLoading;
  final UiLanguage language;
  final VoidCallback onToggleLanguage;
  final VoidCallback onReloadLocation;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final cityName = weather?.cityName.isNotEmpty == true
        ? weather!.cityName
        : (language.isPtBr ? 'Sua localizacao' : 'Your location');

    final currentTemp = weather?.tempC.round() ?? 0;
    final condition =
        capitalize(weather?.description) ??
        (language.isPtBr ? 'Carregando' : 'Loading');
    final humidity = weather?.humidity ?? 0;
    final windMs = weather?.windSpeedMs ?? 0;
    final visibilityM = weather?.visibilityM ?? 0;

    final windValue = language.isPtBr
        ? '${(windMs * 3.6).toStringAsFixed(0)} km/h'
        : '${(windMs * 2.23694).toStringAsFixed(0)} mph';
    final visibilityValue = language.isPtBr
        ? '${(visibilityM / 1000).toStringAsFixed(1)} km'
        : '${(visibilityM * 0.000621371).toStringAsFixed(1)} mi';

    final errorMessage = locationError ?? apiError;
    final hourly = _buildHourlyForecastItems(language, currentTemp);
    final daily = _buildDailyForecastItems(language, currentTemp, condition);
    final metrics = _buildMetricItems(
      language: language,
      weather: weather,
      windValue: windValue,
      humidity: humidity,
      visibilityValue: visibilityValue,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE9EDF2),
      appBar: WeatherTopBar(
        cityName: cityName,
        dateLabel: formatWeatherDate(now, language),
        language: language,
        onToggleLanguage: onToggleLanguage,
        onReloadLocation: onReloadLocation,
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                WeatherCurrentSummary(
                  currentTemp: currentTemp,
                  condition: condition,
                  updatedAtLabel: weather == null
                      ? '--'
                      : formatUpdatedAt(weather!.updatedAt, language),
                  showUpdatedAt: weather != null,
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                ),
                const SizedBox(height: 30),
                WeatherSectionHeader(
                  left: language.isPtBr
                      ? 'Previsao por hora'
                      : 'Hourly Forecast',
                  right: language.isPtBr ? 'Detalhes' : 'Details',
                ),
                const SizedBox(height: 14),
                HourlyForecastSection(items: hourly),
                const SizedBox(height: 34),
                WeatherSectionHeader(
                  left: language.isPtBr ? 'Previsao diaria' : 'Daily Forecast',
                  right: language.isPtBr ? '7 dias' : '7 Days',
                ),
                const SizedBox(height: 14),
                DailyForecastSection(items: daily),
                const SizedBox(height: 24),
                WeatherMetricsSection(items: metrics),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<HourlyForecastItem> _buildHourlyForecastItems(
    UiLanguage language,
    int currentTemp,
  ) {
    return [
      HourlyForecastItem(
        label: language.isPtBr ? 'Agora' : 'Now',
        temp: '$currentTemp°',
        icon: Icons.wb_cloudy_outlined,
        selected: true,
      ),
      const HourlyForecastItem(
        label: '2 PM',
        temp: '74°',
        icon: Icons.wb_sunny_outlined,
      ),
      const HourlyForecastItem(
        label: '3 PM',
        temp: '75°',
        icon: Icons.wb_sunny_outlined,
      ),
      const HourlyForecastItem(
        label: '4 PM',
        temp: '73°',
        icon: Icons.cloud_outlined,
      ),
      const HourlyForecastItem(label: '5 PM', temp: '70°', icon: Icons.grain),
    ];
  }

  List<DailyForecastItem> _buildDailyForecastItems(
    UiLanguage language,
    int currentTemp,
    String condition,
  ) {
    return [
      DailyForecastItem(
        day: language.isPtBr ? 'Hoje' : 'Today',
        condition: condition,
        icon: Icons.wb_sunny_outlined,
        high: '${currentTemp + 4}°',
        low: '${currentTemp - 4}°',
      ),
      DailyForecastItem(
        day: language.isPtBr ? 'Ter' : 'Tue',
        condition: language.isPtBr ? 'Chuva' : 'Rain',
        icon: Icons.grain,
        high: '${currentTemp - 1}°',
        low: '${currentTemp - 8}°',
      ),
      DailyForecastItem(
        day: language.isPtBr ? 'Qua' : 'Wed',
        condition: language.isPtBr ? 'Ensolarado' : 'Sunny',
        icon: Icons.wb_sunny_outlined,
        high: '${currentTemp + 2}°',
        low: '${currentTemp - 6}°',
      ),
    ];
  }

  List<MetricItem> _buildMetricItems({
    required UiLanguage language,
    required WeatherEntity? weather,
    required String windValue,
    required int humidity,
    required String visibilityValue,
  }) {
    return [
      MetricItem(
        title: language.isPtBr ? 'Vento' : 'Wind',
        value: windValue,
        subtitle: weather == null
            ? '-'
            : (language.isPtBr ? 'Velocidade atual' : 'Current speed'),
        icon: Icons.air,
      ),
      MetricItem(
        title: language.isPtBr ? 'Umidade' : 'Humidity',
        value: '$humidity%',
        subtitle: language.isPtBr ? 'Atual' : 'Current',
        icon: Icons.water_drop_outlined,
      ),
      MetricItem(
        title: language.isPtBr ? 'Indice UV' : 'UV Index',
        value: language.isPtBr ? 'Alto (6)' : 'High (6)',
        subtitle: language.isPtBr ? 'Use protecao' : 'Use protection',
        icon: Icons.wb_sunny_outlined,
      ),
      MetricItem(
        title: language.isPtBr ? 'Visibilidade' : 'Visibility',
        value: visibilityValue,
        subtitle: language.isPtBr ? 'Vista limpa' : 'Clear view',
        icon: Icons.remove_red_eye_outlined,
      ),
    ];
  }
}
