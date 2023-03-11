import 'dart:developer';
import 'package:flutter/material.dart';
import '../kisilerdao.dart';
import 'kisiler.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // tumKisiler 'e erişelim
  Future<void> kisilerigoster() async {
    var liste = await Kisilerdao().tumKisiler();
    for (Kisiler k in liste){
      log("***************");
      log("Kişi Id : ${k.kisi_id}");
      log("Kişi Adı : ${k.kisi_ad}");
      log("Kişi Yaşı : ${k.kisi_yas}");
    }
  }

  // Kisi ekleyelim
  Future<void> ekle() async {
    // await Kisilerdao().kisiEkle("Sevim", 93);
    // await Kisilerdao().kisiEkle("Zeynep", 56);
    // await Kisilerdao().kisiEkle("Nilsu", 38);
    // await Kisilerdao().kisiEkle("Hazal", 34);
    await Kisilerdao().kisiEkle("Mehmet", 56);
  }

  // Kisi silelim
  Future<void> sil() async {
    await Kisilerdao().kisiSil(3);
  }

  // Kisi güncelleyelim
  Future<void> guncelle() async {
    await Kisilerdao().kisiGuncelle(2,"Nihan", 57);
  }

  // Kayıt kontrol
  Future<void> kayitKontrol() async {
    int sonuc = await Kisilerdao().kayitKontrol("Ahmet");
    log("Veri tabanında Ahmet sayısı : $sonuc");
  }

  // tek kişi getir
  Future<void> getir() async {
    var kisi = await Kisilerdao().kisiGetir(1);
    log("****** Kişi Getir *********");
    log("Kişi Id : ${kisi.kisi_id}");
    log("Kişi Adı : ${kisi.kisi_ad}");
    log("Kişi Yaşı : ${kisi.kisi_yas}");
  }

  // kişi ara
  Future<void> aramaYap() async {
    var liste = await Kisilerdao().kisiArama("e");
    for (Kisiler k in liste){
      log("******* Arama Sonucu ********");
      log("Kişi Id : ${k.kisi_id}");
      log("Kişi Adı : ${k.kisi_ad}");
      log("Kişi Yaşı : ${k.kisi_yas}");
    }
  }

  // rasgele ve limitli kişi ara
  Future<void> rasgele() async {
    var liste = await Kisilerdao().rasgeleKisiGetir();
    for (Kisiler k in liste){
      log("******* Arama Sonucu ********");
      log("Kişi Id : ${k.kisi_id}");
      log("Kişi Adı : ${k.kisi_ad}");
      log("Kişi Yaşı : ${k.kisi_yas}");
    }
  }

  // sayfa açılınca çalıştır
  @override
  void initState() {
    super.initState();
    ekle();
    // sil();
    // guncelle();
    // kayitKontrol();
    // getir();
    // aramaYap();
    // kisilerigoster();
    rasgele();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      ),
    );
  }
}
