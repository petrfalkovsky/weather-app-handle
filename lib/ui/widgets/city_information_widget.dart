// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

// виджет выводит  название города время восхода и заката на стартовом
class CityInformationWidget extends StatefulWidget {
  const CityInformationWidget({
    Key? key,
    required this.city,
    required this.sunrise,
    required this.sunset,
  }) : super(key: key);

  final String city;
  final String sunset;
  final String sunrise;

  @override
  _CityInformationWidgetState createState() => _CityInformationWidgetState();
}

class _CityInformationWidgetState extends State<CityInformationWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: const []),
      Text(widget.city.toUpperCase(),
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text('Sunrise',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 5),
              Text(widget.sunrise,
                  style: const TextStyle(fontSize: 15, color: Colors.white))
            ],
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              const Text('Sunset',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 5),
              Text(widget.sunset,
                  style: const TextStyle(fontSize: 15, color: Colors.white))
            ],
          ),
        ],
      ),
    ]);
  }
}
