import 'dart:developer';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/kisiler.dart';
import '../screens/kisi_kayit_sayfa.dart';
import '../screens/kisi_detay_sayfa.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  // referans noktası
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler");

  Future<void> sil(String kisi_id) async {
    refKisiler.child("kisi_id").remove();
  }

  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            uygulamayiKapat();
          },
        ),
        title: aramaYapiliyorMu
            ? TextField(
                decoration: const InputDecoration(
                  hintText: "Arama için bir şey yazın",
                ),
                onChanged: (aramaSonucu) {
                  print("Arama sonucu : $aramaSonucu");
                  setState(() {
                    aramaKelimesi = aramaSonucu;
                  });
                },
              )
            : const Text("Kişiler Uygulaması"),
        actions: [
          aramaYapiliyorMu
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = false;
                      aramaKelimesi = "";
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = true;
                    });
                  },
                ),
        ],
      ),
      body: WillPopScope(
        onWillPop: uygulamayiKapat,
        child: StreamBuilder<DatabaseEvent>(
          // tabloda değişiklik olduğu anda
          // StreamBuilder yapısı ve onValue metodu
          // ile anında uygulamamıza yansıyacaktır.
          stream: refKisiler.onValue,
          builder: (context, event) {
            if (event.hasData) {
              var kisilerListesi = <Kisiler>[];
              var gelenDegerler = event.data!.snapshot.value as dynamic;
              if (gelenDegerler != null) {
                gelenDegerler.forEach((key, nesne) {
                  // kişileri teker teker aldık
                  var gelenKisi = Kisiler.fromJson(key, nesne);
                  // arama yapılıyor mu? (true)
                  if (aramaYapiliyorMu) {
                    if (gelenKisi.kisi_ad.contains(aramaKelimesi)) {
                      kisilerListesi.add(gelenKisi);
                    }
                  } else {
                    // alınan kişileri listeye ekliyoruz
                    kisilerListesi.add(gelenKisi);
                  }
                });
              }
              return ListView.builder(
                itemCount: kisilerListesi.length,
                itemBuilder: (context, indeks) {
                  var kisi = kisilerListesi[indeks];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KisiDetaySayfa(
                                    kisi: kisi,
                                  )));
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              kisi.kisi_ad,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(kisi.kisi_tel),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                sil(kisi.kisi_id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KisiKayitSayfa(),
            ),
          );
        },
        tooltip: 'Kişi Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
