// ---------- weather_page.dart ----------
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  /// API Key
  final _weatherService = WeatherService("your_API Key");
  Weather? _weather;

  /// Fetch weather
  _fetchWeather() async {
    /// Get current city
    String cityName = await _weatherService.getCurrentCity();

    /// Get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  /// Weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return "assets/animations/clear_sky.json";
    }
    switch (mainCondition.toLowerCase()) {
      case "clouds":
        return "assets/animations/partly_cloudy.json";
      case "mist":
        return "assets/animations/windy.json";
      case "sunny":
        return "assets/animations/sunny.json";
      case "rain":
        return "assts/animations/storm.json";
      case "snow":
        return "assts/animations/snow.json";
      case "mist":
        return "assts/animations/mist.json";
      default:
        return "assets/animations/sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();

    /// fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// City Name
            Text(
              _weather?.cityName ?? "Loading City ...",
              style: const TextStyle(color: Colors.white),
            ),

            /// Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            /// Temperature
            Text(
              "${_weather?.temperature.round()} °C",
              style: const TextStyle(color: Colors.white),
            ),

            /// Weather condition
            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}







