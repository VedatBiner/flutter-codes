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
        primarySwatch: Colors.red,
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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Başlık",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            Text(
              "Alt Başlık",
              style: TextStyle(
                color: Colors.lightGreenAccent,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        centerTitle: false,
        leading: IconButton(
          tooltip: "Uzun basarsak görünür",
          icon: const Icon(Icons.dehaze),
          onPressed: () {
            log("menü ikonu tıklandı");
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Çıkış",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              log("Çıkış tıklandı");
            },
          ),
          IconButton(
            tooltip: "Bilgi",
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              log("bilgi tıklandı");
            },
          ),
          PopupMenuButton(
            child: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text("Sil"),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text("Güncelle"),
              ),
            ],
            onSelected: (menuItemValue){
              if(menuItemValue == 1){
                log("Sil tıklandı");
              }
              if(menuItemValue == 2){
                log("Güncelle tıklandı");
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
