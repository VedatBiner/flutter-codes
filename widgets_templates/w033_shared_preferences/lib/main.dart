import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sayfaa.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> veriKaydi() async{
    // burada shared preferences 'e ulaşmayı bekliyoruz
    // await ile bu yapının oluşmasını bekliyoruz
    var sp = await SharedPreferences.getInstance();
    // kayıt yapalım
    sp.setString("ad", "Ahmet");
    sp.setInt("yas", 18);
    sp.setDouble("boy", 1.78);
    sp.setBool("bekarMi", true);

    var arkadasListe = <String>[];
    arkadasListe.add("Ece");
    arkadasListe.add("Ali");
    
    sp.setStringList("arkadasListe", arkadasListe);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Geçiş Yap"),
              onPressed: () {
                veriKaydi(); // önce verileri kaydedelim
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SayfaA(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
