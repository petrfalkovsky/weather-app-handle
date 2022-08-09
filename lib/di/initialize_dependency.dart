import 'package:get_it/get_it.dart';
import 'package:weather_app_cubit_friflex_test_task/core/services/repository.dart';
import 'package:weather_app_cubit_friflex_test_task/core/services/weather_api.dart';
import 'package:http/http.dart' as http;

// сервис локатор
GetIt injector = GetIt.instance;

Future<void> initializeDependency() async {
  injector.registerSingleton<http.Client>(http.Client());

  injector
      .registerSingleton<IWeatherApi>(WeatherApi(injector.get<http.Client>()));

  injector.registerSingleton<AstractRepository>(
      Repository(injector.get<IWeatherApi>()));
}
