import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_login_app/main.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  // oturum bilgisi okuma
  String? spKullaniciAdi;
  String? spSifre;

  // oturum bilgisi okuma metodu
  Future<void> oturumbilgisiOku() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      // oturum bilgisini okuyoruz
      spKullaniciAdi = sp.getString("kullaniciAdi") ?? "Kullanıcı adı yok !!!";
      spSifre = sp.getString("sifre") ?? "Şifre yok !!!";
    });
  }

  // Çıkış yap
  Future<void> cikisYap() async {
    var sp = await SharedPreferences.getInstance();
    // Çıkış yaparken kullanıcı adı ve şifreyi sil
    sp.remove("kullaniciAdi");
    sp.remove("sifre");
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginEkrani(),
        ),
      );
    }
  }

  // ilk çalışmada oturum bilgisini oku
  @override
  void initState() {
    super.initState();
    oturumbilgisiOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anasayfa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              cikisYap();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kullanıcı Adı : $spKullaniciAdi",
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              Text(
                "Şifre : $spSifre",
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
