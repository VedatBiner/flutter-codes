// 📃 <----- item_list.dart ----->
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_model.dart';
import '../providers/active_word_card_provider.dart';
import '../widgets/item_actions.dart';
import '../widgets/item_card.dart';

class ItemList extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const ItemList({super.key, required this.words, required this.onUpdated});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final activeIndex = context.watch<ActiveWordCardProvider>().activeIndex;

    if (widget.words.isEmpty) {
      return const Center(child: Text('Henüz kelime eklenmedi.'));
    }

    return GestureDetector(
      onTap: () {
        context.read<ActiveWordCardProvider>().close();
      },
      behavior: HitTestBehavior.translucent,
      child: ListView.builder(
        key: const PageStorageKey("classic_list"),
        itemCount: widget.words.length,
        itemBuilder: (context, index) {
          final word = widget.words[index];
          final isSelected = activeIndex == index;

          return WordCard(
            key: ValueKey(word.id),
            word: word,
            isSelected: isSelected,
            onTap: () {
              context.read<ActiveWordCardProvider>().close();
            },

            onLongPress: () {
              final provider = context.read<ActiveWordCardProvider>();

              if (isSelected) {
                provider.close();
              } else {
                provider.open(index);
              }
            },

            onEdit: () => editWord(
              context: context,
              word: word,
              onUpdated: widget.onUpdated,
            ),

            onDelete: () => confirmDelete(
              context: context,
              word: word,
              onDeleted: widget.onUpdated,
            ),
          );
        },
      ),
    );
  }
}
