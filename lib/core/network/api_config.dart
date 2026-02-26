import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const baseUrl = 'https://api.openweathermap.org';
  static const weatherPath = '/data/2.5/weather';

  static String get apiKey {
    final fromEnv = dotenv.env['OPENWEATHER_API_KEY']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv;
    }
    const fromDefine = String.fromEnvironment('OPENWEATHER_API_KEY');
    return fromDefine;
  }
}
