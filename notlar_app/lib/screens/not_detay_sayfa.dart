import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notlar_app/utilities/notlardao.dart';
import '../models/notlar.dart';
import 'anasayfa.dart';

class NotDetaySayfa extends StatefulWidget {
  // veri transferi için değişken ve constructor
  Notlar not;
  NotDetaySayfa({super.key, required this.not});

  @override
  State<NotDetaySayfa> createState() => _NotDetaySayfaState();
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {
  var tfDersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  // silme metodu
  Future<void> sil(int notId) async {
    await Notlardao().notSil(notId);
    if (context.mounted){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Anasayfa(),
        ),
      );
    }
  }

  // güncelleme metodu
  Future<void> guncelle(int notId, String dersAdi, int not1, int not2) async {
    await Notlardao().notGuncelle(notId, dersAdi, not1, not2);
    if (context.mounted){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Anasayfa(),
        ),
      );
    }
  }

  // sayfa açılınca bilgileri TextField içinde gösterelim.
  @override
  void initState() {
    super.initState();
    var not = widget.not;
    tfDersAdi.text = not.dersAdi;
    tfNot1.text = not.not1.toString();
    tfNot2.text = not.not2.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Detay"),
        actions: [
          TextButton(
            child: const Text(
              "Sil",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              sil(widget.not.notId);
            },
          ),
          TextButton(
            child: const Text(
              "Güncelle",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              guncelle(
                widget.not.notId,
                tfDersAdi.text,
                int.parse(tfNot1.text),
                int.parse(tfNot2.text),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfDersAdi,
                decoration: const InputDecoration(hintText: "Ders Adı"),
              ),
              TextField(
                controller: tfNot1,
                decoration: const InputDecoration(hintText: "1. Not"),
              ),
              TextField(
                controller: tfNot2,
                decoration: const InputDecoration(hintText: "2. Not"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
