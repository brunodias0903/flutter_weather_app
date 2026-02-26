import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/weather/presentation/cubit/weather_cubit.dart';
import '../features/weather/presentation/pages/weather_page.dart';
import 'di.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => sl<WeatherCubit>(),
        child: const WeatherPage(),
      ),
    );
  }
}
