import 'package:flutter/material.dart';
import 'package:sayfa_gecis/kisiler.dart';
import 'package:sayfa_gecis/sayfaa.dart';

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
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                var kisi = Kisiler(isim: "Ahmet", yas: 18, boy: 1.78, bekarMi: true,);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SayfaA(kisi: kisi,),
                  ),
                );
              },
              child: const Text("Sayfa A'ya git"),
            ),
          ],
        ),
      ),
    );
  }
}
