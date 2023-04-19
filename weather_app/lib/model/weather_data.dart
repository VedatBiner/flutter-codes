import 'package:weather_app/model/weather_data_current.dart';

class WeatherData {

  final WeatherDataCurrent? current;

  WeatherData([this.current]);

  // function to fetch this values
  WeatherDataCurrent getCurrentWeather() => current!;
}