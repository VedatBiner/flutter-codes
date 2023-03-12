import 'package:flutter/material.dart';

class SonucEkrani extends StatefulWidget {
  int dogruSayisi;
  SonucEkrani({super.key, required this.dogruSayisi});

  @override
  State<SonucEkrani> createState() => _SonucEkraniState();
}

class _SonucEkraniState extends State<SonucEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sonuç Ekranı"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${widget.dogruSayisi} Doğru ${5 - widget.dogruSayisi} Yanlış",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              "% ${(widget.dogruSayisi * 100) ~/ 5} Başarı",
              style: const TextStyle(fontSize: 30, color: Colors.pink),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                child: const Text("Tekrar Dene"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
