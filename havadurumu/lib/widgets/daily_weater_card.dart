import 'package:flutter/material.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard({Key? key, required this.icon, required this.temperature, required this.date}) : super(key: key);

  final String icon;
  final double temperature;
  final String date;

  @override
  Widget build(BuildContext context) {

    // text olarak gelen date objesini DateTime objesine parse edelim.
    DateTime parsedTime = DateTime.parse(date);
    parsedTime.weekday;
    List<String> weekdays = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"];

    return Card(
      color: Colors.transparent,
      child: SizedBox(
        height: 120,
        width: 100,
        child: Column(
          children: [
            Image.network(
              "http://openweathermap.org/img/wn/$icon.png",
            ),
            Text(
              "$temperatureº C",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              weekdays[parsedTime.weekday-1],
            ),
          ],
        ),
      ),
    );
  }
}
