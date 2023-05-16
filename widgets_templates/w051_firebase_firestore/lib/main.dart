import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Iskele(),
    );
  }
}

class Iskele extends StatefulWidget {
  const Iskele({Key? key}) : super(key: key);

  @override
  State<Iskele> createState() => _IskeleState();
}

class _IskeleState extends State<Iskele> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";

  // Veri ekleme
  yaziEkle() {
    // şablon oluşturduk
    FirebaseFirestore.instance
        .collection("Yazilar") // hangi koleksiyon ?
        .doc(t1.text) // hangi belge ?
        .set({"baslik": t1.text, "icerik": t2.text}); // eklenecek veri
  }

  // Veri günceleme
  yaziGuncelle() {
    // şablon oluşturduk
    FirebaseFirestore.instance
        .collection("Yazilar") // hangi koleksiyon ?
        .doc(t1.text) // hangi belge ?
        .update({"baslik": t1.text, "icerik": t2.text}); // Güncellenecek veri
  }

  // Veri silme
  yaziSil() {
    // şablon oluşturduk
    FirebaseFirestore.instance
        .collection("Yazilar") // hangi koleksiyon ?
        .doc(t1.text) // hangi belge ?
        .delete(); // Silinecek veri
  }

  yaziGetir() {
    // şablon oluşturduk
    FirebaseFirestore.instance
        .collection("Yazilar") // hangi koleksiyon ?
        .doc(t1.text) // hangi belge ?
        .get().then((gelenVeri){
          setState(() {
            gelenYaziBasligi = gelenVeri.data()!["baslik"];
            gelenYaziIcerigi = gelenVeri.data()!["icerik"];
          });
    }); // Silinecek veri
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(50),
        child: Center(
            child: Column(
          children: [
            TextField(
              controller: t1,
            ),
            TextField(
              controller: t2,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: yaziEkle,
                  child: const Text("Ekle"),
                ),
                ElevatedButton(
                  onPressed: yaziGuncelle,
                  child: const Text("Güncelle"),
                ),
                ElevatedButton(
                  onPressed: yaziSil,
                  child: const Text("Sil"),
                ),
                ElevatedButton(
                  onPressed: yaziGetir,
                  child: const Text("Getir"),
                ),
              ],
            ),
            ListTile(
              title: Text(gelenYaziBasligi),
              subtitle: Text(gelenYaziIcerigi),
            ),
          ],
        )),
      ),
    );
  }
}
