// 📃 <----- add_word_dialog.dart ----->

import 'package:flutter/material.dart';

import '../db/word_database.dart';
import '../models/word_model.dart';
import 'word_dialog.dart';

Future<void> showAddWordDialog(
  BuildContext context,
  VoidCallback onWordAdded,
) async {
  final result = await showDialog<Word>(
    context: context,
    builder: (_) => const WordDialog(),
  );

  if (result != null) {
    final existing = await WordDatabase.instance.getWord(result.word);
    if (existing != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bu kelime zaten var')));
      return;
    }

    await WordDatabase.instance.insertWord(result);
    onWordAdded();
  }
}
