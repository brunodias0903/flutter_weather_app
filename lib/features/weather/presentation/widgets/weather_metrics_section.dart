import 'package:flutter/material.dart';

import 'weather_models.dart';

class WeatherMetricsSection extends StatelessWidget {
  const WeatherMetricsSection({super.key, required this.items});

  final List<MetricItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.04,
      ),
      itemBuilder: (context, index) => _MetricCard(item: items[index]),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.item});

  final MetricItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, color: const Color(0xFF6B7280), size: 22),
              const SizedBox(width: 8),
              Text(
                item.title,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.value,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.subtitle,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
