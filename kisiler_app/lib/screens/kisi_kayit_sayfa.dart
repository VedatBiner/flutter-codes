import 'package:flutter/material.dart';
import '../utilities/kisilerdao.dart';
import '../screens/anasayfa.dart';

class KisiKayitSayfa extends StatefulWidget {
  const KisiKayitSayfa({Key? key}) : super(key: key);

  @override
  State<KisiKayitSayfa> createState() => _KisiKayitSayfaState();
}

class _KisiKayitSayfaState extends State<KisiKayitSayfa> {
  // text editing controllers oluşturalım
  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();

  // Kişi kayıt metodu
  Future<void> kayit(String kisiAd, String kisiTel) async {
    await Kisilerdao().kisiEkle(kisiAd, kisiTel);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kişi Kayıt Sayfası"),
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
          kayit(tfKisiAdi.text, tfKisiTel.text);
        },
        tooltip: 'Kişi Kayıt',
        icon: const Icon(Icons.save),
        label: const Text("Kaydet"),
      ),
    );
  }
}
