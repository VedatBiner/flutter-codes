import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sayfa_gecis/main.dart';

class SayfaB extends StatefulWidget {
  const SayfaB({Key? key}) : super(key: key);

  @override
  State<SayfaB> createState() => _SayfaBState();
}

class _SayfaBState extends State<SayfaB> {

  Future<bool> geriDonusTusu(BuildContext context)async{
    log("Geri tuşu tıklandı");
    return true; // geri dönmesi istenmiyorsa false olmalı
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sayfa B"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            log("Appbar geri tuşu tıklandı");
            // Ana sayfaya dönüş
            Navigator.push(context, MaterialPageRoute(builder: (context) => AnaSayfa()));
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () => geriDonusTusu(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // sayfayı kaldırıp, bir önceki sayfaya geçiyor
                  Navigator.pop(context);
                },
                child: const Text("Geldiği Sayfaya Dön"),
              ),
              ElevatedButton(
                onPressed: () {
                  // sayfayı tamamen kaldırıp, ilk sayfaya gidiyor
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Ana Sayfaya Dön"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Sayfayı silip, ana sayfaya geçiyor
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AnaSayfa()));
                },
                child: const Text("Ana Sayfaya Geçiş Yap"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
