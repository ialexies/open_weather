import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_weather_cubit/models/ccustom_error.dart';
import 'package:open_weather_cubit/models/direct_geocoding.dart';
import 'package:open_weather_cubit/models/weather.dart';
import 'package:open_weather_cubit/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRerpository weatherRerpository;

  WeatherCubit({required this.weatherRerpository})
      : super(WeatherState.initial());

  Future<void> fetchWeather(String city) async {
    try {
      /// Todo(ialexies): "Get Geocoding"
      final Weather weather = await weatherRerpository.fetchWeather(city);
      emit(
        state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
        ),
      );
      print('state: $state');
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          status: WeatherStatus.error,
          error: e,
        ),
      );
        print('state: $state');
    }
  }
}
