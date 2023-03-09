import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'anasayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> oturumKontrol() async {
    var sp = await SharedPreferences.getInstance();

    // oturum bilgisini okuyoruz
    String spKullaniciAdi =
        sp.getString("kullaniciAdi") ?? "Kullanıcı adı yok !!!";
    String spSifre = sp.getString("sifre") ?? "Şifre yok !!!";

    if (spKullaniciAdi == "admin" && spSifre == "123") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: oturumKontrol(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool? gecisIzni = snapshot.data;
            return gecisIzni! ? const AnaSayfa() : const LoginEkrani();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class LoginEkrani extends StatefulWidget {
  const LoginEkrani({super.key});

  @override
  State<LoginEkrani> createState() => _LoginEkraniState();
}

class _LoginEkraniState extends State<LoginEkrani> {
  // Text controller oluşturalım
  var tfKullaniciAdi = TextEditingController();
  var tfSifre = TextEditingController();

  // snackbar gösterebilmek için bu key gerekli
  var scaffoldKey = GlobalKey<ScaffoldState>();

  // veri kayıt metodu
  Future<void> girisKontrol() async {
    // kullanıcı adı ve şifre bilgisini alıyoruz.
    var ka = tfKullaniciAdi.text;
    var s = tfSifre.text;
    if (ka == "admin" && s == "123") {
      var sp = await SharedPreferences.getInstance();
      // veri kaydı yapılsın
      sp.setString("kullaniciAdi", ka);
      sp.setString("sifre", s);
      // sayfa geçişi
      // bu şekilde altını çizmedi
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AnaSayfa(),
          ),
        );
      }
    } else {
      // sorun varsa snack bar ile mesaj verelim
      // bu satır hata vermedi
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Giriş Hatalı"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Login Ekranı"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: tfKullaniciAdi,
                decoration: const InputDecoration(
                  hintText: "Kullanıcı Adı",
                ),
              ),
              TextField(
                obscureText: true,
                controller: tfSifre,
                decoration: const InputDecoration(
                  hintText: "Şifre",
                ),
              ),
              ElevatedButton(
                child: const Text("Giriş Yap"),
                onPressed: () {
                  girisKontrol();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
