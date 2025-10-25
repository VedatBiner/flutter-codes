// 📃 <----- item_list.dart ----->
// Klasik görünümlü listeleme için kullanılır.

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
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

class _WordListState extends State<WordList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
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
        itemCount: widget.words.length,
        itemBuilder: (context, index) {
          final word = widget.words[index];
          final isSelected = selectedIndex == index;

          return WordCard(
            word: word,
            isSelected: isSelected,
            onTap: () {
              if (selectedIndex != null) {
                setState(() => selectedIndex = null);
              }
            },

            /// 📌 kelime kartına uzun basılınca
            /// düzeltme ve silme butonları çıkıyor.
            onLongPress: () {
              setState(() => selectedIndex = isSelected ? null : index);
            },

            /// 📌 düzeltme metodu
            onEdit: () => editWord(
              context: context,
              word: word,
              onUpdated: widget.onUpdated,
            ),

            /// 📌 silme metodu
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
