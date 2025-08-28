// <📜 ----- lib/utils/edit_word_dialog.dart ----->
import 'package:flutter/material.dart';

import '../../models/word_model.dart';
import '../../services/word_service.dart';

/// Kelime düzenleme diyaloğunu açar ve günceller.
/// Başarılı olursa `true`, iptal edilirse `false` döner.
Future<bool> editWordDialog({
  required BuildContext context,
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final sirpcaCtl = TextEditingController(text: word.sirpca);
  final turkceCtl = TextEditingController(text: word.turkce);

  final ok =
      await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Kelimeyi Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: sirpcaCtl,
                decoration: const InputDecoration(labelText: 'Sırpça'),
              ),
              TextField(
                controller: turkceCtl,
                decoration: const InputDecoration(labelText: 'Türkçe'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ) ??
      false;

  if (!ok) return false;

  final newSirpca = sirpcaCtl.text.trim();
  final newTurkce = turkceCtl.text.trim();
  if (newSirpca.isEmpty || newTurkce.isEmpty) return false;

  final updated = word.copyWith(sirpca: newSirpca, turkce: newTurkce);
  await WordService.updateWord(updated, oldSirpca: word.sirpca);

  if (!context.mounted) return false;

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Güncellendi')));

  await onRefetch();
  return true;
}
