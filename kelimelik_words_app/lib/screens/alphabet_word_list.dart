// 📃 <----- alphabet_word_list.dart ----->
// Fihrist görünümlü listeleme için kullanılır.

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';
import 'package:kelimelik_words_app/models/word_model.dart';

import '../widgets/word_actions.dart';
import '../widgets/word_card.dart';

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
                onEdit:
                    () => editWord(
                      context: context,
                      word: word,
                      onUpdated: widget.onUpdated,
                    ),
                onDelete:
                    () => confirmDelete(
                      context: context,
                      word: word,
                      onDeleted: widget.onUpdated,
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
