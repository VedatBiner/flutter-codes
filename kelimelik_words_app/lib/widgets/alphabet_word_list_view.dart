// 📃 <----- alphabet_word_list_view.dart ----->

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/color_constants.dart';
import '../constants/turkish_alphabet.dart';
import '../models/item_model.dart';
import '../providers/active_word_card_provider.dart';
import '../widgets/item_actions.dart';
import '../widgets/item_card.dart';

class AlphabetWordListView extends StatelessWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const AlphabetWordListView({
    super.key,
    required this.words,
    required this.onUpdated,
  });

  List<AlphabetListViewItemGroup> _buildGroupedItems(
    BuildContext context,
    int? activeIndex,
  ) {
    final Map<String, List<Word>> grouped = {};

    for (final word in words) {
      final trimmed = word.word.trim();
      final firstLetter = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '-';
      final tag = turkishAlphabet.contains(firstLetter) ? firstLetter : '-';
      grouped.putIfAbsent(tag, () => []).add(word);
    }

    return turkishAlphabet.map((letter) {
      final items = grouped[letter] ?? [];

      return AlphabetListViewItemGroup(
        tag: letter,
        children: items.map((word) {
          final index = words.indexOf(word);
          final isSelected = activeIndex == index;

          return WordCard(
            key: ValueKey(word.id),
            word: word,
            isSelected: isSelected,

            onTap: () => context.read<ActiveWordCardProvider>().close(),

            onLongPress: () {
              final provider = context.read<ActiveWordCardProvider>();

              isSelected ? provider.close() : provider.open(index);
            },

            onEdit: () =>
                editWord(context: context, word: word, onUpdated: onUpdated),

            onDelete: () => confirmDelete(
              context: context,
              word: word,
              onDeleted: onUpdated,
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Center(child: Text('Henüz kelime eklenmedi.'));
    }

    final activeIndex = context.watch<ActiveWordCardProvider>().activeIndex;

    return GestureDetector(
      onTap: () => context.read<ActiveWordCardProvider>().close(),
      behavior: HitTestBehavior.translucent,
      child: AlphabetListView(
        items: _buildGroupedItems(context, activeIndex),
        options: AlphabetListViewOptions(
          scrollbarOptions: ScrollbarOptions(
            symbols: turkishAlphabet,
            jumpToSymbolsWithNoEntries: true,
            backgroundColor: drawerColor,
            symbolBuilder: (context, symbol, state) {
              return Container(
                padding: const EdgeInsets.only(left: 4, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(100),
                  ),
                  color: state == AlphabetScrollbarItemState.active
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.6)
                      : null,
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      symbol,
                      style: TextStyle(
                        color: menuColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          listOptions: ListOptions(
            backgroundColor: cardPageColor,
            stickySectionHeader: false,
            showSectionHeaderForEmptySections: true,
            listHeaderBuilder: (context, symbol) => Padding(
              padding: const EdgeInsets.only(right: 18, top: 4, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(100),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    symbol,
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: menuColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
