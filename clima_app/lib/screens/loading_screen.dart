import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/location.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocation();
    getData();
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    print("Latitude  : ${location.latitude}");
    print("Longitude : ${location.longitude}");
  }

  void getData() async {
    /// openweather API call
    String url =
        "https://api.openweathermap.org/data/3.0/onecall?lat=33.44&lon=-94.04&appid=0b2583d6a7f4e97dc266081c4d73a7b8";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      double temperature = decodedData["current"]["temp"];
      int condition = decodedData["current"]["weather"][0]["id"];
      String cityName = decodedData["name"];
      print(temperature);
      print(condition);
      print(cityName);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return const Scaffold(
      body: Center(),
    );
  }
}
