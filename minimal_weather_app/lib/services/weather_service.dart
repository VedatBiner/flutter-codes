import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import "package:http/http.dart" as http;

import '../models/weather_model.dart';

class WeatherService {
  /// Orijinal koddaki API
  static const baseUrl = "http://api.openweathermap.org/data/2.5/weather";
  /// Yeni API kullandım
  /// static const baseUrl = "https://api.openweathermap.org/data/3.0/onecall";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl?q=$cityName&appid=$apiKey&units=metric",
      ),
    );
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  /// mevcut şehir
  Future<String> getCurrentCity() async {
    /// get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    /// fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    /// convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    /// extract the city name from the first placemark
    String? city = placemarks[0].administrativeArea;
    /// Eğer şehir boş ise boş başlık yaz
    return city ?? "";
  }
}
