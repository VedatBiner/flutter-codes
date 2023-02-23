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
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: "İlham Ver"),
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
  @override
  Widget build(BuildContext context) {
    var ekranbilgisi = MediaQuery.of(context);
    final ekranYuksekligi = ekranbilgisi.size.height;
    final ekranGenisligi = ekranbilgisi.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: ekranYuksekligi / 100,
                bottom: ekranGenisligi / 100,
            ),
            child: SizedBox(
              width: ekranGenisligi / 4,
              height: ekranYuksekligi / 3,
              child: Image.asset(
                "resimler/stevejobs-circular.jpg",
              ),
            ),
          ),
          Text(
            "Steve Jobs",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: ekranGenisligi / 25,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
              left: ekranGenisligi / 100,
              right: ekranYuksekligi / 100,
            ),
            child: Text(
              "Dünyayı değiştirecek insanlar, onu değiştirebileceklerini "
              "düşünecek kadar çılgın olanlardır.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ekranGenisligi / 30,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: ekranYuksekligi / 100),
            child: SizedBox(
              width: ekranGenisligi / 2,
              height: ekranGenisligi / 15,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  log("İlham verildi");
                },
                child: const Text("İlham Ver"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}













