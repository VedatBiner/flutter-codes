import 'package:flutter/material.dart';
import '../models/filmler.dart';

class DetaySayfa extends StatefulWidget {
  Filmler film;

  DetaySayfa({super.key, required this.film});

  @override
  _DetaySayfaState createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.film.film_ad),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset("assets/images/${widget.film.film_resim}"),
            Text(
              widget.film.film_yil.toString(),
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              widget.film.yonetmen.yonetmen_ad,
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
