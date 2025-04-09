// 📃 <----- alphabet_word_list.dart ----->
// Fihrist görünümlü listeleme için kullanılır.

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';
import 'package:kelimelik_words_app/models/word_model.dart';

import '../constants/turkish_alphabet.dart';
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

                /// 📌 kelime kartına uzun basılınca
                /// düzeltme ve silme butonları çıkıyor.
                onLongPress: () {
                  setState(() => selectedIndex = isSelected ? null : index);
                },

                /// 📌 düzeltme metodu
                onEdit:
                    () => editWord(
                      context: context,
                      word: word,
                      onUpdated: widget.onUpdated,
                    ),

                /// 📌 silme metodu
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
          /// 📌 Fihrist görünümünde küçük harfleri göstermek için
          /// burası kullanılıyor.
          scrollbarOptions: ScrollbarOptions(
            symbols: turkishAlphabet,
            jumpToSymbolsWithNoEntries: true,
            backgroundColor: drawerColor,
            symbolBuilder: (context, symbol, state) {
              final color = switch (state) {
                AlphabetScrollbarItemState.active => Colors.black,
                AlphabetScrollbarItemState.deactivated => Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.4),
                _ => Theme.of(context).colorScheme.primary,
              };
              return Container(
                padding: const EdgeInsets.only(left: 4, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(100),
                  ),
                  color:
                      state == AlphabetScrollbarItemState.active
                          ? Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.6)
                          : null,
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      symbol,
                      style: TextStyle(
                        color: menuColor /*color*/,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          listOptions: ListOptions(backgroundColor: cardPageColor),

          /// 📌 Fihrist görünümünde büyük görünen harfler ile ilgili
          /// düzenlemeler için burası kullanılıyor.
          overlayOptions: OverlayOptions(
            alignment: Alignment.centerRight,
            overlayBuilder: (context, symbol) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(100),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: FittedBox(
                    child: Text(
                      symbol,
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
