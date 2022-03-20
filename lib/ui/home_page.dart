import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_cubit_friflex_test_task/cubit/weather_cubit.dart';
import 'package:weather_app_cubit_friflex_test_task/models/forecast.dart';
import 'package:weather_app_cubit_friflex_test_task/models/weather.dart';
import '../main.dart';
import 'widgets/city_information_widget.dart';
import 'widgets/city_entry_widget.dart';
import 'widgets/daily_summary_widget.dart';
import 'widgets/gradient_container_widget.dart';
import 'widgets/indicator_widget.dart';
import 'widgets/last_update_widget.dart';
import 'widgets/weather_description_widget.dart';
import 'widgets/weather_summary_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<void>? _refreshCompleter;
  Forecast? _forecast;
  bool isSelectedDate = false;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  void searchCity() {
    isSelectedDate = false;
    _forecast = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade800,
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                isSelectedDate = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppView(),
                  ),
                );
              },
              label: const Text(
                'ANOTHER CITY',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.home,
                color: Colors.white,
                size: 24.0,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                buildShowModalBottomSheet(context);
              },
              label: const Text(
                '3 DAY FORECAST',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.list,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ],
        ),
        body: _buildGradientContainer(
            _forecast == null
                ? WeatherCondition.clear
                : _forecast!.current.condition,
            _forecast == null ? false : _forecast!.isDayTime,
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: RefreshIndicator(
                    color: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    onRefresh: () => refreshWeather(
                        (BlocProvider.of<WeatherCubit>(context).state
                                as WeatherLoaded)
                            .forecast),
                    child: ListView(children: <Widget>[
                      BlocBuilder<WeatherCubit, WeatherState>(
                          builder: (context, state) {
                        if (state is WeatherInitial) {
                          return buildMessageText(state.message);
                        } else if (state is WeatherLoading) {
                          return const IndicatorWidget();
                        } else if (state is WeatherLoaded) {
                          if (!isSelectedDate) {
                            _forecast = state.forecast;
                          }
                          return buildColumnWithData();
                        } else if (state is WeatherError) {
                          return buildMessageText(state.message);
                        } else {
                          return const IndicatorWidget();
                        }
                      }),
                      CityEntryWidget(callBackFunction: searchCity),
                    ])))));
  }

  Widget buildMessageText(String message) {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Center(
            child: Text(message,
                style: const TextStyle(fontSize: 21, color: Colors.white))));
  }

  Widget buildColumnWithData() {
    return Column(children: [
      const SizedBox(height: 40),
      // виджет выводит  название города время восхода и заката на стартовом
      CityInformationWidget(
        city: _forecast!.city,
        sunrise: _forecast!.sunrise,
        sunset: _forecast!.sunset,
      ),
      const SizedBox(height: 40),
      // виджет выводит дату, ясность, температуру, чувствуется как
      WeatherSummaryWidget(
          date: _forecast!.date,
          condition: _forecast!.current.condition,
          temp: _forecast!.current.temp,
          feelsLike: _forecast!.current.feelLikeTemp),
      const SizedBox(height: 20),
      // вывод видимость, чистое небо там и все такое
      WeatherDescriptionWidget(
          weatherDescription: _forecast!.current.description),
      const SizedBox(height: 40),
      // выводит, когда был запрос
      LastUpdatedWidget(lastUpdatedOn: _forecast!.lastUpdated)
    ]);
  }

// виджет 3-х дневного форкаста
  Widget buildDailySummary(List<Weather> dailyForecast) {
    dailyForecast.sort(
      (a, b) => a.temp.compareTo(b.temp),
    );
    // если понадобится отсортировать от большего к меньшему (перевернуть лист)
    // dailyForecast = dailyForecast.reversed.toList();

    return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: dailyForecast.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    isSelectedDate = true;
                    _forecast!.date = dailyForecast[index].date;
                    _forecast!.sunrise = dailyForecast[index].sunrise;
                    _forecast!.sunset = dailyForecast[index].sunset;
                    _forecast!.current = dailyForecast[index];
                    _refreshCompleter?.complete();
                    _refreshCompleter = Completer();
                    refreshWeather(_forecast!);
                  },
                  child:
                      // виджет 3-х дневного форкаста
                      DailySummaryWidget(weather: dailyForecast[index]));
            }));
  }

  Future<void> refreshWeather(Forecast forecast) {
    if (isSelectedDate) {
      setState(() {
        _forecast = forecast;
      });
      return _refreshCompleter!.future;
    } else {
      return BlocProvider.of<WeatherCubit>(context).getWeather(forecast.city);
    }
  }

// меняет цвет бекграунда, в зависимости по модельке WeatherCondition в weather.dart
  /// работает нестабильно, надо поправить, если не забуду
  GradientContainerWidget _buildGradientContainer(
      WeatherCondition condition, bool isDayTime, Widget child) {
    GradientContainerWidget container;
    if (!isDayTime) {
      container = GradientContainerWidget(color: Colors.blueGrey, child: child);
    } else {
      switch (condition) {
        case WeatherCondition.clear:
        case WeatherCondition.lightCloud:
          container =
              GradientContainerWidget(color: Colors.yellow, child: child);
          break;
        case WeatherCondition.rain:
        case WeatherCondition.drizzle:
        case WeatherCondition.mist:
        case WeatherCondition.heavyCloud:
          container =
              GradientContainerWidget(color: Colors.indigo, child: child);
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

// модальное окно, мой чит, чтобы не делать второй экран =)
  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blueGrey.shade800,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.97,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade800,
        ),
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade800,
          appBar: AppBar(
            foregroundColor: Colors.blueGrey.shade800,
            backgroundColor: Colors.blueGrey.shade800,
            title: const Text(
              '3 DAY FORECAST',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(0))),
            toolbarHeight: 70,
            elevation: 10,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // кьюбит погоды
                BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                  if (state is WeatherInitial) {
                    // выводим сообщение
                    return buildMessageText(state.message);
                  } else if (state is WeatherLoading) {
                    // выводим индикатор загрузки - Пожалуйста, подождите
                    return const IndicatorWidget();
                    // иначе выводим
                  } else if (state is WeatherLoaded) {
                    if (!isSelectedDate) {
                      _forecast = state.forecast;
                    }
                    return buildDailySummary(_forecast!.daily);
                  } else if (state is WeatherError) {
                    return buildMessageText(state.message);
                  } else {
                    return const IndicatorWidget();
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
