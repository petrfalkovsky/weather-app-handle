import 'package:weather_app_cubit_friflex_test_task/domain/models/forecast.dart';
import 'package:weather_app_cubit_friflex_test_task/core/services/weather_api.dart';

abstract class AstractRepository {
  Future<Forecast> getWeather(String city);
}

class Repository extends AstractRepository {
  final IWeatherApi weatherApi;
  Repository(this.weatherApi);

  @override
  Future<Forecast> getWeather(String city) async {
    final location = await weatherApi.getLocation(city);
    return await weatherApi.getWeather(location);
  }
}
