import 'package:flutter/material.dart';

import 'weather_models.dart';

class WeatherSectionHeader extends StatelessWidget {
  const WeatherSectionHeader({
    super.key,
    required this.left,
    required this.right,
  });

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          left,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        const Spacer(),
        Text(
          right,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF1D72E7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class HourlyForecastSection extends StatelessWidget {
  const HourlyForecastSection({super.key, required this.items});

  final List<HourlyForecastItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 206,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _HourlyCard(item: items[index]),
      ),
    );
  }
}

class DailyForecastSection extends StatelessWidget {
  const DailyForecastSection({super.key, required this.items});

  final List<DailyForecastItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _DailyCard(item: items[index]),
    );
  }
}

class _HourlyCard extends StatelessWidget {
  const _HourlyCard({required this.item});

  final HourlyForecastItem item;

  @override
  Widget build(BuildContext context) {
    final selected = item.selected;
    return Container(
      width: 108,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1D72E7) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(34),
        border: selected ? null : Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            item.label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF111827),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            item.icon,
            color: selected ? Colors.white : const Color(0xFF111827),
            size: 34,
          ),
          const Spacer(),
          Text(
            item.temp,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF111827),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyCard extends StatelessWidget {
  const _DailyCard({required this.item});

  final DailyForecastItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              item.day,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          Icon(item.icon, size: 30, color: const Color(0xFF111827)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.condition,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 19),
            ),
          ),
          Text(
            item.high,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            item.low,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
