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
  @override
  Widget build(BuildContext context) {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranbilgisi.size.height;
    final double ekranGenisligi = ekranbilgisi.size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: ekranYuksekligi / 20,
                ),
                child: SizedBox(
                  width: ekranGenisligi / 4,
                  height: ekranYuksekligi / 6,
                  child: Image.asset("resimler/home.png"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ekranYuksekligi / 30),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Kullanıcı Adı",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ekranYuksekligi / 30),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Şifre",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ekranYuksekligi / 30),
                child: SizedBox(
                  width: ekranGenisligi / 1.2,
                  height: ekranYuksekligi / 12,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      log("Giriş yapıldı");
                    },
                    child: Text(
                      "GİRİŞ YAP",
                      style: TextStyle(fontSize: ekranGenisligi / 25),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  log("Yardım seçildi");
                },
                child: Text(
                  "Yardım ?",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: ekranGenisligi / 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


















