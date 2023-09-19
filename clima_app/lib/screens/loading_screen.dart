import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/location.dart';
import '../services/networking.dart';
import '../screens/location_screen.dart';

const apiKey = "9cb4837e8d48dff13f206af1cd41c342";

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
    Location location = Location();
    await location.getCurrentLocation();

    /// Bulunduğumuz lokasyonun hava durumunu al
    NetworkHelper networkHelper = NetworkHelper(
      "https://api.openweathermap.org/data/3.0/onecall"
      "?lat=${location.latitude}"
      "&lon=${location.longitude}"
      "&units=metric"
      "&appid=$apiKey",
    );
    var weatherData = await networkHelper.getData();

    /// Bulunduğumuz lokasyonun şehir adını al
    NetworkHelper cityHelper = NetworkHelper(
      "http://api.openweathermap.org/geo/1.0/reverse"
      "?lat=${location.latitude}"
      "&lon=${location.longitude}"
      "&appid=$apiKey",
    );
    var cityData = await cityHelper.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        locationWeather: weatherData,
        locationCity: cityData,);
    }));
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
