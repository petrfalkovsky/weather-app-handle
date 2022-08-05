// ignore_for_file: library_private_types_in_public_api

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_cubit_friflex_test_task/cubit/weather_cubit.dart';

// виджет для формы ввода города
class CityEntryWidget extends StatefulWidget {
  const CityEntryWidget({Key? key, required this.callBackFunction})
      : super(key: key);

  final Function callBackFunction;

  @override
  _CityEntryWidgetState createState() => _CityEntryWidgetState();
}

class _CityEntryWidgetState extends State<CityEntryWidget> {
  late TextEditingController cityEditController;
  // isVisible убирает видимость некоторых виджетов после нажатия кнопки Confirm
  bool isVisible = true;
  bool notPressed = false;
  bool pressed = false;

  @override
  void initState() {
    super.initState();

    cityEditController = TextEditingController();
  }

  void submitCityName(BuildContext context, String cityName) {
    BlocProvider.of<WeatherCubit>(context).getWeather(cityName);
    widget.callBackFunction();
    cityEditController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isVisible)
          Container(
              margin: const EdgeInsets.only(left: 10, top: 15, right: 10),
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(3),
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        submitCityName(context, cityEditController.text);
                        setState(() => isVisible = !isVisible);
                      }),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                          controller: cityEditController,
                          decoration: const InputDecoration.collapsed(
                              hintText: "Enter City"),
                          onSubmitted: (String city) {
                            submitCityName(context, city);
                            setState(() => isVisible = !isVisible);
                          })),
                ],
              )),
        const SizedBox(height: 40),
        if (isVisible)
          ElevatedButton(
            onPressed: () {
              submitCityName(context, cityEditController.text);
              setState(() {
                isVisible = !isVisible;
                pressed = !pressed;
                notPressed = !notPressed;
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.grey,
              onPrimary: Colors.white,
              shadowColor: Colors.blueGrey,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              minimumSize: const Size(160, 40),
              maximumSize: const Size(180, 50),
            ),
            child: pressed
                ? const Text(
                    'Try another city') // кнопка изменит надпись, после нажатия,
                // будет видно, если фенукция if (isVisible) для этого блока
                // будет отключена
                : const Text('Confirm'),
          ),
        if (isVisible)
          // анимационная картинка на стартовом экране
          const SizedBox(
              height: 400,
              width: 400,
              child: FlareActor(
                "assets/images/WorldSpin.flr",
                fit: BoxFit.contain,
                animation: "roll",
              )),
      ],
    );
  }
}
