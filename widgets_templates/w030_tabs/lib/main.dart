import 'package:flutter/material.dart';
import 'package:w030_tabs/sayfa1.dart';
import 'package:w030_tabs/sayfa2.dart';
import 'package:w030_tabs/sayfa3.dart';

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
        primarySwatch: Colors.indigo,
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
    return DefaultTabController(
      length: 3, // tab sayısı
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Bir",
              ),
              Tab(
                icon: Icon(
                  Icons.looks_two,
                  color: Colors.cyanAccent,
                ),
              ),
              Tab(
                text: "Üç",
                icon: Icon(Icons.looks_3),
              ),
            ],
            indicatorColor: Colors.amber,
            labelColor: Colors.orange,
          ),
        ),
        body: const TabBarView(
          children: [
            Sayfa1(),
            Sayfa2(),
            Sayfa3(),
          ],
        ),
      ),
    );
  }
}
