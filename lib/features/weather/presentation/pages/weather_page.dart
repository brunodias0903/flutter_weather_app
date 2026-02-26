import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../cubit/weather_cubit.dart';
import '../cubit/weather_state.dart';
import '../widgets/weather_home.dart';
import '../widgets/weather_language.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  static const _fallbackLat = -23.5505;
  static const _fallbackLon = -46.6333;

  UiLanguage _language = UiLanguage.ptBr;
  double? _lastLat;
  double? _lastLon;
  String? _locationError;
  bool _isResolvingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadByDeviceLocation();
  }

  Future<void> _loadByDeviceLocation() async {
    if (mounted) {
      setState(() {
        _isResolvingLocation = true;
        _locationError = null;
      });
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = _language == UiLanguage.ptBr
              ? 'Ative o GPS do dispositivo para ver o clima local.'
              : 'Enable device location services to see local weather.';
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = _language == UiLanguage.ptBr
              ? 'Permissao de localizacao negada.'
              : 'Location permission denied.';
        });
        return;
      }

      final position = await _resolvePosition();
      await _loadWeather(position.latitude, position.longitude);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _locationError = _language == UiLanguage.ptBr
            ? 'Falha ao obter sua localização. Usando São Paulo.'
            : 'Failed to get your location. Using São Paulo.';
      });
      await _loadWeather(_fallbackLat, _fallbackLon);
    } finally {
      if (mounted) {
        setState(() {
          _isResolvingLocation = false;
        });
      }
    }
  }

  Future<Position> _resolvePosition() async {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.medium,
      timeLimit: Duration(seconds: 12),
    );

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (_) {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }
      rethrow;
    }
  }

  Future<void> _loadWeather(double lat, double lon) async {
    if (!mounted) return;
    setState(() {
      _lastLat = lat;
      _lastLon = lon;
    });
    await context.read<WeatherCubit>().load(lat, lon, lang: _language.apiLang);
  }

  Future<void> _toggleLanguage() async {
    setState(() {
      _language = _language == UiLanguage.ptBr
          ? UiLanguage.en
          : UiLanguage.ptBr;
      _locationError = null;
    });

    final lat = _lastLat;
    final lon = _lastLon;
    if (lat != null && lon != null) {
      await context.read<WeatherCubit>().load(
        lat,
        lon,
        lang: _language.apiLang,
      );
      return;
    }

    await _loadByDeviceLocation();
  }

  Future<void> _refreshWeather() async {
    final lat = _lastLat;
    final lon = _lastLon;
    if (lat != null && lon != null) {
      await context.read<WeatherCubit>().load(
        lat,
        lon,
        lang: _language.apiLang,
      );
      return;
    }
    await _loadByDeviceLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        final weather = switch (state) {
          WeatherLoaded(:final weather) => weather,
          _ => null,
        };

        final apiError = switch (state) {
          WeatherError(:final message) => message,
          _ => null,
        };

        return WeatherHome(
          weather: weather,
          apiError: apiError,
          locationError: _locationError,
          isLoading: state is WeatherLoading || _isResolvingLocation,
          language: _language,
          onToggleLanguage: _toggleLanguage,
          onReloadLocation: _loadByDeviceLocation,
          onRefresh: _refreshWeather,
        );
      },
    );
  }
}
