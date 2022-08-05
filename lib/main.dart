import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/repository.dart';
import 'core/utils/di/initialize_dependency.dart';
import 'logic/cubit/weather_cubit.dart';
import 'ui/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependency();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // todo понять почему не работает дебагмодчекере (пишут, что создатели
        // todo либы должны привести в соответствие с новой версией флаттера 3.0.1)
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) =>
                    WeatherCubit(injector.get<AbstractRepository>()),
              ),
            ],
            child: const MaterialApp(
              title: 'Weather App for Friflex test',
              home: HomePage(),
            )));
  }
}
