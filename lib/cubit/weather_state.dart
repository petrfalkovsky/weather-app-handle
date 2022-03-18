part of 'weather_cubit.dart';

// абстрактный класс неизменного состонияя виджета погоды
@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {
  final String message;
  WeatherInitial(this.message);
}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Forecast forecast;

  WeatherLoaded({required this.forecast}) : super();
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
