import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  var tfGirdi = TextEditingController();

  // veri yazma metodu
  Future<void> veriYaz() async {
    // önce dosya sistemine erişelim
    var ad = await getApplicationDocumentsDirectory();
    // dosya yolunu alalım
    var uygulamadosyalamayolu = await ad.path;
    // dosya adı
    var dosya = File("$uygulamadosyalamayolu/dosyam.txt");
    // dosyaya kayıt yapalım
    dosya.writeAsString(tfGirdi.text);
    // textfield alanını boşaltıyoruz
    tfGirdi.text = "";
  }

  // veri okuma metodu
  Future<void> veriOku() async {
    // dosyadan okuma yapalım
    try {
      // önce dosya sistemine erişelim
      var ad = await getApplicationDocumentsDirectory();
      // dosya yolunu alalım
      var uygulamadosyalamayolu = await ad.path;
      // dosya adı
      var dosya = File("$uygulamadosyalamayolu/dosyam.txt");
      // hata olmaması için bekleterek okuyoruz
      String okunanVeri = await dosya.readAsString();
      // veriyi aktarıyoruz
      tfGirdi.text = okunanVeri;
    } catch(e) {
      e.toString();
    }
  }

  // veri silme metodu
  Future<void> veriSil() async {
    // önce dosya sistemine erişelim
    var ad = await getApplicationDocumentsDirectory();
    // dosya yolunu alalım
    var uygulamadosyalamayolu = await ad.path;
    // dosya adı
    var dosya = File("$uygulamadosyalamayolu/dosyam.txt");
    // dosya varsa silinecek
    if (dosya.existsSync()) {
      dosya.delete();
    }
    tfGirdi.text = "";
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: tfGirdi,
                decoration: const InputDecoration(
                  hintText: "Veri giriniz",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    veriYaz();
                  },
                  child: const Text("Yaz"),
                ),
                ElevatedButton(
                  onPressed: () {
                    veriOku();
                  },
                  child: const Text("Oku"),
                ),
                ElevatedButton(
                  onPressed: () {
                    veriSil();
                  },
                  child: const Text("Sil"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}











