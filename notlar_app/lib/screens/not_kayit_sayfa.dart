import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notlar_app/utilities/notlardao.dart';
import '../screens/anasayfa.dart';

class NotKayitSayfa extends StatefulWidget {
  const NotKayitSayfa({Key? key}) : super(key: key);

  @override
  State<NotKayitSayfa> createState() => _NotKayitSayfaState();
}

class _NotKayitSayfaState extends State<NotKayitSayfa> {

  var tfDersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  // kayıt metodu
  Future<void> kayit(String dersAdi, int not1, int not2) async {
    await Notlardao().notEkle(dersAdi, not1, not2);
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Anasayfa(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Kayıt"),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          kayit(
            tfDersAdi.text,
            int.parse(tfNot1.text),
            int.parse(tfNot2.text),
          );
        },
        tooltip: 'Not Kayıt',
        icon: const Icon(Icons.save),
        label: const Text("Kaydet"),
      ),
    );
  }
}
