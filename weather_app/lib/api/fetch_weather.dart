import 'dart:convert';
import 'package:weather_app/model/weather_data_current.dart';
import 'package:weather_app/model/weather_data_hourly.dart';
import '../model/weather_data.dart';
import 'package:http/http.dart' as http;
import '../model/weather_data_daily.dart';
import '../utils/api_url.dart';

class FetchWeatherAPI {
  WeatherData? weatherData;

  // processing data from respond to json
  Future<WeatherData> processData(lat, lon) async {
    var reponse = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(reponse.body);
    weatherData = WeatherData(
      WeatherDataCurrent.fromJson(jsonString),
      WeatherDataHourly.fromJson(jsonString),
      WeatherDataDaily.fromJson(jsonString),
    );
    return weatherData!;
  }
}
