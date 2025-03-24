// <----- 📜 alphabet_list_widget.dart ----->
// -----------------------------------------------------------------------------
// Alfabetik fihrist görünümü için kullanılan widget
// -----------------------------------------------------------------------------
//
import 'package:flutter/material.dart';
import 'package:alphabet_list_view/alphabet_list_view.dart';

import '../../../../widgets/word_card.dart';

class AlphabetListWidget extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> groupedData;

  const AlphabetListWidget({super.key, required this.groupedData});

  @override
  Widget build(BuildContext context) {
    return AlphabetListView(
      items: groupedData.entries.map((entry) {
        return AlphabetListViewItemGroup(
          tag: entry.key,
          children: entry.value
              .map((item) => WordCard(
            sirpca: item['sirpca'],
            turkce: item['turkce'],
          ),)
              .toList(),
        );
      }).toList(),
      options: AlphabetListViewOptions(
        /// Sağdaki çubuk üzerinde seçilen harfin görünümü
        ///
        overlayOptions: OverlayOptions(
          alignment: Alignment.centerRight,
          overlayBuilder: (context, symbol) {
            return Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(100),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: FittedBox(
                  child: Text(
                    symbol,
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        /// listeleme seçenekleri
        ///
        listOptions: ListOptions(
          backgroundColor: Colors.blueGrey,
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
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 8, top: 8, right: 16, bottom: 8),
                  child: Text(
                    symbol,
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        /// scrollbar seçenekleri
        ///
        scrollbarOptions: ScrollbarOptions(
          jumpToSymbolsWithNoEntries: true,
          backgroundColor: Colors.indigo,
          symbolBuilder: (context, symbol, state) {
            final color = switch (state) {
              AlphabetScrollbarItemState.active => Colors.black87,
              AlphabetScrollbarItemState.deactivated => Colors.blue,
              _ => Colors.amber,
            };

            return Container(
              padding: const EdgeInsets.only(left: 4, top: 2, bottom: 2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(100),
                ),
                color: state == AlphabetScrollbarItemState.active
                    ? Colors.lightGreen
                    : null,
              ),
              child: Center(
                child: FittedBox(
                  child: Text(
                    symbol,
                    style: TextStyle(color: color, fontSize: 20),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

