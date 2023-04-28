import 'package:flutter/material.dart';
import 'package:sertifikalar_app/screens/sertifika_ekle.dart';
import 'package:sertifikalar_app/screens/sertifika_listesi.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sertifikalarım"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SertifikaListesi(),
                  ),
                );
              },
              child: const Text("Sertifika Listele"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SertifikaEkle(),
                  ),
                );
              },
              child: const Text("Sertifika Ekle"),
            ),
          ],
        ),
      ),
    );
  }
}
