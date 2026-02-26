import 'package:flutter/material.dart';

class HourlyForecastItem {
  const HourlyForecastItem({
    required this.label,
    required this.temp,
    required this.icon,
    this.selected = false,
  });

  final String label;
  final String temp;
  final IconData icon;
  final bool selected;
}

class DailyForecastItem {
  const DailyForecastItem({
    required this.day,
    required this.condition,
    required this.icon,
    required this.high,
    required this.low,
  });

  final String day;
  final String condition;
  final IconData icon;
  final String high;
  final String low;
}

class MetricItem {
  const MetricItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
}
