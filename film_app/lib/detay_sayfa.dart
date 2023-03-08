import 'dart:developer';
import 'package:flutter/material.dart';
import 'filmler.dart';

class DetaySayfa extends StatefulWidget {
  Filmler film;

  DetaySayfa({required this.film});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.film.filmAdi),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("resimler/${widget.film.filmResimAdi}"),
            Text(
              "${widget.film.filmFiat} \u{20BA}",
              style: const TextStyle(
                fontSize: 48,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Kirala",
                ),
                onPressed: () {
                  log("${widget.film.filmAdi} kiralandı");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

















