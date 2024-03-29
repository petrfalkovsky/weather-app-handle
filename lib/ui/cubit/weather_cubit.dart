// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app_cubit_friflex_test_task/domain/models/forecast.dart';
import 'package:weather_app_cubit_friflex_test_task/core/services/repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final AstractRepository _repository;
  WeatherCubit(this._repository)
      // супером делаем виджет стартовой инициализации со стейтом
      : super(WeatherInitial('Please enter city name.'));

  Future<void> getWeather(String cityName) async {
    try {
      // пробуем загрузить погоду
      emit(WeatherLoading());
      final forecast = await _repository.getWeather(cityName.trim());
      forecast.city = cityName;
      emit(WeatherLoaded(forecast: forecast));
    } catch (_) {
      // пробуем поймать варианты ошибок при ответе
      if (cityName.isEmpty) {
        emit(WeatherError("Please enter city name."));
      } else if (_.toString().contains('error retrieving location for city')) {
        emit(WeatherError("City not found."));
      } else {
        emit(WeatherError(
            "Error getting data. Network error, please try again"));
      }
    }
  }
}
