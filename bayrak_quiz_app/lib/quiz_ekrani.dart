import 'dart:collection';
import '../bayraklardao.dart';
import '../sonuc_ekrani.dart';
import 'package:flutter/material.dart';
import 'bayraklar.dart';

class QuizEkrani extends StatefulWidget {
  const QuizEkrani({Key? key}) : super(key: key);

  @override
  State<QuizEkrani> createState() => _QuizEkraniState();
}

class _QuizEkraniState extends State<QuizEkrani> {
  var sorular = <Bayraklar>[];
  var yanlisSecenekler = <Bayraklar>[];
  late Bayraklar dogruSoru; // hangi bayrak doğru soru ?
  // 4 seçenek var, Hashset yerlerini otomatik karıştırıyor
  var tumSecenekler = HashSet<Bayraklar>();
  int soruSayac = 0;
  int dogruSayac = 0;
  int yanlisSayac = 0;
  // varsayılan resim değeri
  String bayrakResimAdi = "placeholder.png";
  String buttonAYazi = "";
  String buttonBYazi = "";
  String buttonCYazi = "";
  String buttonDYazi = "";

  @override
  void initState() {
    super.initState();
    // sayfa açılınca soruları alıyoruz
    sorulariAl();
  }

  Future<void> sorulariAl() async {
    sorular = await Bayraklardao().rasgele5Getir();
    soruYukle();
  }

  // soruları ara yüze yükleyelim
  Future<void> soruYukle() async {
    // önce doğru soru
    dogruSoru = sorular[soruSayac];
    bayrakResimAdi = dogruSoru.bayrakResim;
    // 3 yanlış seçenek
    yanlisSecenekler =
        await Bayraklardao().rasgele3YanlisGetir(dogruSoru.bayrakId);
    tumSecenekler.clear();
    tumSecenekler.add(dogruSoru);
    tumSecenekler.add(yanlisSecenekler[0]);
    tumSecenekler.add(yanlisSecenekler[1]);
    tumSecenekler.add(yanlisSecenekler[2]);
    // 1 doğru ve 3 seçenek butonların üzerine rasgele yazılacak
    buttonAYazi = tumSecenekler.elementAt(0).bayrakAd;
    buttonBYazi = tumSecenekler.elementAt(1).bayrakAd;
    buttonCYazi = tumSecenekler.elementAt(2).bayrakAd;
    buttonDYazi = tumSecenekler.elementAt(3).bayrakAd;
    setState(() {
      // ara yüz güncellenir
    });
  }

  // sayaç kontrolü
  void soruSayacKontrol() {
    soruSayac = soruSayac + 1;
    if (soruSayac != 5) {
      soruYukle();
    } else {
      // sorular bitti
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SonucEkrani(
            dogruSayisi: dogruSayac,
          ),
        ),
      );
    }
  }

  // Doğru kontrolü
  void dogruKontrol(String buttonYazi) {
    if (dogruSoru.bayrakAd == buttonYazi) {
      dogruSayac = dogruSayac + 1;
    } else {
      yanlisSayac = yanlisSayac + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Ekranı"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Doğru : $dogruSayac",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Yanlış : $yanlisSayac",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            soruSayac != 5
                ? Text(
                    "${soruSayac + 1}. Soru",
                    style: const TextStyle(fontSize: 30),
                  )
                : const Text(
                    "5. Soru",
                    style: TextStyle(fontSize: 30),
                  ),
            Image.asset("resimler/$bayrakResimAdi"),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                child: Text(buttonAYazi),
                onPressed: () {
                  // doğru kontrolü
                  dogruKontrol(buttonAYazi);
                  soruSayacKontrol();
                },
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                child: Text(buttonBYazi),
                onPressed: () {
                  // doğru kontrolü
                  dogruKontrol(buttonBYazi);
                  soruSayacKontrol();
                },
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                child: Text(buttonCYazi),
                onPressed: () {
                  // doğru kontrolü
                  dogruKontrol(buttonCYazi);
                  soruSayacKontrol();
                },
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                child: Text(buttonDYazi),
                onPressed: () {
                  // doğru kontrolü
                  dogruKontrol(buttonDYazi);
                  soruSayacKontrol();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}









