import 'package:flutter/material.dart';

class WeatherCurrentSummary extends StatelessWidget {
  const WeatherCurrentSummary({
    super.key,
    required this.currentTemp,
    required this.condition,
    required this.updatedAtLabel,
    required this.showUpdatedAt,
    required this.isLoading,
    required this.errorMessage,
  });

  final int currentTemp;
  final String condition;
  final String updatedAtLabel;
  final bool showUpdatedAt;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const Center(
          child: Icon(
            Icons.wb_cloudy_outlined,
            size: 116,
            color: Color(0xFF1D72E7),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            '$currentTemp°',
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 98,
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            condition,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            showUpdatedAt ? updatedAtLabel : '--',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (isLoading) ...[
          const SizedBox(height: 14),
          const Center(child: CircularProgressIndicator(strokeWidth: 2.2)),
        ],
        if (errorMessage != null) ...[
          const SizedBox(height: 12),
          Center(
            child: Text(
              errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFB91C1C),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
