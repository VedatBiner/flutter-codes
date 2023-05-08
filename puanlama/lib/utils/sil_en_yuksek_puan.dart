import 'package:flutter/material.dart';

void silEnYuksekPuan(BuildContext context, Function saveEnYuksekPuan) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Dikkat !!!"),
        content: const Text("En yüksek puan silinsin mi?"),
        actions: [
          TextButton(
            child: const Text("İptal"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text("Sil"),
            onPressed: () {
              saveEnYuksekPuan(0);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
