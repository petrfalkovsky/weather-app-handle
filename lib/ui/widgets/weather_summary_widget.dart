import 'package:flutter/material.dart';
import 'package:weather_app_cubit_friflex_test_task/models/weather.dart';

// виджет выводит дату, ясность, температуру, чувствуется как
class WeatherSummaryWidget extends StatelessWidget {
  const WeatherSummaryWidget({
    Key? key,
    required this.date,
    required this.condition,
    required this.temp,
    required this.windSpeed,
    required this.humidity,
  }) : super(key: key);

  final WeatherCondition condition;
  final int temp;
  final String windSpeed;
  final String date;
  final String humidity;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(date,
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
            )),
        _mapWeatherConditionToImage(condition),
        Column(
          children: [
            Text(
              temp.toString() + '°',
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Wind $windSpeed',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Humidity $humidity',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _mapWeatherConditionToImage(WeatherCondition condition) {
    Image image;
    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        image = Image.asset('assets/images/clear.png');
        break;
      case WeatherCondition.snow:
        image = Image.asset('assets/images/snow.png');
        break;
      case WeatherCondition.heavyCloud:
        image = Image.asset('assets/images/cloudy.png');
        break;
      case WeatherCondition.drizzle:
      case WeatherCondition.mist:
      case WeatherCondition.rain:
        image = Image.asset('assets/images/rainy.png');
        break;
      case WeatherCondition.thunderstorm:
        image = Image.asset('assets/images/thunderstorm.png');
        break;
      case WeatherCondition.unknown:
        image = Image.asset('assets/images/clear.png');
        break;
    }

    return Padding(padding: const EdgeInsets.only(top: 5), child: image);
  }
}
