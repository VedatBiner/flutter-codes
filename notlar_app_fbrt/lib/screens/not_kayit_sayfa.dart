import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../screens/anasayfa.dart';

class NotKayitSayfa extends StatefulWidget {
  @override
  _NotKayitSayfaState createState() => _NotKayitSayfaState();
}

class _NotKayitSayfaState extends State<NotKayitSayfa> {

  var tfDersAdi = TextEditingController();
  var tfnot1 = TextEditingController();
  var tfnot2 = TextEditingController();
  // referans noktası
  var refNotlar = FirebaseDatabase.instance.ref().child("notlar");

  Future<void> kayit(String ders_adi,int not1,int not2) async {
    // kayıt için bir hashmap oluşturmak gerekiyor
    var bilgi = HashMap<String, dynamic>();
    bilgi["not_id"] = "";
    bilgi["ders_adi"] = ders_adi;
    bilgi["not1"] = not1;
    bilgi["not2"] = not2;
    refNotlar.push().set(bilgi);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Kayıt"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0,right: 50.0),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          kayit(tfDersAdi.text, int.parse(tfnot1.text), int.parse(tfnot2.text));
        },
        tooltip: 'Not Kayıt',
        icon: const Icon(Icons.save),
        label: const Text("Kaydet"),
      ),
    );
  }
}
