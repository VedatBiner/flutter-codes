import 'package:flutter/material.dart';
import 'package:w037_navigator/sayfab.dart';
import 'kisiler.dart';

class SayfaA extends StatefulWidget {

  Kisiler kisi;
  SayfaA({required this.kisi});

  @override
  State<SayfaA> createState() => _SayfaAState();
}

class _SayfaAState extends State<SayfaA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sayfa A"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SayfaB()));
              },
              child: const Text("Sayfa B'ye git"),
            ),
            Text("İsim : ${widget.kisi.isim}"),
            Text("Yaş : ${widget.kisi.yas}"),
            Text("Boy : ${widget.kisi.boy}"),
            Text("Bekar mı : ${widget.kisi.bekarMi}"),
          ],
        ),
      ),
    );
  }
}






