import 'dart:developer';
import 'package:flutter/material.dart';

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
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Yemek Tarifi'),
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
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: ekranGenisligi,
              child: Image.asset("resimler/yemek.jpg"),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: ekranGenisligi / 8,
                    child: TextButton(
                      onPressed: () {
                        log("Beğenildi");
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                      ),
                      child: Yazi("Beğen", ekranGenisligi / 25),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: ekranGenisligi / 8,
                    child: TextButton(
                      onPressed: () {
                        log("Yorum Yapıldı");
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        foregroundColor: Colors.black,
                      ),
                      child: Yazi("Yorum Yap", ekranGenisligi / 25),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(ekranYuksekligi / 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Köfte",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: ekranGenisligi / 20,
                    ),
                  ),
                  Row(
                    children: [
                      Yazi("Izgara Üzerinde Pişirime Uygun", ekranGenisligi / 25),
                      Spacer(),
                      Yazi("8 Ağustos", ekranGenisligi / 25),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ekranYuksekligi / 100),
              child: Yazi("Köfte harcı 5 dk güzelce yoğurulur ve streç filme sarılıp, 10 dk kadar buzdolabında bekletilir."
                "O arada patatesler soyulup, doğranır ve kurulanıp, önceden ısıttığımız kızgın yağa koyarak pişirilir."
                "Patates piştikten sonra da, köfteler pişirilir."
                "Notlar:"
                "Baharat miktarlarını, tercihinize göre ayarlayabilirsiniz. Ben 1 çay kaşığı olarak yaptım."
                "İlk önce patatesleri kızartalım, yoksa kararma olur.", ekranGenisligi / 25),
            ),
          ],
        ),
      ),
    );
  }
}

class Yazi extends StatelessWidget {
  String icerik;
  double yaziBoyut;

  Yazi(this.icerik, this.yaziBoyut, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      icerik,
      style: TextStyle(
        fontSize: yaziBoyut,
      ),
    );
  }
}
