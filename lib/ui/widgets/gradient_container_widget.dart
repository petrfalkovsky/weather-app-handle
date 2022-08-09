import 'package:flutter/material.dart';
import 'package:weather_app_cubit_friflex_test_task/domain/models/weather.dart';

// контейнер с градиентом
class GradientContainerWidget extends StatelessWidget {
  const GradientContainerWidget(
      {Key? key, required this.color, required this.child})
      : super(key: key);

  final Widget child;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 1.0],
          colors: [
            color.shade800,
            color.shade400,
          ],
        ),
      ),
      child: child,
    );
  }
}

// меняет цвет бекграунда, в зависимости по модельке WeatherCondition в weather.dart
/// работает нестабильно, надо поправить, если не забуду
GradientContainerWidget buildGradientContainer(
    WeatherCondition condition, bool isDayTime, Widget child) {
  GradientContainerWidget container;
  if (!isDayTime) {
    container = GradientContainerWidget(color: Colors.blueGrey, child: child);
  } else {
    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        container = GradientContainerWidget(color: Colors.yellow, child: child);
        break;
      case WeatherCondition.rain:
      case WeatherCondition.drizzle:
      case WeatherCondition.mist:
      case WeatherCondition.heavyCloud:
        container = GradientContainerWidget(color: Colors.indigo, child: child);
        break;
      case WeatherCondition.snow:
        container =
            GradientContainerWidget(color: Colors.lightBlue, child: child);
        break;
      case WeatherCondition.thunderstorm:
        container =
            GradientContainerWidget(color: Colors.deepPurple, child: child);
        break;
      default:
        container =
            GradientContainerWidget(color: Colors.lightBlue, child: child);
    }
  }

  return container;
}
