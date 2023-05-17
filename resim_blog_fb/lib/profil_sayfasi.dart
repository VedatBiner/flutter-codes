import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
                    builder: (_) => null!),
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
              MaterialPageRoute(builder: (_) => null!),
                  (Route<dynamic> route) => true);
        },
      ),
      body: const ProfilTasarimi(),
    );
  }
}

class ProfilTasarimi extends StatefulWidget {
  const ProfilTasarimi({Key? key}) : super(key: key);

  @override
  State<ProfilTasarimi> createState() => _ProfilTasarimiState();
}

class _ProfilTasarimiState extends State<ProfilTasarimi> {
  late File yuklenecekDosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? indirmeBaglantisi;

  kameradanYukle() async {
    // kameradan resim alalım
    var alinanDosya = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      yuklenecekDosya = File(alinanDosya!.path);
    });
    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilResmi.png");
    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya);
    TaskSnapshot snapshot = await yuklemeGorevi.whenComplete(() {});
    String url = await snapshot.ref.getDownloadURL();
    setState(() {
      indirmeBaglantisi = url;
    });
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
