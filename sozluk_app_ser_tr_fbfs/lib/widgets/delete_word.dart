/// <----- delete_word.dart ----->

import 'package:flutter/material.dart';

import '../models/words.dart';
import '../services/firestore.dart';

class DeleteWord extends StatelessWidget {
  const DeleteWord({
    super.key,
    required this.word,
    required this.firestoreService,
  });

  final Words word;
  final FirestoreService firestoreService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            "(${word.sirpca})",
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
          },
        ),
      ],
    );
  }
}
