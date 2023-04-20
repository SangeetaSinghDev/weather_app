import 'package:dio/dio.dart';
import 'package:weather_app/Constants/constants.dart';
import 'package:weather_app/Model/weather_model.dart';

class WeatherService {
  static const String _baseUrl = baseUrl;

  final Dio _dio;
  final lat;
  final lng;
  WeatherService(this._dio, this.lat, this.lng);

  Future<Weather> getCurrentWeather(final lat, final lng) async {
    final response = await _dio.get(_baseUrl,
        queryParameters: {'lat': lat, 'lon': lng, 'appid': apiKey});
    if (response.statusCode == 200) {
      return Weather.fromJson(response.data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
