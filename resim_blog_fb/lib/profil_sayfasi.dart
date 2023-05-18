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
                  MaterialPageRoute(builder: (_) => null!),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => baglantiAl(),
    );
  }

  void kameradanYukle() async {
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
    String url = await (await yuklemeGorevi).ref.getDownloadURL();
    setState(() {
      indirmeBaglantisi = url;
    });
  }

  baglantiAl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilResmi.png")
        .getDownloadURL();
    setState(() {
      indirmeBaglantisi = baglanti;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipOval(
            child: indirmeBaglantisi == null
                ? const Text("Resim yok !!")
                : Image.network(
                    indirmeBaglantisi!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          ElevatedButton(
            onPressed: kameradanYukle,
            child: const Text("Kameradan Resim Yükle"),
          ),
        ],
      ),
    );
  }
}






