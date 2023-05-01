import 'package:flutter/material.dart';
import 'package:sertifikalar_app/screens/sertifika_ekle.dart';
import 'package:sertifikalar_app/screens/sertifika_listesi.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  String resimAdi = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Sertifikalarım"),
      ),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/00-smurf.jpg",
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: 140,
          left: 10,
          child: ElevatedButton(
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
        ),
        Positioned(
          bottom: 200,
          left: 10,
          child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SertifikaEkle(),
              ),
            );
          },
          child: const Text("Sertifika Ekle"),
        ),),
      ]),
    );
  }
}
