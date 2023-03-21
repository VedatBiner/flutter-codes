import 'dart:collection';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Kisiler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

  // Başlığı kisiler_tablo olan bir tablo oluşturalım
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler_tablo");

  // kisi ekleme
  Future<void> kisiEkle()async {
    // key string olacak, ama girilecek veri türü değişebilir
    // bu nedenle dynamic oldu.
    var bilgi = HashMap<String, dynamic>();
    bilgi["kisi_ad"] = "Sevim";
    bilgi["kisi_yas"] = 94;
    // kayıt işlemi
    refKisiler.push().set(bilgi);
  }

  // kisi silme - key bilgisini bilmemiz gerekiyor.
  Future<void> kisiSil()async {
    // silmek istediğimiz key
    refKisiler.child("-NR3AT088ecYYD-Zz0jx").remove();
  }

  // kisi güncelleme - key bilgisini bilmemiz gerekiyor.
  Future<void> kisiGuncelle()async {
    // key string olacak, ama girilecek veri türü değişebilir
    // bu nedenle dynamic oldu.
    var guncelBilgi = HashMap<String, dynamic>();
    guncelBilgi["kisi_ad"] = "Hamit";
    guncelBilgi["kisi_yas"] = 80;
    // güncelleme işlemi
    refKisiler.child("-NR3AQMxCx3iHLBUX9nD").update(guncelBilgi);
  }

  // kisi okuma - Tüm kayıtları almak istiyoruz
  Future<void> tumKisiler()async {
    refKisiler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as dynamic;
      // boş değer gelirse çalışmayacak
      if (gelenDegerler != null){
        gelenDegerler.forEach((key, nesne){
          var gelenKisi = Kisiler.fromJson(nesne);
          log("*************************");
          log("Kişi Key : $key");
          log("Kişi ad : ${gelenKisi.kisi_ad}");
          log("Kişi yaş : ${gelenKisi.kisi_yas}");
        });
      }
    });
  }

  // kisi okuma - Tüm kayıtları almak istiyoruz
  // bir kere çalışacak
  Future<void> tumKisilerOnce()async {
    refKisiler.once().then((value) {
      var gelenDegerler = value.snapshot.value as dynamic;
      // boş değer gelirse çalışmayacak
      if (gelenDegerler != null){
        gelenDegerler.forEach((key, nesne){
          var gelenKisi = Kisiler.fromJson(nesne);
          log("*************************");
          log("Kişi Key : $key");
          log("Kişi ad : ${gelenKisi.kisi_ad}");
          log("Kişi yaş : ${gelenKisi.kisi_yas}");
        });
      }
    });
  }

  // Sorgulama - EqualTo
  Future<void> esitlikArama()async {
    var sorgu = refKisiler.orderByChild("kisi_ad").equalTo("Sevim");
    sorgu.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as dynamic;
      // boş değer gelirse çalışmayacak
      if (gelenDegerler != null){
        gelenDegerler.forEach((key, nesne){
          var gelenKisi = Kisiler.fromJson(nesne);
          log("*************************");
          log("Kişi Key : $key");
          log("Kişi ad : ${gelenKisi.kisi_ad}");
          log("Kişi yaş : ${gelenKisi.kisi_yas}");
        });
      }
    });
  }

  // Sorgulama - LimitToFirst
  Future<void> limitliVeri()async {
    var sorgu = refKisiler.limitToFirst(2);
    sorgu.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as dynamic;
      // boş değer gelirse çalışmayacak
      if (gelenDegerler != null){
        gelenDegerler.forEach((key, nesne){
          var gelenKisi = Kisiler.fromJson(nesne);
          log("*************************");
          log("Kişi Key : $key");
          log("Kişi ad : ${gelenKisi.kisi_ad}");
          log("Kişi yaş : ${gelenKisi.kisi_yas}");
        });
      }
    });
  }

  // Sorgulama - Değer Aralığı
  Future<void> degerAraligi() async {
    var sorgu = refKisiler.orderByChild("kisi_yas").startAt(18).endAt(45);
    sorgu.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as dynamic;
      // boş değer gelirse çalışmayacak
      if (gelenDegerler != null){
        gelenDegerler.forEach((key, nesne){
          var gelenKisi = Kisiler.fromJson(nesne);
          log("*************************");
          log("Kişi Key : $key");
          log("Kişi ad : ${gelenKisi.kisi_ad}");
          log("Kişi yaş : ${gelenKisi.kisi_yas}");
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // kisiEkle();
    // kisiSil();
    // kisiGuncelle();
    // tumKisiler();
    // tumKisilerOnce();
    // esitlikArama();
    // limitliVeri();
    degerAraligi();
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
