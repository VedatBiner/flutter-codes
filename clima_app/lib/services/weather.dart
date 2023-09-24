import '../services/location.dart';
import '../services/networking.dart';

const apiKey = "9cb4837e8d48dff13f206af1cd41c342";
const openWeatherMapURL = "https://api.openweathermap.org/data/3.0/onecall";
const openWeatherMapCityURL = "http://api.openweathermap.org/geo/1.0/reverse";
const openWeatherMapCityNameURL =
    "http://api.openweathermap.org/geo/1.0/direct";

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    /// istediğimiz şehrin hava durumunu al
    NetworkHelper cityHelper = NetworkHelper(
      "openWeatherMapCityNameURL"
      "?q=$cityName"
      "&units=metric"
      "&appid=$apiKey",
    );
    var weatherData = await cityHelper.getData();
    return weatherData;
  }

  Future<Map<String, dynamic>> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    /// Bulunduğumuz lokasyonun hava durumunu al
    NetworkHelper networkHelper = NetworkHelper(
      "$openWeatherMapURL"
      "?lat=${location.latitude}"
      "&lon=${location.longitude}"
      "&units=metric"
      "&appid=$apiKey",
    );
    var weatherData = await networkHelper.getData();

    /// Bulunduğumuz lokasyonun şehir adını al
    NetworkHelper cityHelper = NetworkHelper(
      "$openWeatherMapCityURL"
      "?lat=${location.latitude}"
      "&lon=${location.longitude}"
      "&appid=$apiKey",
    );
    var cityData = await cityHelper.getData();
    var cityData2 = cityData[0]['name'];

    /// ******************************
    /// Ben ekledim
    print("latitude (weather.dart) ==> ${location.latitude}");
    print("longitude (weather.dart) ==> ${location.longitude}");

    /// ******************************

    return {
      "weatherData": weatherData,
      "cityData": cityData2,
    };
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
