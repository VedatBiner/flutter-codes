import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';

import '../repository.dart';

class ExampleWidgetBuilder extends StatelessWidget {
  const ExampleWidgetBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final animalGroups =
        Repository.animals.entries.map((animalLetter) {
          return AlphabetListViewItemGroup(
            tag: animalLetter.key,
            children:
                animalLetter.value.map((animal) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Card(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.05),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.pets,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          animal,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onTap: () {
                          // Gelecekte detay sayfası eklenebilir
                        },
                      ),
                    ),
                  );
                }).toList(),
          );
        }).toList(); // 🟢 asıl burada toList()

    return AlphabetListView(
      items: animalGroups,
      options: AlphabetListViewOptions(
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
        scrollbarOptions: ScrollbarOptions(
          jumpToSymbolsWithNoEntries: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          symbolBuilder: (context, symbol, state) {
            final color = switch (state) {
              AlphabetScrollbarItemState.active => Colors.black,
              AlphabetScrollbarItemState.deactivated => Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.4),
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
                        ).colorScheme.secondary.withOpacity(0.6)
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
        listOptions: ListOptions(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.secondary.withOpacity(0.05),
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
      ),
    );
  }
}
