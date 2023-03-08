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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.sunny),
            title: const Text("Güneş"),
            subtitle: const Text("Güneş Alt başlık"),
            trailing: const Icon(Icons.arrow_right),
            onTap: (){
              log("Güneş tıklandı");
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_2),
            title: const Text("Ay"),
            subtitle: const Text("Ay Alt başlık"),
            trailing: const Icon(Icons.arrow_right),
            onTap: (){
              log("Ay tıklandı");
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text("Yıldız"),
            subtitle: const Text("Yıldız Alt başlık"),
            trailing: const Icon(Icons.arrow_right),
            onTap: (){
              log("Yıldız tıklandı");
            },
          ),
        ],
      ),
    );
  }
}
