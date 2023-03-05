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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: "Yazınız .."
              ),
            ),
            FloatingActionButton(
              onPressed: (){
                log("fab2 tıklandı");
              },
              tooltip: 'Fab2',
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: const Icon(Icons.print),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          log("fab1 tıklandı");
        },
        label: const Text("FAB"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.audiotrack),
      ),
    );
  }
}











