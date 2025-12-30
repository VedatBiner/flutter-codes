// 📃 <----- alphabet_item_list.dart ----->

import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../widgets/alphabet_word_list_view.dart';

class AlphabetItemList extends StatelessWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const AlphabetItemList({
    super.key,
    required this.words,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return AlphabetWordListView(words: words, onUpdated: onUpdated);
  }
}
