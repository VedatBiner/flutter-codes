import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/Notlar.dart';
import '../screens/anasayfa.dart';

class NotDetaySayfa extends StatefulWidget {
  Notlar not;

  NotDetaySayfa({required this.not});

  @override
  _NotDetaySayfaState createState() => _NotDetaySayfaState();
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {
  var tfDersAdi = TextEditingController();
  var tfnot1 = TextEditingController();
  var tfnot2 = TextEditingController();
  // referans noktası
  var refNotlar = FirebaseDatabase.instance.ref().child("notlar");

  // silme metodu
  Future<void> sil(String not_id) async {
    refNotlar.child(not_id).remove();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Anasayfa(),
      ),
    );
  }

  // güncelleme metodu
  Future<void> guncelle(
    String not_id,
    String ders_adi,
    int not1,
    int not2,
  ) async {
    // kayıt için bir hashmap oluşturmak gerekiyor
    var bilgi = HashMap<String, dynamic>();
    bilgi["ders_adi"] = ders_adi;
    bilgi["not1"] = not1;
    bilgi["not2"] = not2;
    refNotlar.child(not_id).update(bilgi);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Anasayfa(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var not = widget.not;
    tfDersAdi.text = not.ders_adi;
    tfnot1.text = not.not1.toString();
    tfnot2.text = not.not2.toString();
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
              sil(widget.not.not_id);
            },
          ),
          TextButton(
            child: const Text(
              "Güncelle",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              guncelle(widget.not.not_id, tfDersAdi.text,
                  int.parse(tfnot1.text), int.parse(tfnot2.text));
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tfDersAdi,
                decoration: const InputDecoration(hintText: "Ders Adı"),
              ),
              TextField(
                controller: tfnot1,
                decoration: const InputDecoration(hintText: "1. Not"),
              ),
              TextField(
                controller: tfnot2,
                decoration: const InputDecoration(hintText: "2. Not"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
