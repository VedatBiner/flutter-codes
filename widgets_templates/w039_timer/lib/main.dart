import 'dart:async';
import 'package:flutter/material.dart';

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
  late Timer zamanlayici;
  int kalanSure = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Kalan Süre : $kalanSure sn, ',
              style: const TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: () {
                zamanlayici = Timer.periodic(const Duration(seconds: 1), (timer) {
                  setState(() {
                    if (kalanSure < 1 ){
                      kalanSure = 10;
                      zamanlayici.cancel(); // timer dursun
                    } else {
                      kalanSure = kalanSure - 1;
                    }
                  });
                });
              },
              child: const Text("Başla"),
            ),
          ],
        ),
      ),
    );
  }
}
