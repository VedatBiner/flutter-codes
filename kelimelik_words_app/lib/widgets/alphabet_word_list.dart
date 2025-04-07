// 📃 <----- alphabet_word_list.dart ----->

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';
import 'package:kelimelik_words_app/constants/text_constants.dart';
import 'package:kelimelik_words_app/db/word_database.dart';
import 'package:kelimelik_words_app/models/word_model.dart';
import 'package:kelimelik_words_app/widgets/notification_service.dart';
import 'package:kelimelik_words_app/widgets/word_dialog.dart';

import 'confirmation_dialog.dart';
import 'word_action_buttons.dart';

class AlphabetWordList extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const AlphabetWordList({
    super.key,
    required this.words,
    required this.onUpdated,
  });

  @override
  State<AlphabetWordList> createState() => _AlphabetWordListState();
}

class _AlphabetWordListState extends State<AlphabetWordList> {
  int? selectedIndex;

  static const List<String> turkishAlphabet = [
    'A',
    'B',
    'C',
    'Ç',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'İ',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'Ö',
    'P',
    'R',
    'S',
    'Ş',
    'T',
    'U',
    'Ü',
    'V',
    'Y',
    'Z',
  ];

  void _editWord(BuildContext context, Word word) async {
    final updated = await showDialog<Word>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WordDialog(word: word),
    );

    if (updated != null) {
      await WordDatabase.instance.updateWord(updated);
      widget.onUpdated();

      if (!context.mounted) return;

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
      confirmText: 'Sil',
      cancelText: 'İptal',
      confirmColor: deleteButtonColor,
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

  List<AlphabetListViewItemGroup> _buildGroupedItems() {
    Map<String, List<Word>> grouped = {};

    for (var word in widget.words) {
      final trimmed = word.word.trim();
      final firstLetter = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '-';
      final tag = turkishAlphabet.contains(firstLetter) ? firstLetter : '-';
      grouped.putIfAbsent(tag, () => []).add(word);
    }

    return turkishAlphabet.map((letter) {
      final items = grouped[letter] ?? [];

      return AlphabetListViewItemGroup(
        tag: letter,
        children:
            items.map((word) {
              final index = widget.words.indexOf(word);
              final isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                child: GestureDetector(
                  onLongPress:
                      () => setState(
                        () => selectedIndex = isSelected ? null : index,
                      ),
                  onTap: () {
                    if (selectedIndex != null) {
                      setState(() => selectedIndex = null);
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
                          padding: const EdgeInsets.all(12),
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
            }).toList(),
      );
    }).toList();
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
      child: AlphabetListView(
        items: _buildGroupedItems(),
        options: AlphabetListViewOptions(
          scrollbarOptions: ScrollbarOptions(
            symbols: turkishAlphabet,
            backgroundColor: drawerColor,
          ),
          listOptions: ListOptions(backgroundColor: cardPageColor),
          overlayOptions: const OverlayOptions(),
        ),
      ),
    );
  }
}
