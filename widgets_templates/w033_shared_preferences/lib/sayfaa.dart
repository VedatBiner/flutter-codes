import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SayfaA extends StatefulWidget {
  const SayfaA({Key? key}) : super(key: key);

  @override
  State<SayfaA> createState() => _SayfaAState();
}

class _SayfaAState extends State<SayfaA> {
  Future<void> veriOku() async {
    // burada shared preferences 'e ulaşmayı bekliyoruz
    // await ile bu yapının oluşmasını bekliyoruz
    var sp = await SharedPreferences.getInstance();
    // verileri okuyalım
    // ?? ile hata oluşursa "isim yok"  ada aktarılacak
    String ad = sp.getString("ad") ?? "isim yok";
    int yas = sp.getInt("yas") ?? 99;
    double boy = sp.getDouble("boy") ?? 9.99;
    bool bekarMi = sp.getBool("bekarMi") ?? false;
    // listeyi okuyalım. Varsayılna değer null
    var arkadasListe = sp.getStringList("arkadasListe") ?? null;
    log("Ad : $ad");
    log("Yaş : $yas");
    log("Boy : $boy");
    log("Bekar mı ?: $bekarMi");
    for (var a in arkadasListe!) {
      log("Arkadaş : $a");
    }
  }

  Future<void> veriSil() async {
    // burada shared preferences 'e ulaşmayı bekliyoruz
    // await ile bu yapının oluşmasını bekliyoruz
    var sp = await SharedPreferences.getInstance();
    // verileri silelim
    sp.remove("ad");
  }

  Future<void> veriGuncelle() async {
    // burada shared preferences 'e ulaşmayı bekliyoruz
    // await ile bu yapının oluşmasını bekliyoruz
    var sp = await SharedPreferences.getInstance();
    // verileri güncelleyelim
    sp.setInt("yas", 100);
  }

  // sayfaya geldiğimizde okuma yapsın
  @override
  void initState() {
    super.initState();
   // veriSil();
    veriGuncelle();
    veriOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Sayfa -A-"),
      ),
      body: const Center(),
    );
  }
}
