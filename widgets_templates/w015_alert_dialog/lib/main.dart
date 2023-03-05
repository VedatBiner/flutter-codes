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
  var tfControl = TextEditingController();
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
            ElevatedButton(
              child: const Text("Basit Alert"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Başlık"),
                      content: const Text("İçerik"),
                      actions: [
                        TextButton(
                          child: const Text("İptal"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text("Tamam"),
                          onPressed: () {
                            log("Tamam seçildi");
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              child: const Text("Özel Alert"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Özel Alert",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.indigoAccent,
                      content: SizedBox(
                        height: 80,
                        child: Column(
                          children: [
                            TextField(
                              controller: tfControl,
                              decoration: const InputDecoration(
                                labelText: "Veri",
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text(
                            "İptal",
                            style: TextStyle(
                              color: Colors.yellowAccent,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Veri Oku",
                            style: TextStyle(
                              color: Colors.yellowAccent,
                            ),
                          ),
                          onPressed: () {
                            String alinanVeri = tfControl.text;
                            log("Veri Okundu : $alinanVeri");
                            tfControl.text = "";
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
