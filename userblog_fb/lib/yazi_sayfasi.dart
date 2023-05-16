import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YaziEkrani extends StatefulWidget {
  const YaziEkrani({Key? key}) : super(key: key);

  @override
  State<YaziEkrani> createState() => _YaziEkraniState();
}

class _YaziEkraniState extends State<YaziEkrani> {
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
      appBar: AppBar(title: const Text("Yazı Ekranı"),),
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