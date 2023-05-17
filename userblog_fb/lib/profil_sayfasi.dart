import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: Container(
        child: KullaniciYazilari(),
      ),
    );
  }
}

class KullaniciYazilari extends StatefulWidget {
  const KullaniciYazilari({super.key});

  @override
  _KullaniciYazilariState createState() => _KullaniciYazilariState();
}

class _KullaniciYazilariState extends State<KullaniciYazilari> {
  final Query blogYazilari =
      FirebaseFirestore.instance
          .collection('Yazilar')
          .where(
            "kullaniciId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: blogYazilari.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['baslik']),
              subtitle: Text(data['icerik']),
            );
          }).toList(),
        );
      },
    );
  }
}
