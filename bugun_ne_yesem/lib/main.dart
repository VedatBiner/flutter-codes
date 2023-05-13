import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const Uygulamam());
}

class Uygulamam extends StatelessWidget {
  const Uygulamam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Bugün Ne Yesem?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: YemekSayfasi(),
      ),
    );
  }
}

class YemekSayfasi extends StatefulWidget {
  const YemekSayfasi({Key? key}) : super(key: key);
  @override
  State<YemekSayfasi> createState() => _YemekSayfasiState();
}

class _YemekSayfasiState extends State<YemekSayfasi> {
  int corbaNo = 1;
  int yemekNo = 1;
  int tatliNo = 1;

  List<String> corbaAdlari = ["Tarhana Çorbası", "Domates Çorbası", "Mercimek Çorba", "Şehriye Çorbası", "Düğün Çorba"];
  List<String> yemekAdlari = ["Yaz Türlüsü", "Kuru Fasülye", "Et Haşlama", "Bolonez Soslu Spagetti", "Izgara Köfte"];
  List<String> tatliAdlari = ["Baklava", "Fırın Sütlaç", "Kazandibi", "Trileçe", "Güllaç"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: yemekDegistir,
                child: Image.asset(
                  "assets/images/corba_$corbaNo.jpg",
                ),
              ),
            ),
          ),
          Text(
            corbaAdlari[corbaNo-1],
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            width: 200,
            child: Divider(
              height: 5,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: yemekDegistir,
                child: Image.asset(
                  "assets/images/yemek_$yemekNo.jpg",
                ),
              ),
            ),
          ),
          Text(
            yemekAdlari[yemekNo-1],
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            width: 200,
            child: Divider(
              height: 5,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: yemekDegistir,
                child: Image.asset(
                  "assets/images/tatli_$tatliNo.jpg",
                ),
              ),
            ),
          ),
          Text(
            tatliAdlari[tatliNo-1],
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            width: 200,
            child: Divider(
              height: 5,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void yemekDegistir() {
    setState(() {
      corbaNo = Random().nextInt(5) + 1;
      yemekNo = Random().nextInt(5) + 1;
      tatliNo = Random().nextInt(5) + 1;
    });
  }

}
