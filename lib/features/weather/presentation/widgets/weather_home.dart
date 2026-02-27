import 'package:flutter/material.dart';

import '../../domain/entities/weather_entity.dart';
import 'weather_current_summary.dart';
import 'weather_forecast_section.dart';
import 'weather_formatters.dart';
import 'weather_header.dart';
import 'weather_language.dart';
import 'weather_metrics_section.dart';
import 'weather_models.dart';

class WeatherHome extends StatefulWidget {
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
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  int _dailyForecastDays = 7;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final cityName = widget.weather?.cityName.isNotEmpty == true
        ? widget.weather!.cityName
        : (widget.language.isPtBr ? 'Sua localizacao' : 'Your location');

    final currentTemp = widget.weather?.tempC.round() ?? 0;
    final condition =
        capitalize(widget.weather?.description) ??
        (widget.language.isPtBr ? 'Carregando' : 'Loading');
    final humidity = widget.weather?.humidity ?? 0;
    final windMs = widget.weather?.windSpeedMs ?? 0;
    final visibilityM = widget.weather?.visibilityM ?? 0;

    final windValue = widget.language.isPtBr
        ? '${(windMs * 3.6).toStringAsFixed(0)} km/h'
        : '${(windMs * 2.23694).toStringAsFixed(0)} mph';
    final visibilityValue = widget.language.isPtBr
        ? '${(visibilityM / 1000).toStringAsFixed(1)} km'
        : '${(visibilityM * 0.000621371).toStringAsFixed(1)} mi';

    final errorMessage = widget.locationError ?? widget.apiError;
    final hourly = _buildHourlyForecastItems(widget.language, currentTemp, now);
    final daily = _buildDailyForecastItems(
      widget.language,
      currentTemp,
      condition,
      now,
      _dailyForecastDays,
    );
    final metrics = _buildMetricItems(
      language: widget.language,
      weather: widget.weather,
      windValue: windValue,
      humidity: humidity,
      visibilityValue: visibilityValue,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE9EDF2),
      appBar: WeatherTopBar(
        cityName: cityName,
        dateLabel: formatWeatherDate(now, widget.language),
        language: widget.language,
        onToggleLanguage: widget.onToggleLanguage,
        onReloadLocation: widget.onReloadLocation,
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: widget.onRefresh,
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
                  updatedAtLabel: widget.weather == null
                      ? '--'
                      : formatUpdatedAt(
                          widget.weather!.updatedAt,
                          widget.language,
                        ),
                  showUpdatedAt: widget.weather != null,
                  isLoading: widget.isLoading,
                  errorMessage: errorMessage,
                ),
                const SizedBox(height: 30),
                WeatherSectionHeader(
                  left: widget.language.isPtBr
                      ? 'Previsão por hora'
                      : 'Hourly Forecast',
                ),
                const SizedBox(height: 14),
                HourlyForecastSection(items: hourly),
                const SizedBox(height: 34),
                WeatherSectionHeader(
                  left: widget.language.isPtBr
                      ? 'Previsão diária'
                      : 'Daily Forecast',
                  trailing: _buildDailyForecastRangeSelect(context),
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
    DateTime now,
  ) {
    final startHour = now.hour;
    return List<HourlyForecastItem>.generate(24 - startHour, (index) {
      final hour = startHour + index;
      final isNow = index == 0;
      return HourlyForecastItem(
        label: isNow
            ? (language.isPtBr ? 'Agora' : 'Now')
            : _formatHourLabel(hour, language),
        temp: '$currentTemp°',
        icon: Icons.wb_cloudy_outlined,
        selected: isNow,
      );
    });
  }

  String _formatHourLabel(int hour, UiLanguage language) {
    if (language.isPtBr) {
      return '${hour.toString().padLeft(2, '0')}h';
    }

    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12 $period';
  }

  Widget _buildDailyForecastRangeSelect(BuildContext context) {
    final theme = Theme.of(context);
    final options = <int>[1, 3, 7];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _dailyForecastDays,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF111827),
          ),
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w600,
          ),
          items: options
              .map(
                (days) => DropdownMenuItem<int>(
                  value: days,
                  child: Text(_dailyRangeLabel(days, widget.language)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null || value == _dailyForecastDays) return;
            setState(() {
              _dailyForecastDays = value;
            });
          },
        ),
      ),
    );
  }

  String _dailyRangeLabel(int days, UiLanguage language) {
    if (days == 1) {
      return language.isPtBr ? 'Hoje' : 'Today';
    }

    return language.isPtBr ? '$days dias' : '$days days';
  }

  List<DailyForecastItem> _buildDailyForecastItems(
    UiLanguage language,
    int currentTemp,
    String condition,
    DateTime now,
    int totalDays,
  ) {
    const highOffsets = [4, 3, 2, 1, 0, 2, 1];
    const lowOffsets = [-4, -5, -6, -4, -7, -8, -6];
    const ptConditions = [
      'Chuva',
      'Ensolarado',
      'Nublado',
      'Chuva fraca',
      'Ventando',
      'Parcialmente nublado',
    ];
    const enConditions = [
      'Rain',
      'Sunny',
      'Cloudy',
      'Light rain',
      'Windy',
      'Partly cloudy',
    ];
    const icons = [
      Icons.wb_sunny_outlined,
      Icons.grain,
      Icons.cloud_outlined,
      Icons.wb_cloudy_outlined,
      Icons.air,
      Icons.cloud_outlined,
      Icons.wb_sunny_outlined,
    ];

    final baseDate = DateTime(now.year, now.month, now.day);

    final daysToShow = totalDays.clamp(1, 7).toInt();

    return List<DailyForecastItem>.generate(daysToShow, (index) {
      final date = baseDate.add(Duration(days: index));
      final isToday = index == 0;
      final conditionLabel = isToday
          ? condition
          : (language.isPtBr
                ? ptConditions[(index - 1) % ptConditions.length]
                : enConditions[(index - 1) % enConditions.length]);

      return DailyForecastItem(
        day: _formatDayLabel(date, language, isToday: isToday),
        condition: conditionLabel,
        icon: icons[index],
        high: '${currentTemp + highOffsets[index]}°',
        low: '${currentTemp + lowOffsets[index]}°',
      );
    });
  }

  String _formatDayLabel(
    DateTime date,
    UiLanguage language, {
    required bool isToday,
  }) {
    if (isToday) {
      return language.isPtBr ? 'Hoje' : 'Today';
    }

    const weekdaysPt = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
    const weekdaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekdays = language.isPtBr ? weekdaysPt : weekdaysEn;
    return weekdays[date.weekday - 1];
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
