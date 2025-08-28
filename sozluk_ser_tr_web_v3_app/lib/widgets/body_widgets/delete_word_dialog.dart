// <📜 ----- lib/widgets/body_widgets/delete_word_dialog.dart ----->
import 'package:flutter/material.dart';

import '../../models/word_model.dart';
import '../../services/word_service.dart';

/// Silme diyaloğunu açar ve onaylanırsa kaydı siler.
/// Başarılı olursa `true`, iptal edilirse `false` döner.
Future<bool> deleteWordDialog({
  required BuildContext context,
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final ok =
      await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Silinsin mi?'),
          content: Text(
            '"${word.sirpca}" kaydını silmek istediğinize emin misiniz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sil'),
            ),
          ],
        ),
      ) ??
      false;

  if (!ok) return false;

  await WordService.deleteWord(word);

  if (!context.mounted) return false;

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Silindi')));

  await onRefetch();
  return true;
}
