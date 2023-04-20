import 'package:weather_app/model/weather_data_current.dart';
import 'package:weather_app/model/weather_data_hourly.dart';
import 'package:weather_app/model/weatrher_data_daily.dart';

class WeatherData {

  final WeatherDataCurrent? current;
  final WeatherDataHourly? hourly;
  final WeatherDataDaily? daily;

  WeatherData([this.current, this.hourly, this.daily]);

  // function to fetch this values
  WeatherDataCurrent getCurrentWeather() => current!;
  WeatherDataHourly getHourlyWeather() => hourly!;
  WeatherDataDaily getDailyWeather() => daily!;
}

