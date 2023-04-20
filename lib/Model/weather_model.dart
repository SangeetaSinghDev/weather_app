import 'package:flutter/material.dart';

class Weather {
  final String location;
  final double temp;
  final String description;
  final String icon;

  Weather(
      {@required this.location,
      @required this.temp,
      @required this.description,
      @required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = json['weather'][0] as Map<String, dynamic>;

    final location = json['name'] as String;
    final temp =
        (main['temp'] as num).toDouble() - 273.15; // convert Kelvin to Celsius
    final description = weather['description'] as String;
    final icon = weather['icon'] as String;

    return Weather(
        location: location, temp: temp, description: description, icon: icon);
  }
}
