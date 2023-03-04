import 'dart:math';
import 'package:flutter/material.dart';
import '../sonuc_ekrani.dart';

class TahminEkrani extends StatefulWidget {
  const TahminEkrani({Key? key}) : super(key: key);

  @override
  State<TahminEkrani> createState() => _TahminEkraniState();
}

class _TahminEkraniState extends State<TahminEkrani> {

  // TextField üzerinden alınacak veri kontrolü
  var tfTahmin = TextEditingController();
  int kalanHak = 5; // Toplam hak sayısı
  int rasgeleSayi = 0 ; // üretilecek sayı
  String yonlendirme = ""; // tahmin yönlendirmesi

  @override
  void initState() {
    // ilk açılışta 0 - 100 arası rasgele sayı üret
    super.initState();
    rasgeleSayi = Random().nextInt(101);
    print("Rasgele sayı : $rasgeleSayi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tahmin Ekranı"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Kalan Hak : $kalanHak",
              style: const TextStyle(
                color: Colors.pink,
                fontSize: 30,
              ),
            ),
            Text(
              "Yardım : $yonlendirme",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 24,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: tfTahmin,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: "Tahmin",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Tahmin Et"),
                onPressed: (){
                  setState(() {
                    // her tahminde hakkımız 1 azalıyor
                    kalanHak = kalanHak - 1 ;
                  });
                  int tahmin = int.parse(tfTahmin.text);

                  if (tahmin == rasgeleSayi){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SonucEkrani(sonuc: true)));
                    return; // butonun çalışmasını durduruyor
                  }

                  // tahmin büyük
                  if (tahmin > rasgeleSayi){
                    setState(() {
                      yonlendirme = "Tahmini azalt";
                    });
                  }

                  // tahmin küçük
                  if (tahmin < rasgeleSayi){
                    setState(() {
                      yonlendirme = "Tahmini arttır";
                    });
                  }

                  // Tüm haklarımız bitti, sonuç sayfasına git
                  if (kalanHak == 0){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SonucEkrani(sonuc: false,)));
                  }

                  tfTahmin.text = ""; // bir sonraki tahmin için temizle

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

























