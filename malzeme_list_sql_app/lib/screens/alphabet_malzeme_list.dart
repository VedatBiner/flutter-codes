// 📃 <----- alphabet_malzeme_list.dart ----->
//
// Fihrist görünümlü listeleme için kullanılır.

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';

/// 📌 sabitler burada
import '../constants/color_constants.dart';
import '../constants/turkish_alphabet.dart';

/// 📌 Yardımcı yüklemeler burada
import '../models/item_model.dart';
import '../widgets/malzeme_actions.dart';
import '../widgets/malzeme_card.dart';

class AlphabetMalzemeList extends StatefulWidget {
  final List<Malzeme> malzemeler;
  final VoidCallback onUpdated;

  const AlphabetMalzemeList({
    super.key,
    required this.malzemeler,
    required this.onUpdated,
  });

  @override
  State<AlphabetMalzemeList> createState() => _AlphabetMalzemeListState();
}

class _AlphabetMalzemeListState extends State<AlphabetMalzemeList> {
  int? selectedIndex;

  /// 📌 Fihrist için grup yapılarını oluşturur
  List<AlphabetListViewItemGroup> _buildGroupedItems() {
    Map<String, List<Malzeme>> grouped = {};

    for (var malzeme in widget.malzemeler) {
      final trimmed = malzeme.malzeme.trim();
      final firstLetter = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '-';
      final tag = turkishAlphabet.contains(firstLetter) ? firstLetter : '-';
      grouped.putIfAbsent(tag, () => []).add(malzeme);
    }

    return turkishAlphabet.map((letter) {
      final items = grouped[letter] ?? [];

      return AlphabetListViewItemGroup(
        tag: letter,
        children: items.map((malzeme) {
          final index = widget.malzemeler.indexOf(malzeme);
          final isSelected = selectedIndex == index;

          return MalzemeCard(
            malzeme: malzeme,
            isSelected: isSelected,
            onTap: () {
              if (selectedIndex != null) {
                setState(() => selectedIndex = null);
              }
            },

            /// 📌 kart uzun basıldığında
            /// düzenle / sil butonları gösterilir
            onLongPress: () {
              setState(() => selectedIndex = isSelected ? null : index);
            },

            /// 📌 düzenleme metodu
            onEdit: () => editWord(
              context: context,
              word: malzeme,
              onUpdated: widget.onUpdated,
            ),

            /// 📌 silme metodu
            onDelete: () => confirmDelete(
              context: context,
              word: malzeme,
              onDeleted: widget.onUpdated,
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.malzemeler.isEmpty) {
      return const Center(child: Text('Henüz malzeme eklenmedi.'));
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
          /// 📌 Fihrist harfleri için ayarlar
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

          /// 📌 Liste görünümü ayarları
          listOptions: ListOptions(
            backgroundColor: cardPageColor,
            stickySectionHeader: false,
            showSectionHeaderForEmptySections: true,

            /// 📌 Baş harf görseli ayarları
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
                        color: menuColor, // 📌 liste başı harf rengi
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 📌 Ortadaki büyük harf overlay için ayarlar
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
