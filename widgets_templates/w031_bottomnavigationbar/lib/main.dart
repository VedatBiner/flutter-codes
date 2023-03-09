import 'package:flutter/material.dart';
import '../sayfa1.dart';
import '../sayfa2.dart';
import '../sayfa3.dart';

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
        primarySwatch: Colors.deepPurple,
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
  var sayfaListesi = [SayfaBir(), SayfaIki(), SayfaUc()];
  var secilenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: sayfaListesi[secilenIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_one),
            label: "Bir",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two),
            label: "İki",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3),
            label: "Üç",
          ),
        ],
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white,
        currentIndex: secilenIndex,
        onTap: (index){
          setState(() {
            secilenIndex = index;
          });
        },
      ),
    );
  }
}
