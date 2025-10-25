// 📃 <----- item_actions.dart ----->
//
// malzeme güncelleme ve silme metodu
// eski word_actions.dart
//

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/item_dialog.dart';
import '../widgets/show_notifications_handler.dart';

/// 📌 malzeme güncelleme metodu
///
Future<void> editWord({
  required BuildContext context,
  required Malzeme word,
  required VoidCallback onUpdated,
}) async {
  final updated = await showDialog<Malzeme>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        MalzemeDialog(malzeme: word), // ✅ doğru parametre adı: malzeme
  );

  if (updated != null) {
    await DbHelper.instance.updateRecord(updated);
    if (!context.mounted) return;
    onUpdated();

    showMalzemeUpdatedNotification(
      context: context,
      malzemeAdi: updated.malzeme,
      // width: 280, height: 120,   // istersen ver
    );
  }
}

/// 📌 malzeme silme metodu
///
Future<void> confirmDelete({
  required BuildContext context,
  required Malzeme word,
  required VoidCallback onDeleted,
}) async {
  final confirm = await showConfirmationDialog(
    context: context,
    title: 'Malzemeyi Sil',
    content: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.malzeme, style: kelimeText),
          const TextSpan(
            text: ' malzemesini silmek istiyor musunuz?',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    ),
    confirmText: 'Sil',
    cancelText: 'İptal',
    confirmColor: deleteButtonColor,
  );

  if (confirm == true) {
    await DbHelper.instance.deleteRecord(word.id!);
    if (!context.mounted) return;
    onDeleted();

    showMalzemeDeletedNotification(
      context: context,
      malzemeAdi: word.malzeme, // elindeki modele göre: word/malzeme/record...
      // width: 280, height: 140, // istersen özelleştir
    );
  }
}
