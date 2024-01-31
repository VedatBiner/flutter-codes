/// <----- vb_memes_new.drt ----->
///

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../services/storage_services.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';
import '../pages/vb_memes.dart';

class NewMeme extends StatefulWidget {
  const NewMeme({super.key});

  @override
  State<NewMeme> createState() => _NewMemeState();
}

class _NewMemeState extends State<NewMeme> {
  /// Kullanıcıdan gelen fotoğraf
  XFile? selectedPhoto;

  /// Gönderi metni
  String? postText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Gönderi"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// resim seç butonu
            SizedBox(
              height: 300,
              width: double.infinity,

              /// Eğer resim seçilmemiş ise
              child: selectedPhoto == null
                  ? IconButton(
                      /// eğer resim seçilmemişse
                      onPressed: () async {
                        /// ImagePicker ile kullanıcıdan resim al
                        var pickedPhoto = await ImagePicker.platform
                            .getImageFromSource(source: ImageSource.gallery);
                        setState(() {
                          /// seçilen fotoyu değişkene ata,
                          /// sayfayı yenile
                          selectedPhoto = pickedPhoto;
                        });
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 128,
                      ),
                    )
                  : Container(
                      child: Image.file(
                        File(selectedPhoto!.path),
                      ),
                    ),
            ),

            /// kullanıcının metin yazacağı alan
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Açıklama yazınız ...",
                ),
                onChanged: (value) {
                  /// değişikliği değişkene ata
                  postText = value;
                },
              ),
            ),

            /// ekle butonu
            TextButton(
              child: const Text(
                "Ekle",
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
              onPressed: () async {
                try {
                  /// foto ve metin boş değilse
                  if (selectedPhoto != null && postText != null) {
                    /// yüklenecek dosya için isimlendirme yapıyoruz
                    DateTime now = DateTime.now();
                    String fileName = "${auth.currentUser!.uid}"
                        "${now.year}"
                        "${now.month}"
                        "${now.day}"
                        "${now.hour}"
                        "${now.second}"
                        "${now.millisecondsSinceEpoch}";

                    /// seçilen resmi storage 'a yükle
                    /// roo dizine git
                    var uploadStorage = await storage
                        .ref()

                        /// kullanıcı UID ile aynı olan bir dizin aç
                        .child(auth.currentUser!.uid)

                        /// seçilen resim dosyasını koy
                        .child(fileName)
                        .putFile(File(selectedPhoto!.path));

                    /// dosya yüklemesi bitince
                    /// indirme linkini al
                    var uploadedPhotoUrl = await uploadStorage.ref
                        .getDownloadURL()
                        .then((value) => value.toString());
                    print(uploadedPhotoUrl);

                    /// daha sonra Firestore 'a yazalım
                    firestore.collection("memes").add({
                      "author": auth.currentUser!.email,
                      "postText": postText,
                      "added_time": now,
                      "mediaURL": uploadedPhotoUrl
                    }).whenComplete(
                      () {
                        /// işlem tamamlanınca ana sayfaya git
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VBMemes(),
                          ),
                          (route) => false,
                        );
                      },
                    );
                  } else {
                    print("Dosya seçilmedi");
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
