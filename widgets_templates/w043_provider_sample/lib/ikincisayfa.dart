import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sayac_model.dart';

class IkinciSayfa extends StatelessWidget {
  const IkinciSayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İkinci Sayfa"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // dinleme yapacağımız widget
            Consumer<SayacModel>(
              builder: (context, sayacModelNesne, child){
                // dinleme gerçekleşince son değeri oku
                return Text(
                  "${sayacModelNesne.sayaciOku()}",
                  style: const TextStyle(fontSize: 26),
                );
              },
            ),
            // tetikleme işlemi
            Consumer<SayacModel>(
              builder: (context, sayacModelNesne, child){
                // dinleme gerçekleşince son değeri oku
                return ElevatedButton(
                  onPressed: () {
                    sayacModelNesne.sayaciArttir();
                  },
                  child: const Text("Sayaç Arttır"),
                );
              },
            ),
            // tetikleme işlemi
            Consumer<SayacModel>(
              builder: (context, sayacModelNesne, child){
                // dinleme gerçekleşince son değeri oku
                return  ElevatedButton(
                  onPressed: () {
                    sayacModelNesne.sayaciAzalt(2);
                  },
                  child: const Text("Sayaç Azalt"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
