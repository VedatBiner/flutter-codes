// 📃 <----- word_list.dart ----->

import 'package:flutter/material.dart';

import '../db/word_database.dart';
import '../models/word_model.dart';
import 'notification_service.dart';
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

  /// 📌 Kelime silme dialog açar.
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
                    NotificationService.showCustomNotification(
                      context: context,
                      title: 'Kelime Silme İşlemi',
                      message: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: word.word,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                            const TextSpan(
                              text: ' kelimesi silinmiştir.',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      // message: Text('${word.word} silindi.'),
                      icon: Icons.delete,
                      iconColor: Colors.red,
                      progressIndicatorColor: Colors.red,
                      progressIndicatorBackground: Colors.red.shade100,
                    );
                  }

                  setState(() {
                    selectedIndex = null;
                  });
                },
                child: const Text('Evet'),
              ),
            ],
          ),
    );
  }

  /// 📌 Kelime güncelleme dialog açar.
  void _editWord(BuildContext context, Word word) async {
    final updated = await showDialog<Word>(
      context: context,
      builder: (_) => WordDialog(word: word),
    );

    if (updated != null) {
      await WordDatabase.instance.updateWord(updated);
      widget.onUpdated();

      if (context.mounted) {
        NotificationService.showCustomNotification(
          context: context,
          title: 'Kelime Güncelleme İşlemi',
          message: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: updated.word,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
                const TextSpan(
                  text: ' kelimesi güncellendi.',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          icon: Icons.check_circle,
          iconColor: Colors.green,
          progressIndicatorColor: Colors.green,
          progressIndicatorBackground: Colors.green.shade100,
        );
      }

      setState(() {
        selectedIndex = null;
      });
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
      behavior: HitTestBehavior.translucent,
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
              onLongPress: () {
                setState(() {
                  selectedIndex = isSelected ? null : index;
                });
              },
              onTap: () {
                if (selectedIndex != null && selectedIndex != index) {
                  setState(() {
                    selectedIndex = null;
                  });
                }
              },
              child: Card(
                elevation: 3,
                color: const Color(0xFFE3F2FD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            word.word,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(thickness: 1.2),
                          const SizedBox(height: 8),
                          Text(
                            word.meaning,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
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
