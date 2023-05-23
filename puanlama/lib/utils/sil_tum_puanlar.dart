import 'package:flutter/material.dart';

void silTumPuanlar(BuildContext context, Function silTumPuanlar) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        title: const Text("Dikkat !!!"),
        content: const Text("Tüm Puanlar silinsin mi?"),
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
              silTumPuanlar(0,0,0);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
