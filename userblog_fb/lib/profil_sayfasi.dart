import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:userblog_fb/yazi_sayfasi.dart';
import 'anasayfa.dart';
import 'main.dart';

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnaSayfa(),
                  ),
                  (Route<dynamic> route) => true);
            },
            icon: const Icon(Icons.home),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((deger) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Iskele()),
                    (Route<dynamic> route) => false);
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const YaziEkrani()),
              (Route<dynamic> route) => true);
        },
      ),
      body: Container(),
    );
  }
}
