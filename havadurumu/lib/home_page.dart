import 'dart:convert';
import 'package:flutter/material.dart';
import 'search_page.dart';
import '../widgets/daily_weater_card.dart';
import '../widgets/loading_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const String key =
    "2652716d8fe20797c348551d95e48ff3"; // normalde buraya key verilmez.

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "berlin";
  double? temperature; // null safety kullanıp, nullable değer verdik.
  var locationData;
  String code = "home";
  Position? devicePosition; // nullable, başlangıçta veri içermiyor.
  String? icon; // nullable olabilir.

  List<String> icons = [];
  List<double> temperatures = [];
  List<String> dates = [];

  Future<void> getLocationDataFromAPI() async {
    locationData = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric",
      ),
    );
    final locationDataParsed = jsonDecode(locationData.body);

    setState(() {
      temperature = locationDataParsed["main"]["temp"];
      location = locationDataParsed["name"];
      code = locationDataParsed["weather"].first["main"];
      icon = locationDataParsed["weather"].first["icon"];
    });
  }

  Future<void> getLocationDataFromAPIByLatLon() async {
    if (devicePosition != null) {
      locationData = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric",
        ),
      );
      final locationDataParsed = jsonDecode(locationData.body);

      setState(() {
        temperature = locationDataParsed["main"]["temp"];
        location = locationDataParsed["name"];
        code = locationDataParsed["weather"].first["main"];
        icon = locationDataParsed["weather"].first["icon"];
      });
    }
  }

  Future<void> getDevicePosition() async {
    devicePosition = await _determinePosition();
    print(devicePosition);
  }

  Future<void> getDailyForecastByLatLon() async {
    var forecastData = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric",
      ),
    );
    var forecastDataParsed = jsonDecode(forecastData.body);

    // listeleri boşaltalım
    temperatures.clear();
    icons.clear();
    dates.clear();

    setState(() {
      for (int i = 7; i < 40; i = i + 8) {
        temperatures.add(forecastDataParsed["list"][i]["main"]["temp"]);
        icons.add(forecastDataParsed["list"][i]["weather"][0]["icon"]);
        dates.add(forecastDataParsed["list"][i]["dt_txt"]);
      }
    });
  }

  Future<void> getDailyForecastByLocation() async {
    var forecastData = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$key&units=metric",
      ),
    );
    var forecastDataParsed = jsonDecode(forecastData.body);

    // listeleri boşaltalım
    temperatures.clear();
    icons.clear();
    dates.clear();

    setState(() {
      for (int i = 7; i < 40; i = i + 8) {
        temperatures.add(forecastDataParsed["list"][i]["main"]["temp"]);
        icons.add(forecastDataParsed["list"][i]["weather"][0]["icon"]);
        dates.add(forecastDataParsed["list"][i]["dt_txt"]);
      }
    });
  }

  void getInitialData() async {
    // her şeyden önce cihazın pozisyonunu alalım.
    await getDevicePosition();
    // LatLon bilgisini al
    await getLocationDataFromAPIByLatLon(); // current weather
    await getDailyForecastByLatLon(); // forecast for 5 days
  }

  @override
  void initState() {
    getInitialData();
    // location bilgisini al
    getLocationDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration containerDecoration = BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage("assets/$code.jpg"),
      ),
    );
    return SafeArea(
      child: Container(
        decoration: containerDecoration,
        //Eğer temperature null ise circularProgressIndicator göster
        child: (temperature == null ||
                devicePosition == null ||
                icons.isEmpty ||
                dates.isEmpty ||
                temperatures.isEmpty)
            ? const LoadingWidget()
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Image.network(
                            "http://openweathermap.org/img/wn/$icon@4x.png"),
                      ),
                      Text(
                        "$temperatureº C",
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 3,
                              offset: Offset(-3, 5),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 3,
                                  offset: Offset(-3, 5),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final selectedCity = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
                                ),
                              );
                              location = selectedCity;
                              getLocationDataFromAPI();
                              getDailyForecastByLocation();
                            },
                            icon: const Icon(
                              Icons.search,
                            ),
                          ),
                        ],
                      ),
                      buildWeatherCard(context),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildWeatherCard(BuildContext context) {
    List<DailyWeatherCard> cards = [];

    for (int i = 0; i < 5; i++) {
      cards.add(DailyWeatherCard(
          icon: icons[i], temperature: temperatures[i], date: dates[i]));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      // mevcut ekran genişliğinin %90 kadarına yayıl
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView(
        scrollDirection: Axis.horizontal, // hareket alanı
        children: cards,
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
