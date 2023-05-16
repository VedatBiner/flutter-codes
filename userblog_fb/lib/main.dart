import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profil_sayfasi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Iskele(),
    );
  }
}

class Iskele extends StatefulWidget {
  const Iskele({Key? key}) : super(key: key);

  @override
  State<Iskele> createState() => _IskeleState();
}

class _IskeleState extends State<Iskele> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  // kayıt olma metodu
  Future<void> kayitOl() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: t1.text,
        password: t2.text,
      )
          .then((kullanici) {
        // kullanıcı kayıt işlemi tamamlandıktan sonra ...
        FirebaseFirestore.instance.collection("kullanicilar").doc(t1.text).set({
          "KullaniciEposta": t1.text,
          "kullaniciSifre": t2.text,
        });
      });
      print("Kayıt başarılı!");
    } catch (e) {
      print("Kayıt hatası: $e");
    }
  }

  // email ile giriş metodu
  girisYap() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: t1.text,
      password: t2.text,
    )
        .then((kullanici) {
      // oturum açınca sayfa değişsin
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilEkrani(),
          ),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(40),
        child: Center(
            child: Column(
          children: [
            TextFormField(
              controller: t1,
            ),
            TextFormField(
              controller: t2,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: kayitOl,
                  child: const Text("Kaydol"),
                ),
                ElevatedButton(
                  onPressed: girisYap,
                  child: const Text("Giriş Yap"),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
