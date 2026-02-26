import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/network/dio_client.dart';
import '../features/weather/data/datasources/weather_remote_datasource.dart';
import '../features/weather/data/repositories/weather_repository_impl.dart';
import '../features/weather/domain/repositories/weather_repository.dart';
import '../features/weather/domain/usecases/get_weather.dart';
import '../features/weather/presentation/cubit/weather_cubit.dart';

final sl = GetIt.instance;

void setupDI() {
  sl.registerLazySingleton<Dio>(createDio);
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetWeather(sl()));

  sl.registerFactory(() => WeatherCubit(sl()));
}
