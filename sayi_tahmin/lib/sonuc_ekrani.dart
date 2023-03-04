import 'package:flutter/material.dart';

class SonucEkrani extends StatefulWidget {
  bool sonuc;
  SonucEkrani({super.key, required this.sonuc});

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.sonuc
                  ? Image.asset("resimler/mutlu.jpg")
                  : Image.asset("resimler/uzgun.jpg"),
            ),
            Text(
              widget.sonuc ? "Kazandınız" : "Kaybettiniz",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 36,
              ),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                child: const Text("Tekrar dene"),
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





















