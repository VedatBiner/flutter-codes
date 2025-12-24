// 📃 <----- item_list.dart ----->
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_model.dart';
import '../providers/active_word_card_provider.dart';
import '../widgets/item_actions.dart';
import '../widgets/item_card.dart';

class WordList extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onUpdated;

  const WordList({super.key, required this.words, required this.onUpdated});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          final activeCard = context.watch<ActiveWordCardProvider>();
          final isSelected = activeCard.activeWordId == word.id;

          return WordCard(
            key: ValueKey(word.id),
            word: word,
            isSelected: isSelected,
            onTap: () {
              context.read<ActiveWordCardProvider>().close();
            },
            onLongPress: () {
              isSelected
                  ? context.read<ActiveWordCardProvider>().close()
                  : context.read<ActiveWordCardProvider>().open(word.id!);
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
