import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/Kategoriler.dart';
import '../screens/filmler_sayfa.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  // referans noktası
  var refKategoriler = FirebaseDatabase.instance.ref().child("kategoriler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategoriler"),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refKategoriler.onValue,
        builder: (context, event){
          if(event.hasData){
            var kategoriListesi = <Kategoriler>[];
            var gelenDegerler = event.data!.snapshot.value as dynamic;
            if (gelenDegerler != null){
              gelenDegerler.forEach((key, nesne){
                var gelenKategori = Kategoriler.fromJson(key, nesne);
                kategoriListesi.add(gelenKategori);
              });
            }
            return ListView.builder(
              itemCount: kategoriListesi.length,
              itemBuilder: (context,indeks){
                var kategori = kategoriListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FilmlerSayfa(kategori: kategori,)));
                  },
                  child: Card(
                    child: SizedBox(height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(kategori.kategori_ad),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }else{
            return const Center();
          }
        },
      ),

    );
  }
}
