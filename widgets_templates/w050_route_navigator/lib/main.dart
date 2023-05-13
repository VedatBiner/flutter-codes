import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => GirisEkrani(),
        "/ProfilSayfasiRotasi": (context) => ProfilEkrani(),
      },
    );
  }
}

class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  girisYap() {
    Navigator.pushNamed(
      context,
      "/ProfilSayfasiRotasi",
      arguments: VeriModeli(kullaniciAdi: t1.text, sifre: t2.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş Ekrani"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: t1,
            ),
            TextFormField(
              controller: t2,
            ),
            ElevatedButton(
              onPressed: girisYap,
              child: const Text("Giriş Yap"),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilEkrani extends StatefulWidget {
  @override
  _ProfilEkraniState createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  cikisYap() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    VeriModeli? iletilenArgumanlar = ModalRoute.of(context)!.settings.arguments as VeriModeli?;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: cikisYap,
              child: const Text("Çıkış Yap"),
            ),
            Text(iletilenArgumanlar!.kullaniciAdi),
            Text(iletilenArgumanlar!.sifre),
          ],
        ),
      ),
    );
  }
}

class VeriModeli {
  String kullaniciAdi, sifre;

  VeriModeli({
    required this.kullaniciAdi,
    required this.sifre,
  });
}
