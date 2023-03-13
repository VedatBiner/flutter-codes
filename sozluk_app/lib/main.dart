import 'dart:developer';
import 'package:flutter/material.dart';
import '../kelimelerdao.dart';
import 'detaysayfa.dart';
import 'kelimeler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  // Veri kümemizi oluşturalım
  Future<List<Kelimeler>> tumKelimelerGoster() async {
    var kelimelerListesi = await Kelimlerdao().tumKelimeler();
    return kelimelerListesi;
  }

  // arama yapalım
  Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async {
    var kelimelerListesi = await Kelimlerdao().kelimeAra(aramaKelimesi);
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
        future:  aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKelimelerGoster(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var kelimelerListesi = snapshot.data;
            return ListView.builder(
              itemCount: kelimelerListesi!.length,
              itemBuilder: (context, index) {
                var kelime = kelimelerListesi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetaySayfa(
                          kelime: kelime,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            kelime.ingilizce,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
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
            // veri gelmediyse boş bir tasarım göstersin
            return const Center(
              child: Text("*** HATA ***"),
            );
          }
        },
      ),
    );
  }
}
