import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/not_detay_sayfa.dart';
import '../screens/not_kayit_sayfa.dart';
import '../models/notlar.dart';
import '../utilities/notlardao.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  // Future özelliği olan bir metod içinde veri kümemizi
  // oluşturup liste olarak alacağız
  Future<List<Notlar>> tumNotlarGoster() async {
    var notlarListesi = await Notlardao().tumNotlar();
    return notlarListesi;
  }

  // Uygulamayı kapatalım
  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar üzerinde geri tuşu
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            uygulamayiKapat();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notlar Uygulaması",
              style: TextStyle(color: Colors.white,fontSize: 16,
              ),
            ),
            FutureBuilder(
              future: tumNotlarGoster(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var notlarListesi = snapshot.data;
                    double ortalama = 0.0;
                    if (notlarListesi!.isNotEmpty){
                      double toplam = 0.0;
                      for (var n in notlarListesi){
                        toplam = toplam + (n.not1 + n.not2) / 2;
                      }
                      ortalama = toplam / notlarListesi.length;
                    }
                    return Text(
                      "Ortalama : ${ortalama.toInt()}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    );
                  } else {
                    return const Text(
                      "Ortalama : 0",
                      style: TextStyle(color: Colors.white, fontSize: 14,),
                    );
                  }
                }
            )
          ],
        ),
      ),
      // içinde Notlar nesnesi olan bir liste gelecek
      body: WillPopScope(
        onWillPop: uygulamayiKapat,
        child: FutureBuilder<List<Notlar>>(
          // içinde notlar olan nesneyi getirelim
          future: tumNotlarGoster(),
          // metodunu sonucunu alacağız eğer boş gelirse,
          // boş sayfa çıkacaktır.
          // Eğer dolu ise, bilgiyi göstereceğiz.
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // liste geliyor
              var notlarListesi = snapshot.data;
              return ListView.builder(
                itemCount: notlarListesi!.length,
                itemBuilder: (context, index) {
                  var not = notlarListesi[index];
                  // satırların gösterilmesi
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotDetaySayfa(not: not,),
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
                              not.dersAdi,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              not.not1.toString(),
                            ),
                            Text(
                              not.not2.toString(),
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
              builder: (context) => const NotKayitSayfa(),
            ),
          );
        },
        tooltip: 'Not Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
