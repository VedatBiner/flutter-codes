// 📃 <----- item_list.dart ----->
import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../widgets/item_actions.dart';
import '../widgets/item_card.dart';

class WordList extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const WordList({super.key, required this.words, required this.onUpdated});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList>
    with AutomaticKeepAliveClientMixin {
  int? selectedIndex;

  @override
  bool get wantKeepAlive => true; // 👈 Liste EKRANDA KALSIN, yeniden kurulmasın

  @override
  Widget build(BuildContext context) {
    super.build(context); // 👈 keepAlive için gerekli

    if (widget.words.isEmpty) {
      return const Center(child: Text('Henüz kelime eklenmedi.'));
    }

    return GestureDetector(
      onTap: () {
        if (selectedIndex != null) {
          setState(() => selectedIndex = null);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: ListView.builder(
        key: const PageStorageKey("classic_list"), // 👈 scroll pozisyonu kaydet
        itemCount: widget.words.length,
        itemBuilder: (context, index) {
          final word = widget.words[index];
          final isSelected = selectedIndex == index;

          return WordCard(
            key: ValueKey(word.id), // 👈 Item sabit kalsın, rebuild azaltır
            word: word,
            isSelected: isSelected,
            onTap: () => setState(() => selectedIndex = null),
            onLongPress: () =>
                setState(() => selectedIndex = isSelected ? null : index),
            onEdit: () => editWord(
              context: context,
              word: word,
              onUpdated: widget.onUpdated,
            ),
            onDelete: () => confirmDelete(
              context: context,
              word: word,
              onDeleted: widget.onUpdated,
            ),
          );
        },
      ),
    );
  }
}
