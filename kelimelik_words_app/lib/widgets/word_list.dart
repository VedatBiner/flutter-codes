// 📃 <----- word_list.dart ----->

import 'package:flutter/material.dart';

import '../db/word_database.dart';
import '../models/word_model.dart';
import 'word_dialog.dart';

class WordList extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const WordList({super.key, required this.words, required this.onUpdated});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  int? selectedIndex;

  void _confirmDelete(BuildContext context, Word word) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sil'),
            content: Text('"${word.word}" kelimesini silmek istiyor musunuz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await WordDatabase.instance.deleteWord(word.id!);
                  Navigator.of(context).pop();
                  widget.onUpdated();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kelime silindi')),
                    );
                  }
                },
                child: const Text('Evet'),
              ),
            ],
          ),
    );
  }

  void _editWord(BuildContext context, Word word) async {
    final updated = await showDialog<Word>(
      context: context,
      builder: (_) => WordDialog(word: word),
    );

    if (updated != null) {
      await WordDatabase.instance.updateWord(updated);
      widget.onUpdated();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Kelime güncellendi')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return const Center(child: Text('Henüz kelime eklenmedi.'));
    }

    return GestureDetector(
      onTap: () {
        if (selectedIndex != null) {
          setState(() {
            selectedIndex = null;
          });
        }
      },
      behavior: HitTestBehavior.translucent, // boşluklar dahil tık algılar
      child: ListView.builder(
        itemCount: widget.words.length,
        itemBuilder: (context, index) {
          final word = widget.words[index];
          final isSelected = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onDoubleTap: () {
                setState(() {
                  selectedIndex = isSelected ? null : index;
                });
              },
              onTap: () {
                // Aynı karta tekrar tıklarsan bir şey yapma
                if (selectedIndex != null && selectedIndex != index) {
                  setState(() {
                    selectedIndex = null;
                  });
                }
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        word.word,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        word.meaning,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _editWord(context, word),
                              icon: const Icon(Icons.edit),
                              label: const Text('Düzenle'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () => _confirmDelete(context, word),
                              icon: const Icon(Icons.delete),
                              label: const Text('Sil'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
