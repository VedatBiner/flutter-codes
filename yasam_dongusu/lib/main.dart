import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:yasam_dongusu/sayfaa.dart';

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
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    log("initState() çalıştı ...");
    WidgetsBinding.instance.addObserver(this); // Observer başlatılır
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); // Observer kapatılır
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive){
      log("inactive() çalıştı");
    }

    if (state == AppLifecycleState.paused){
      log("paused() çalıştı");
    }

    if (state == AppLifecycleState.resumed){
      log("resumed() çalıştı");
    }

    if (state == AppLifecycleState.detached){
      log("detached() çalıştı");
    }
  }

  @override
  Widget build(BuildContext context) {
    log("build() çalıştı ...");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yaşam Döngüsü"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => const SayfaA(),
                  ),
                );
              },
              child: const Text("Tıkla"),
            ),
          ],
        ),
      ),
    );
  }
}




















