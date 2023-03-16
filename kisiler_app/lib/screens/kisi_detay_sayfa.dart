import 'package:flutter/material.dart';
import '../utilities/kisilerdao.dart';
import '../models/kisiler.dart';
import '../screens/anasayfa.dart';

class KisiDetaySayfa extends StatefulWidget {
  Kisiler kisi;
  KisiDetaySayfa({super.key, required this.kisi});

  @override
  State<KisiDetaySayfa> createState() => _KisiDetaySayfaState();
}

class _KisiDetaySayfaState extends State<KisiDetaySayfa> {
  // text editing controllers oluşturalım
  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();

  // Kişi güncelleme metodu
  Future<void> guncelle(int kisiId, String kisiAd, String kisiTel) async {
    await Kisilerdao().kisiGuncelle(kisiId, kisiAd, kisiTel);
    // kayıt sonrası ana sayfaya geçiş
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Anasayfa(),
        ),
      );
    }
  }

  // açılışta çalışacak metod
  @override
  void initState() {
    super.initState();
    var kisi = widget.kisi;
    tfKisiAdi.text = kisi.kisiAd;
    tfKisiTel.text = kisi.kisiTel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kişi Detay Sayfası"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfKisiAdi,
                decoration: const InputDecoration(
                  hintText: "Kişi Adı",
                ),
              ),
              TextField(
                controller: tfKisiTel,
                decoration: const InputDecoration(
                  hintText: "Kişi Telefonu",
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          guncelle(widget.kisi.kisiId, tfKisiAdi.text, tfKisiTel.text);
        },
        tooltip: 'Kişi Güncelle',
        icon: const Icon(Icons.update),
        label: const Text("Güncelle"),
      ),
    );
  }
}
