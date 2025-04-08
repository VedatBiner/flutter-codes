// 📃 <----- word_list.dart ----->
// klasik görünüm burada oluşturuluyor

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';
import 'package:kelimelik_words_app/constants/text_constants.dart';

import '../db/word_database.dart';
import '../models/word_model.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/notification_service.dart';
import '../widgets/word_action_buttons.dart';
import '../widgets/word_dialog.dart';

class WordList extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const WordList({super.key, required this.words, required this.onUpdated});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  int? selectedIndex;

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
        title: 'Kelime Silme İşlemi',
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

      setState(() {
        selectedIndex = null;
      });
    }
  }

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
                elevation: 5,
                color: cardLightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(word.word, style: kelimeText),
                          const Divider(thickness: 1),
                          Text(word.meaning, style: anlamText),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 12,
                        ),
                        child: WordActionButtons(
                          onEdit: () => _editWord(context, word),
                          onDelete: () => _confirmDelete(context, word),
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
