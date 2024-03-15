/// <----- delete_word.dart ----->
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../models/words.dart';
import '../services/firestore.dart';

class DeleteWord extends StatelessWidget {
  const DeleteWord({
    super.key,
    required this.word,
    required this.firestoreService,
    required this.firstLanguageText,
    required this.secondLanguageText,
  });

  final Words word;
  final FirestoreService firestoreService;
  final String firstLanguageText;
  final String secondLanguageText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white // Dark mode'dayken arka plan rengi
          : null, // Light mode'dayken arka plan rengi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      title: const Text(
        "Dikkat !!!",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Row(
        children: [
          const Text("Bu kelime "),
          Text(
            /// dil seçimine göre silinecek
            /// kelime soruluyor
            firstLanguageText == birinciDil
                ? word.sirpca
                : secondLanguageText == ikinciDil
                    ? word.sirpca
                    : word.turkce,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontSize: 16,
            ),
          ),
          const Text(" silinsin mi ?"),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("İptal"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text(
            "Tamam",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            /// Mevcut kullanıcının e-posta adresini al
            String currentUserEmail =
                FirebaseAuth.instance.currentUser?.email ?? 'vbiner@gmail.com';

            /// Eğer kelimeyi kaydeden ile login olan kullanıcı
            /// aynı ise kelimeyi sil
            if (currentUserEmail == word.userEmail) {
              firestoreService.deleteWord(word.wordId);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Text(
                        "(${word.sirpca})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        " kelimesi silinmiştir ...",
                      ),
                    ],
                  ),
                ),
              );
            } else {
              /// Eğer e-posta adresleri farklıysa, kullanıcıyı uyar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Bu kelimeyi silemezsiniz. Sadece kendi "
                    "eklediğiniz kelimeleri silebilirsiniz."
                        "ekleyen kullanıcı : ${word.userEmail}",
                  ),
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
