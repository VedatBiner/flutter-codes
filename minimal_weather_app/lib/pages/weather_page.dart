// ---------- weather_page.dart ----------
import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  /// API Key
  final _weatherService = WeatherService("9cb4837e8d48dff13f206af1cd41c342");
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

  @override
  void initState() {
    super.initState();

    /// fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
