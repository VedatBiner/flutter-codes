import 'package:flutter/material.dart';
import '../models/sertifikalar.dart';
import '../utilities/sertifikalardao.dart';
import 'anasayfa.dart';

class SertifikaDetay extends StatefulWidget {
  final Sertifikalar sertifika;
  const SertifikaDetay({Key? key, required this.sertifika}) : super(key: key);

  @override
  State<SertifikaDetay> createState() => _SertifikaDetayState();
}

class _SertifikaDetayState extends State<SertifikaDetay> {
  // text editing controllers oluşturalım
  var tfSertTarih = TextEditingController();
  var tfSertKurum = TextEditingController();
  var tfSertKonu = TextEditingController();
  var tfSertDetay = TextEditingController();
  var tfSertLink = TextEditingController();
  var tfSertResim = TextEditingController();

  // açılışta çalışacak metod
  @override
  void initState() {
    super.initState();
    var sertifika = widget.sertifika;
    tfSertTarih.text = sertifika.sertTarih;
    tfSertKurum.text = sertifika.sertKurum;
    tfSertKonu.text = sertifika.sertKonu;
    tfSertDetay.text = sertifika.sertDetay;
    tfSertLink.text = sertifika.sertLink;
    tfSertResim.text = sertifika.sertResim;
  }

  // Sertifika güncelleme metodu
  Future<void> guncelle(int sertId, String sertTarih, String sertKurum,
      String sertKonu, String sertDetay, String sertLink, String sertResim) async {
    await Sertifikalardao().sertfikaGuncelle(
        sertId, sertTarih, sertKurum, sertKonu, sertDetay, sertLink, sertResim);
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

  Future<void> sertGoruntule(sertifikaResim) async {
    await Image.asset(sertifikaResim);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sertifika Detay Sayfası"),
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Image.asset("/assets/images/${widget.sertifika.sertResim}");
                  });
                },
                child: const Text("Sertifika görüntüle"),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          guncelle(widget.sertifika.sertId, tfSertTarih.text, tfSertKurum.text,
              tfSertKonu.text, tfSertDetay.text, tfSertLink.text, tfSertResim.text);
        },
        tooltip: 'Sertifika Güncelle',
        icon: const Icon(Icons.update),
        label: const Text("Güncelle"),
      ),
    );
  }
}
