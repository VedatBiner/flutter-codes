// 📃 <----- alphabet_item_list.dart ----->
// Fihrist görünümlü listeleme için kullanılır.

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/serbian_alphabet.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../widgets/item_actions.dart';
import '../widgets/item_card.dart';

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
  List<Word> localWords = [];
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    localWords = widget.words;
  }

  // 🔄 Kelime listesi dışarıdan değiştiğinde State'i tazele
  @override
  void didUpdateWidget(covariant AlphabetWordList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.words != widget.words) {
      setState(() {
        localWords = widget.words;
        selectedIndex = null; // önceki seçim geçersiz olsun
      });
    }
  }

  Future<void> _refreshWords() async {
    final updatedWords = await DbHelper.instance.getRecords();
    setState(() {
      localWords = updatedWords;
      selectedIndex = null;
    });
    widget.onUpdated(); // üst seviyeyi de bilgilendir
  }

  List<AlphabetListViewItemGroup> _buildGroupedItems() {
    Map<String, List<Word>> grouped = {};

    for (var word in localWords) {
      final trimmed = word.sirpca.trim();
      final firstLetter = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '-';
      final tag = serbianAlphabet.contains(firstLetter) ? firstLetter : '-';
      grouped.putIfAbsent(tag, () => []).add(word);
    }

    return serbianAlphabet.map((letter) {
      final items = grouped[letter] ?? [];

      return AlphabetListViewItemGroup(
        tag: letter,
        children:
            items.map((word) {
              final index = localWords.indexOf(word);
              final isSelected = selectedIndex == index;

              return WordCard(
                word: word,
                isSelected: isSelected,
                onTap: () {
                  // Karta dokununca seçim temizlensin
                  if (selectedIndex != null) {
                    setState(() => selectedIndex = null);
                  }
                },
                onLongPress: () {
                  // Uzun basınca seçimi değiştir
                  setState(() => selectedIndex = isSelected ? null : index);
                },
                onEdit:
                    () => editWord(
                      context: context,
                      word: word,
                      onUpdated: _refreshWords,
                    ),
                onDelete:
                    () => confirmDelete(
                      context: context,
                      word: word,
                      onDeleted: _refreshWords,
                    ),
              );
            }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (localWords.isEmpty) {
      return const Center(child: Text('Henüz kelime eklenmedi.'));
    }

    return GestureDetector(
      onTap: () {
        // Ekrandaki boş alana dokunulunca seçim kaldırılsın
        if (selectedIndex != null) {
          setState(() => selectedIndex = null);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: AlphabetListView(
        items: _buildGroupedItems(),
        options: AlphabetListViewOptions(
          scrollbarOptions: ScrollbarOptions(
            symbols: serbianAlphabet,
            jumpToSymbolsWithNoEntries: true,
            backgroundColor: drawerColor,
            symbolBuilder: (context, symbol, state) {
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
                          ).colorScheme.secondary.withAlpha(150)
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
            listHeaderBuilder:
                (context, symbol) => Padding(
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
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          top: 8,
                          right: 16,
                          bottom: 8,
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
