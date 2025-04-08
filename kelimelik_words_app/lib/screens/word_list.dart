// 📃 <----- word_list.dart ----->
// Klasik görünümlü listeleme için kullanılır.

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';
import 'package:kelimelik_words_app/constants/text_constants.dart';
import 'package:kelimelik_words_app/db/word_database.dart';
import 'package:kelimelik_words_app/models/word_model.dart';
import 'package:kelimelik_words_app/widgets/confirmation_dialog.dart';
import 'package:kelimelik_words_app/widgets/notification_service.dart';
import 'package:kelimelik_words_app/widgets/word_card.dart';
import 'package:kelimelik_words_app/widgets/word_dialog.dart';

class WordList extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const WordList({super.key, required this.words, required this.onUpdated});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  int? selectedIndex;

  void _editWord(BuildContext context, Word word) async {
    final updated = await showDialog<Word>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WordDialog(word: word),
    );

    if (updated != null) {
      await WordDatabase.instance.updateWord(updated);
      if (!context.mounted) return;
      widget.onUpdated();

      NotificationService.showCustomNotification(
        context: context,
        title: 'Kelime Güncellendi',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: updated.word, style: kelimeAddText),
              const TextSpan(
                text: ' kelimesi güncellendi.',
                style: normalBlackText,
              ),
            ],
          ),
        ),
        icon: Icons.check_circle,
        iconColor: Colors.green,
        progressIndicatorColor: Colors.green,
        progressIndicatorBackground: Colors.green.shade100,
      );

      setState(() => selectedIndex = null);
    }
  }

  void _confirmDelete(BuildContext context, Word word) async {
    final confirm = await showConfirmationDialog(
      context: context,
      title: 'Kelimeyi Sil',
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: word.word, style: kelimeText),
            const TextSpan(
              text: ' kelimesini silmek istiyor musunuz?',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
      confirmText: 'Evet',
      cancelText: 'İptal',
      confirmColor: deleteButtonColor,
      cancelColor: cancelButtonColor,
    );

    if (confirm == true) {
      await WordDatabase.instance.deleteWord(word.id!);
      if (!context.mounted) return;
      widget.onUpdated();

      NotificationService.showCustomNotification(
        context: context,
        title: 'Kelime Silindi',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: word.word, style: kelimeText),
              const TextSpan(
                text: ' kelimesi silinmiştir.',
                style: normalBlackText,
              ),
            ],
          ),
        ),
        icon: Icons.delete,
        iconColor: Colors.red,
        progressIndicatorColor: Colors.red,
        progressIndicatorBackground: Colors.red.shade100,
      );

      setState(() => selectedIndex = null);
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
            onLongPress: () {
              setState(() => selectedIndex = isSelected ? null : index);
            },
            onEdit: () => _editWord(context, word),
            onDelete: () => _confirmDelete(context, word),
          );
        },
      ),
    );
  }
}
