import 'package:weather_app/model/weather_data_current.dart';
import 'package:weather_app/model/weather_data_hourly.dart';

class WeatherData {

  final WeatherDataCurrent? current;
  final WeatherDataHourly? hourly;

  WeatherData([this.current, this.hourly]);

  // function to fetch this values
  WeatherDataCurrent getCurrentWeather() => current!;
  WeatherDataHourly getHourlyWeather() => hourly!;
}

