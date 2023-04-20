import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/Providers/weather_provider.dart';
import 'Constants/constants.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  bool showWeather = false;

  @override
  void dispose() {
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Container(
            alignment: Alignment.center,
            child: Text(
              'Current Weather',
              textAlign: TextAlign.center,
            )),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Latitude and Longitude textfield
            Container(
                width: screenSize.width,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _latController,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _longController,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 16),
            // Elevated buttons for "Fetch Weather"
            ElevatedButton(
              onPressed: (_latController.text == null ||
                          _longController.text == null) ||
                      (_latController.text.isEmpty ||
                          _longController.text.isEmpty)
                  ? showsnackbar
                  : _getCurrentWeather,
              child: Text(
                'Fetch Weather',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "OR",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            //Elevated buttons for "Use Current Location"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: _getCurrentLocation,
              child: Text('Use Current Location',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 16),
            // Weather Container
            showWeather == true
                ? Consumer(
                    builder: (context, watch, child) {
                      final weather = watch(weatherProvider);
                      return weather.when(
                        data: (data) => Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Center(
                                  child: const Icon(Icons.location_on),
                                ),
                                Text(
                                  data.location,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${data.temp.toStringAsFixed(1)}\u00B0',
                                  style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  data.description,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 16),
                              ],
                            )),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Text('Error: $error'),
                        ),
                      );
                    },
                  )
                : Container()
          ],
        ),
      )),
    );
  }

//Fetch current location by using Geolocator
  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permissions are denied';
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (mounted)
      setState(() {
        final latitude = position.latitude;
        final lngtitude = position.longitude;
        _latController.text = latitude.toString();
        _longController.text = lngtitude.toString();
        lat = latitude.toString();
        longitude = lngtitude.toString();
      });
    context.read(weatherProvider.notifier);
  }

// Fetch current weather status with latitude and longitude
  void _getCurrentWeather() async {
    if (mounted)
      setState(() {
        lat = _latController.text;
        longitude = _longController.text;
        if ((_latController.text.isNotEmpty) &&
            (_latController.text.isNotEmpty)) {
          context.read(weatherProvider.notifier);
          showWeather = true;
          context.refresh(weatherProvider.notifier);
        } else {
          showWeather = false;
          showsnackbar();
        }
      });
  }

// SnackBar Function to show invalid coordinates
  void showsnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Invalid coordinates',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ));
  }
}
