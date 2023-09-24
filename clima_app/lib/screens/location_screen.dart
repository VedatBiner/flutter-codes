/// bu kodlarda bir null dönüşü var bulamıyorum

import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import '../services/weather.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    Key? key,
    this.locationWeather,
    this.locationCity,
  });
  final locationWeather;
  final locationCity;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int? temperature = 0;
  String? weatherIcon;
  String? cityName;
  String? weatherMessage;

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    var weatherData = await weather.getLocationWeather();
    updateUI(weatherData, widget.locationCity);
  }

  void updateUI(dynamic weatherData, dynamic locationCity) {
    if (weatherData != null &&
        locationCity != null &&
        weatherData["weatherData"] != null) {
      setState(() {
        var currentWeather = weatherData["weatherData"];
        temperature = (currentWeather['current']['temp']).toInt(); // temperature 'ı burada tanımlayın
        var condition = currentWeather["current"]["weather"][0]["id"];
        cityName = locationCity;
        weatherMessage = weather.getMessage(temperature ?? 0);
        weatherIcon = weather.getWeatherIcon(condition);

        print("*** location_screen.dart set state bölümüne geldik. ***");
        print("**************************************************************");
        print("Location city (location_screen.dart) ===> $locationCity");
        print("temperature (location_screen.dart) ===> $temperature");
        print("Condition (location_screen.dart) ===> $condition");
        print("Weather Icon (location_screen.dart) ==> $weatherIcon");
        print("Weather Message (location_screen.dart) ===> $weatherMessage");
        print("**************************************************************");
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
              'assets/images/location_background.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      getLocationData();
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${temperature ?? 0}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
