import 'package:flutter/material.dart';

import 'weather_language.dart';

class WeatherTopBar extends StatelessWidget implements PreferredSizeWidget {
  const WeatherTopBar({
    super.key,
    required this.cityName,
    required this.dateLabel,
    required this.language,
    required this.onToggleLanguage,
    required this.onReloadLocation,
  });

  final String cityName;
  final String dateLabel;
  final UiLanguage language;
  final VoidCallback onToggleLanguage;
  final VoidCallback onReloadLocation;

  @override
  Size get preferredSize => const Size.fromHeight(112);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleActionButton(
                  onTap: onToggleLanguage,
                  child: Text(
                    language.flag,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                _CircleActionButton(
                  onTap: onReloadLocation,
                  child: const Icon(
                    Icons.my_location_rounded,
                    size: 28,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cityName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFDCE4EE),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 52, height: 52, child: Center(child: child)),
      ),
    );
  }
}
