import 'dart:math';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // animasyon controller nesnesi
  late AnimationController animasyonKontrol;

  // late Animation<double> alphaAnimasyonDegerleri;
  late Animation<double> translateAnimasyonDegerleri;
  late Animation<double> scaleAnimasyonDegerleri;

  // açılışta çalışacak
  // animasyon kontrolü burada oluşacak
  @override
  void initState() {
    super.initState();
    // animasyon kontrol nesnesi
    animasyonKontrol = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    // alpha değerleri için 0 - 1 aralığı veriliyor
    // scale için istediğimiz değer verilebilir.
    translateAnimasyonDegerleri = Tween(begin: 0.0, end: 60.0).animate(
      CurvedAnimation(
        parent: animasyonKontrol,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
    scaleAnimasyonDegerleri =
        Tween(begin: 36.0, end: 50.0).animate(animasyonKontrol)
          ..addListener(() {
            setState(() {});
          });
  }

  // sayfa arka plana gidince çalışacak metot
  // animasyon durdurulacak
  @override
  void dispose() {
    super.dispose();
    animasyonKontrol.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.wb_cloudy,
              color: Colors.white,
              size: 128,
            ),
            Transform.translate(
              offset: Offset(0.0, translateAnimasyonDegerleri.value),
              child: Text(
                "Hava Durumu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: scaleAnimasyonDegerleri.value,
                ),
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  animasyonKontrol.repeat(reverse: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  "Başla",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




