import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../utilities/kisilerdao.dart';
import '../models/kisiler.dart';
import '../screens/kisi_kayit_sayfa.dart';
import '../screens/kisi_detay_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  // veri kümesini oluşturacak metod.
  // içinde Kisiler sınıfından nesneler olan liste
  // Tüm kişiler listeleyelim
  Future<List<Kisiler>> tumKisileriGoster() async {
    var kisilerListesi = await Kisilerdao().tumKisiler();
    return kisilerListesi;
  }

  // Arama metodu
  Future<List<Kisiler>> aramaYap(String aramaKelimesi) async {
    var kisilerListesi = await Kisilerdao().kisiArama(aramaKelimesi);
    return kisilerListesi;
  }

  // Kişi silme metodu
  Future<void> sil(kisiId) async {
    await Kisilerdao().kisiSil(kisiId);
    setState(() {
      // ara yüzü güncelleyelim
    });
  }

  // Uygulamadan çıkış metodu
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
                  hintText: "Arama için bir şey yazınız ...",
                ),
                onChanged: (aramaSonucu) {
                  log("Arama sonucu : $aramaSonucu");
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
        child: FutureBuilder<List<Kisiler>>(
          future:
              aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKisileriGoster(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var kisilerListesi = snapshot.data;
              return ListView.builder(
                itemCount: kisilerListesi!.length,
                itemBuilder: (context, index) {
                  var kisi = kisilerListesi[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KisiDetaySayfa(kisi: kisi),
                        ),
                      );
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              kisi.kisiAd,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(kisi.kisiTel),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                sil(kisi.kisiId);
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
              // veri gelmediyse boş bir tasarım göstersin
              return const Center(
                child: Text("*** HATA ***"),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KisiKayitSayfa(),
            ),
          );
        },
        tooltip: 'Kişi Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
