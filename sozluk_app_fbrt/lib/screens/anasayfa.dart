import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/kelimeler.dart';
import '../screens/detay_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";
  // referans noktası
  var refKelimeler = FirebaseDatabase.instance.ref().child("kelimeler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
                decoration:
                    const InputDecoration(hintText: "Arama için bir şey yazın"),
                onChanged: (aramaSonucu) {
                  log("Arama sonucu : $aramaSonucu");
                  setState(() {
                    aramaKelimesi = aramaSonucu;
                  });
                },
              )
            : const Text("Sözlük Uygulaması"),
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
      body: StreamBuilder<DatabaseEvent>(
        // Firebase 'de FutureBuilder yerine StreamBuilder kullanılıyor
        stream: refKelimeler.onValue,
        builder: (context, event) {
          if (event.hasData) {
            // Eğer veri varsa ...
            var kelimelerListesi = <Kelimeler>[];
            var gelenDegerler = event.data!.snapshot.value as dynamic;
            if (gelenDegerler != null) {
              gelenDegerler.forEach((key, nesne) {
                var gelenKelime = Kelimeler.fromJson(key, nesne);
                if (aramaYapiliyorMu){
                  if (gelenKelime.ingilizce.contains(aramaKelimesi)){
                    kelimelerListesi.add(gelenKelime);
                  }
                } else {
                  kelimelerListesi.add(gelenKelime);
                }
              });
            }
            return ListView.builder(
              itemCount: kelimelerListesi.length,
              itemBuilder: (context, indeks) {
                var kelime = kelimelerListesi[indeks];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetaySayfa(
                                  kelime: kelime,
                                )));
                  },
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            kelime.ingilizce,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(kelime.turkce),
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
    );
  }
}
