import 'dart:developer';
import 'package:flutter/material.dart';
import '../Filmler.dart';
import '../Filmlerdao.dart';

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

  Future<void> goster() async {
    var liste = await Filmlerdao().tumFilmler();

    for(Filmler f in liste){
      log("******************");
      log("Film id : ${f.film_id}");
      log("Film ad : ${f.film_ad}");
      log("Film yıl : ${f.film_yil}");
      log("Film resim : ${f.film_resim}");
      log("Film kategori : ${f.kategori.kategori_ad}");
      log("Film yönetmen : ${f.yonetmen.yonetmen_ad}");
    }
  }

  @override
  void initState() {
    super.initState();
    goster();
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
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
