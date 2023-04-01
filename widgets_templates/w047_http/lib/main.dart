import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:w00x_http/kisiler_cevap.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // parse metodu
  List<Kisiler> parseKisilerCevap(String cevap) {
    return KisilerCevap.fromJson(json.decode(cevap)).kisilerListesi;
  }

  // web servisi çalıştıracak metot oluşturalım
  // tüm kişileri listeleme
  Future<List<Kisiler>> tumKisiler() async {
    // web servisi linki
    var url = Uri.parse(
      "http://kasimadalan.pe.hu/kisiler/tum_kisiler.php",
    );
    // web servis cevabını alalım
    // sadece okuma olduğu için get kullanıyoruz
    var cevap = await http.get(url);
    return parseKisilerCevap(cevap.body);
  }

  // web servisi çalıştıracak metot oluşturalım
  // arama metodu
  Future<List<Kisiler>> kisilerAra(String aramaKelimesi) async {
    // web servisi linki
    var url = Uri.parse(
      "http://kasimadalan.pe.hu/kisiler/tum_kisiler_arama.php",
    );
    // veri gönderelim. Veriler String olmalıdır.
    var veri = {"kisi_ad": aramaKelimesi};
    // web servis cevabını alalım
    // veri gönderme olduğu için post kullanıyoruz
    var cevap = await http.post(url, body: veri);
    return parseKisilerCevap(cevap.body);
  }

  // web servisi çalıştıracak metot oluşturalım
  // silme metodu
  Future<void> kisiSil(int kisi_id) async {
    // web servisi linki
    var url = Uri.parse(
      "http://kasimadalan.pe.hu/kisiler/delete_kisiler.php",
    );
    // veri gönderelim. Veriler String olmalıdır.
    var veri = {"kisi_id": kisi_id.toString()};
    // web servis cevabını alalım
    // veri silme (yazma) olduğu için post kullanıyoruz
    var cevap = await http.post(url, body: veri);
    log("Silme Cevap : ${cevap.body}");
  }

  // web servisi çalıştıracak metot oluşturalım
  // ekleme metodu
  Future<void> kisiEkle(String kisi_ad, String kisi_tel) async {
    // web servisi linki
    var url = Uri.parse(
      "http://kasimadalan.pe.hu/kisiler/insert_kisiler.php",
    );
    // veri gönderelim. Veriler String olmalıdır.
    // Burada hem ad hem de tel verisi gönderiyoruz.
    var veri = {
      "kisi_ad": kisi_ad,
      "kisi_tel": kisi_tel,
    };
    // web servis cevabını alalım
    // veri ekleme (yazma) olduğu için post kullanıyoruz
    var cevap = await http.post(url, body: veri);
    log("Ekle Cevap : ${cevap.body}");
  }

  // web servisi çalıştıracak metot oluşturalım
  // güncelleme metodu
  Future<void> kisiGuncelle(int kisi_id, String kisi_ad, String kisi_tel) async {
    // web servisi linki
    var url = Uri.parse(
      "http://kasimadalan.pe.hu/kisiler/update_kisiler.php",
    );
    // veri gönderelim. Veriler String olmalıdır.
    // Burada hem ad hem de tel hem de id verisi gönderiyoruz.
    var veri = {
      "kisi_id": kisi_id.toString(),
      "kisi_ad": kisi_ad,
      "kisi_tel": kisi_tel,
    };
    // web servis cevabını alalım
    // veri ekleme (yazma) olduğu için post kullanıyoruz
    var cevap = await http.post(url, body: veri);
    log("Güncelle Cevap : ${cevap.body}");
  }

  // ara yüzde gösterecek metot
  Future<void> kisileriGoster() async {
    // bilgiler parse edilip alınıyor
    var liste = await tumKisiler();
    for (var k in liste) {
      log("******************************");
      log("Kişi id : ${k.kisi_id}");
      log("Kişi ad : ${k.kisi_ad}");
      log("Kişi ad : ${k.kisi_tel}");
    }
  }

  // ara yüzde aramayı gösterecek metot
  Future<void> kisileriAra() async {
    // bilgiler parse edilip alınıyor
    var liste = await kisilerAra("a");
    for (var k in liste) {
      log("******************************");
      log("Kişi id : ${k.kisi_id}");
      log("Kişi ad : ${k.kisi_ad}");
      log("Kişi ad : ${k.kisi_tel}");
    }
  }

  // ilk açılışta çalıştıralım
  @override
  void initState() {
    super.initState();
    // kisileriGoster();
    // kisileriAra();
    // kisiSil(14636);
    // kisiEkle("test kişi", "test tel");
    kisiGuncelle(14639, "Abuzer Kadayıf", "1234567");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Http Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
