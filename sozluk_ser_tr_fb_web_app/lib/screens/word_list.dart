// 📃 <----- word_list.dart ----->
// Klasik görünümlü listeleme için kullanılır.

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../models/word_model.dart';
import '../services/db_helper.dart';
import '../widgets/word_actions.dart';
import '../widgets/word_card.dart';

class WordList extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const WordList({super.key, required this.words, required this.onUpdated});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  List<Word> localWords = [];
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    localWords = widget.words;
  }

  Future<void> _refreshWords() async {
    final updatedWords = await DbHelper.instance.getRecords();
    setState(() {
      localWords = updatedWords;
      selectedIndex = null;
    });
    widget.onUpdated(); // varsa üst seviyeye de bildir
  }

  @override
  Widget build(BuildContext context) {
    if (localWords.isEmpty) {
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
        itemCount: localWords.length,
        itemBuilder: (context, index) {
          final word = localWords[index];
          final isSelected = selectedIndex == index;

          return WordCard(
            word: word,
            isSelected: isSelected,
            onTap: () {
              if (selectedIndex != null) {
                setState(() => selectedIndex = null);
              }
            },

            onLongPress: () {
              setState(() => selectedIndex = isSelected ? null : index);
            },

            onEdit: () => editWord(
              context: context,
              word: word,
              onUpdated: _refreshWords,
            ),

            onDelete: () => confirmDelete(
              context: context,
              word: word,
              onDeleted: _refreshWords,
            ),
          );
        },
      ),
    );
  }
}
