import 'package:riverpod/riverpod.dart';
import 'package:weather_app/Api/weather_api.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/Constants/constants.dart';
import 'package:weather_app/Model/weather_model.dart';

//Here's the implementation of the weather_provider.dart file with a StateNotifierProvider for managing the current weather state using the Dio package for API calls:

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService(Dio(), lat, longitude);
});

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, AsyncValue<Weather>>((ref) {
  return WeatherNotifier(ref.watch(weatherServiceProvider), lat, longitude);
});

class WeatherNotifier extends StateNotifier<AsyncValue<Weather>> {
  final WeatherService _weatherService;
  final latitude;
  final lngtitude;

  WeatherNotifier(this._weatherService, this.latitude, this.lngtitude)
      : super(const AsyncLoading()) {
    _getCurrentWeather();
  }

  Future<void> _getCurrentWeather() async {
    if (mounted) {
      try {
        final weather =
            await _weatherService.getCurrentWeather(latitude, lngtitude);
        state = AsyncData(weather);
      } catch (error) {
        state = AsyncError(error);
      }
    }
  }
}
