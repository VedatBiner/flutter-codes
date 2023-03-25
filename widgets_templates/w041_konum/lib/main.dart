import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double enlem = 0.0;
  double boylam = 0.0;

  // enlem ve boylam bilgisi alan metod
  Future<void> konumBilgisiAl() async {
    // konum izni ile ilgili hata olursa
    // aşağıdaki iki satır izin almayı sağlıyor
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    var konum = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      enlem = konum.latitude;
      boylam = konum.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enlem : $enlem",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              "Boylam : $boylam",
              style: const TextStyle(fontSize: 30),
            ),
            TextButton(
              child: const Text("Konum bilgisi al"),
              onPressed: () {
                konumBilgisiAl();
                log("Enlem : $enlem");
                log("Boylam : $boylam");
              },
            ),
          ],
        ),
      ),
    );
  }
}
