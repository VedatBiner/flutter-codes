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

  var sayfaListe = [const SayfaBir(), const SayfaIki(), const SayfaUc()];
  int secilenIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: sayfaListe[secilenIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                "Başlık Tasarımı",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            ListTile(
              title: const Text("Sayfa 1"),
              onTap: (){
                setState(() {
                  secilenIndex = 0;
                });
                Navigator.pop(context); // drawer kapat
              },
            ),
            ListTile(
              title: const Text(
                "Sayfa 2",
                style: TextStyle(color: Colors.red),
              ),
              onTap: (){
                setState(() {
                  secilenIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Sayfa 3"),
              leading: const Icon(
                Icons.looks_3,
                color: Colors.orange,),
              onTap: (){
                setState(() {
                  secilenIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}










