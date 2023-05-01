import 'package:flutter/material.dart';
import '../utilities/sertifikalardao.dart';
import 'anasayfa.dart';

class SertifikaEkle extends StatefulWidget {
  const SertifikaEkle({Key? key}) : super(key: key);

  @override
  State<SertifikaEkle> createState() => _SertifikaEkleState();
}

class _SertifikaEkleState extends State<SertifikaEkle> {
  // text editing controllers oluşturalım
  var tfSertTarih = TextEditingController();
  var tfSertKurum = TextEditingController();
  var tfSertKonu = TextEditingController();
  var tfSertDetay = TextEditingController();
  var tfSertLink = TextEditingController();
  var tfSertResim = TextEditingController();

  // sertifika kayıt metodu
  Future<void> kayit(String sertTarih, sertKurum, sertKonu, sertDetay, sertLink, sertResim) async {
    await Sertifikalardao().sertifikaEkle(sertTarih, sertKurum, sertKonu, sertDetay, sertLink, sertResim);
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
        title: const Text("Sertifika Ekleme Sayfası"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: tfSertTarih,
                decoration: const InputDecoration(hintText: "Sertifika tarihi"),
              ),
              TextField(
                controller: tfSertKurum,
                decoration: const InputDecoration(hintText: "Kuruluş Adı"),
              ),
              TextField(
                controller: tfSertKonu,
                decoration: const InputDecoration(hintText: "Eğitim Konusu"),
              ),
              TextField(
                controller: tfSertDetay,
                decoration: const InputDecoration(hintText: "Eğitim adı"),
              ),
              TextField(
                controller: tfSertLink,
                decoration: const InputDecoration(hintText: "Sertifika adresi"),
              ),
              TextField(
                controller: tfSertResim,
                decoration: const InputDecoration(hintText: "Sertifika resmi"),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            kayit(
              tfSertTarih.text,
              tfSertKurum.text,
              tfSertKonu.text,
              tfSertDetay.text,
              tfSertLink.text,
              tfSertResim.text,
            );
          },
          tooltip: 'Kişi Kayıt',
          icon: const Icon(Icons.save),
          label: const Text("Kaydet"),
        ),
      ),
    );
  }
}
