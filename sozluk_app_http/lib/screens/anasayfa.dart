import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sozluk_app/models/kelimeler_cevap.dart';
import '../models/kelimeler.dart';
import '../screens/detaysayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  // parse metodu
  List<Kelimeler> parseKelimlerCevap(String cevap) {
    return KelimelerCevap.fromJson(json.decode(cevap)).kelimelerListesi;
  }

  // tüm listeyi görelim
  // sadece okuma olduğu için GET metodu kullanılıyor
  Future<List<Kelimeler>> tumKelimelerGoster() async {
    var url = Uri.parse(
      "http://kasimadalan.pe.hu/sozluk/tum_kelimeler.php",
    );
    var cevap = await http.get(url);
    return parseKelimlerCevap(cevap.body);
  }

  // arama işlemi yapalım
  // veri gönderildiği için POST metodu kullanılıyor
  Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async {
    var url = Uri.parse(
      "http://kasimadalan.pe.hu/sozluk/kelime_ara.php",
    );
    var veri = {"ingilizce": aramaKelimesi};
    var cevap = await http.post(url, body: veri);
    return parseKelimlerCevap(cevap.body);
  }

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
      body: FutureBuilder<List<Kelimeler>>(
        future: aramaYapiliyorMu
            ? aramaYap(aramaKelimesi)
            : tumKelimelerGoster(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var kelimelerListesi = snapshot.data;
            return ListView.builder(
              itemCount: kelimelerListesi!.length,
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







