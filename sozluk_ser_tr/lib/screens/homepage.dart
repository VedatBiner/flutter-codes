import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/kelimeler.dart';
import '../utils/kelime_sil.dart';
import '../utils/kelimelerdao.dart';
import 'detail_page.dart';
import 'kelime_ekle.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  // Veri kümemizi oluşturalım
  Future<List<Kelimeler>> tumKelimelerGoster() async {
    var kelimelerListesi = await Kelimelerdao().tumKelimeler();
    return kelimelerListesi;
  }

  // arama yapalım
  Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async {
    var kelimelerListesi = await Kelimelerdao().kelimeAra(aramaKelimesi);
    return kelimelerListesi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
                decoration: const InputDecoration(
                  hintText: "Arama için bir şey yazın",
                ),
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
        // arama yapılıyorsa aranan kelimeler
        // arama yapılmıyorsa tüm kelimeler görünecek
        future:
            aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKelimelerGoster(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var kelimelerListesi = snapshot.data;
            // İngilizce kelimeye göre sıralama
            kelimelerListesi!
                .sort((a, b) => a.ingilizce.compareTo(b.ingilizce));
            return ListView.builder(
              itemCount: kelimelerListesi!.length,
              itemBuilder: (context, index) {
                var kelime = kelimelerListesi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          kelime: kelime,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                kelime.ingilizce,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                kelime.turkce,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              kelimeSil(context);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            tooltip: "kelime silinecektir",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            // veri gelmediyse boş bir tasarım göstersin
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KelimeEkle(),
            ),
          );
        },
        label: const Text('Kelime Ekle'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
