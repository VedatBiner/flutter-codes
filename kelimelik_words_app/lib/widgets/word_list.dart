// 📃 <----- word_list.dart ----->

import 'package:flutter/material.dart';

import '../db/word_database.dart';
import '../models/word_model.dart';
import '../widgets/word_dialog.dart';

class WordList extends StatelessWidget {
  final List<Word> words;
  final Function() onUpdated;

  const WordList({super.key, required this.words, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Center(child: Text('Henüz kelime eklenmedi.'));
    }

    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
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
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _confirmDelete(context, word);
                },
              ),
              onTap: () async {
                final updated = await showDialog<Word>(
                  context: context,
                  builder: (_) => WordDialog(word: word),
                );

                if (updated != null) {
                  await WordDatabase.instance.updateWord(updated);
                  onUpdated();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kelime güncellendi')),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

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
                  onUpdated();
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
}
