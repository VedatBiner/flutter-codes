import 'dart:developer';
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
  var ulkeler = ["Türkiye", "Almanya", "İtalya", "Fransa", "Rusya", "Çin"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 1,
        ),
        itemCount: ulkeler.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              log("Merhaba, ${ulkeler[index]}");
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        log("Text ile ${ulkeler[index]} seçildi");
                      },
                        child:   Text(ulkeler[index])),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        log("Button ile ${ulkeler[index]} seçildi");
                      },
                      child: const Text("Ülke Seç"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
