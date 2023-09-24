import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../screens/location_screen.dart';
import '../services/weather.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    try {
      var data = await WeatherModel().getLocationWeather();
      var weatherData = data["weatherData"];
      var cityData = data["cityData"];
      var temperature = weatherData["current"]["temp"];
      print("Temperature (loading_screen.dart) ==> $temperature");

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LocationScreen(
                locationWeather: weatherData,
                locationCity: cityData.toString(),
              );
            },
          ),
        );
      }
    } catch (e) {
      print("*** HATA *** : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
