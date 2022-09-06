import 'package:flutter/material.dart';
import 'package:open_weather_cubit/cubits/weather/weather_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_cubit/pages/search_page.dart';
import 'package:open_weather_cubit/widgets/error_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchWeather();
  // }

  // _fetchWeather() {
  //   context.read<WeatherCubit>().fetchWeather('london');
  // }

  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SearchPage();
                  },
                ),
              );
              print('city:$_city');
              if (_city != null) {
                context.read<WeatherCubit>().fetchWeather(_city!);
              }
            },
          )
        ],
      ),
      body: Center(
        child: _showWeather(),
      ),
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'select a city',
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        if (state.status == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return const Text(
            'select a city',
            style: TextStyle(fontSize: 20),
          );
        }

        return Center(
          child: Center(
            child: Text(
              state.weather.name,
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(
            context,
            state.error.errMsg,
          );
        }
      },
    );
  }
}
