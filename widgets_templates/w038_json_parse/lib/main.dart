import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'filmler.dart';
import 'kisiler_cevap.dart';
import 'filmler_cevap.dart';
import 'kisiler.dart';
import 'mesajlar.dart';

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

  void mesajParse() {
    String strVeri =
        '{ "mesajlar" : { "mesaj_kod" : 1,"mesaj_icerik" : "başarılı"  } }';
    var jsonVeri = json.decode(strVeri);
    var jsonNesne = jsonVeri["mesajlar"];
    var mesaj = Mesajlar.fromJson(jsonNesne);
    log("Mesaj kod : ${mesaj.mesaj_kod}");
    log("Mesaj içerik : ${mesaj.mesaj_icerik}");
  }

  void kisilerParse() {
    String strVeri =
        '{"kisiler":[{"kisi_id":"1","kisi_ad":"Ahmet","kisi_tel":"12312312"}'
        ',{"kisi_id":"2","kisi_ad":"Mehmet","kisi_tel":"912318212"}]}';
    // her içerik nesneye çevirilip, liste olarak gösterilecek.
    // json formatına dönüştürelim.
    var jsonVeri = jsonDecode(strVeri);
    // json array listesi elde edelim.
    var jsonArray = jsonVeri["kisiler"] as List;
    List<Kisiler> kisilerListesi = jsonArray
        .map((jsonArrayNesnesi) => Kisiler.fromJson(jsonArrayNesnesi))
        .toList();
    for (var k in kisilerListesi) {
      log("**********************");
      log("Kişi id : ${k.kisi_id}");
      log("Kişi ad : ${k.kisi_ad}");
      log("Kişi tel : ${k.kisi_tel}");
    }
  }

  void kisilerCevapParse() {
    String strVeri =
        '{"success":1,"kisiler":[{"kisi_id":"1","kisi_ad":"Ahmet","kisi_tel":"12312312"}'
        ',{"kisi_id":"2","kisi_ad":"Mehmet","kisi_tel":"912318212"}]}';
    // json formatına dönüştürme
    var jsonVeri = json.decode(strVeri);
    var kisilerCevap = KisilerCevap.fromJson(jsonVeri);
    log("Success: ${kisilerCevap.scuccess}");
    List<Kisiler> kisilerListesi = kisilerCevap.kisilerListesi;
    for (var k in kisilerListesi) {
      log("**********************");
      log("Kişi id : ${k.kisi_id}");
      log("Kişi ad : ${k.kisi_ad}");
      log("Kişi tel : ${k.kisi_tel}");
    }
  }

  void filmlerCevapParse(){
    String strVeri = '{"success":1,"filmler":[{"film_id":"1","film_ad":"Interstellar"'
        ',"film_yil":"2015","film_resim":"interstellar.png",'
        '"kategori":{"kategori_id":"4","kategori_ad":"Bilim Kurgu"},'
        '"yonetmen":{"yonetmen_id":"1","yonetmen_ad":"Christopher Nolan"}},'
        '{"film_id":"3","film_ad":"The Pianist","film_yil":"2002","film_resim":"thepianist.png",'
        '"kategori":{"kategori_id":"3","kategori_ad":"Drama"},'
        '"yonetmen":{"yonetmen_id":"4","yonetmen_ad":"Roman Polanski"}}]}';

    var jsonVeri = json.decode(strVeri);
    var filmlerCevap = FilmlerCevap.fromJson(jsonVeri);
    int success = filmlerCevap.success;
    List<Filmler> filmlerListesi = filmlerCevap.filmlerListesi;
    log("Success : $success");
    for (var f in filmlerListesi) {
      log("**********************");
      log("Film id : ${f.film_id}");
      log("Film ad : ${f.film_ad}");
      log("Film Yıl : ${f.film_yil}");
      log("Film Resim : ${f.film_resim}");
      log("Film Kategori : ${f.kategori.kategori_ad}");
      log("Film Yönetmen : ${f.yonetmen.yonetmen_ad}");
    }
  }

    @override
    void initState() {
      super.initState();
      // mesajParse();
      // kisilerParse();
      // kisilerCevapParse();
      filmlerCevapParse();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(),
      );
    }

}






