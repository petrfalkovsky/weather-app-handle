import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_cubit_friflex_test_task/models/weather.dart';

// виджет 3-х дневного форкаста
class DailySummaryWidget extends StatelessWidget {
  const DailySummaryWidget({Key? key, required this.weather}) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = toBeginningOfSentenceCase(weather.date);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
              color: Colors.white10, borderRadius: BorderRadius.circular(10)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // текст даты
                Text(dayOfWeek ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
                // текст температуры
                Text(weather.temp.toString() + '°',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
              ]),
        ));
  }
}