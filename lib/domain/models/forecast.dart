import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_cubit_friflex_test_task/core/utils/extensions.dart';
import 'package:weather_app_cubit_friflex_test_task/core/utils/temp_converter.dart';

import 'weather.dart';

class Forecast {
  final TimeOfDay lastUpdated;
  final List<Weather> daily;
  Weather current;
  bool isDayTime;
  String city;
  String sunset;
  String sunrise;
  String date;

  Forecast(
      {required this.lastUpdated,
      this.daily = const [],
      required this.current,
      this.city = '',
      required this.isDayTime,
      required this.sunrise,
      required this.sunset,
      required this.date});

  static Forecast fromJson(dynamic json) {
    var weather = json['current']['weather'][0];
    var date =
        DateTime.fromMillisecondsSinceEpoch(json['current']['dt'] * 1000);

    var sunrise =
        DateTime.fromMillisecondsSinceEpoch(json['current']['sunrise'] * 1000);

    var sunset =
        DateTime.fromMillisecondsSinceEpoch(json['current']['sunset'] * 1000);

    bool isDay = date.isAfter(sunrise) && date.isBefore(sunset);

    bool hasDaily = json['daily'] != null;
    List<Weather> tempDaily = [];

    if (hasDaily) {
      List items = json['daily'];
      tempDaily = items
          .map((item) => Weather.fromDailyJson(item))
          .toList()
          .skip(1)
          .take(3)
          .toList();
    }

    var currentForcast = Weather(
        cloudiness: int.parse(json['current']['clouds'].toString()),
        temp: TempConverter.kelvinToCelsius(
                double.parse(json['current']['temp'].toString()))
            .round(),
        condition: Weather.mapStringToWeatherCondition(
            weather['main'], int.parse(json['current']['clouds'].toString())),
        description: weather['description'].toString().capitalize(),
        windSpeed:
            '${double.parse(json['current']['wind_speed'].toString()).round()} m/s',
        humidity:
            '${int.parse(json['current']['humidity'].toString()).round()}%',
        date: DateFormat('d EEE').format(date),
        sunrise: DateFormat.jm().format(sunrise),
        sunset: DateFormat.jm().format(sunset));

    return Forecast(
        lastUpdated: TimeOfDay.fromDateTime(DateTime.now()),
        current: currentForcast,
        daily: tempDaily,
        isDayTime: isDay,
        sunset: DateFormat.jm().format(sunset),
        sunrise: DateFormat.jm().format(sunrise),
        date: DateFormat('d EEE').format(date));
  }
}
