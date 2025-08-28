// <📜 ----- lib/widgets/body_widgets/word_list_view.dart ----->
import 'package:flutter/material.dart';

import '../../models/word_model.dart';
import '../word_card.dart';

class WordListView extends StatelessWidget {
  final List<Word> words;
  final int? selectedIndex;

  /// Satırdaki seçimi temizlemek için (tek tık)
  final VoidCallback onClearSelection;

  /// Satır seçim durumunu değiştir (uzun basış)
  final void Function(int index) onToggleSelect;

  /// Düzenleme ve silme aksiyonları
  final void Function(Word word) onEdit;
  final void Function(Word word) onDelete;

  /// Görsel yerleşim opsiyonları
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const WordListView({
    super.key,
    required this.words,
    required this.selectedIndex,
    required this.onClearSelection,
    required this.onToggleSelect,
    required this.onEdit,
    required this.onDelete,
    this.maxWidth = 720,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: ListView.separated(
            itemCount: words.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final word = words[index];
              final isSelected = selectedIndex == index;

              return WordCard(
                word: word,
                isSelected: isSelected,
                onTap: () {
                  if (selectedIndex != null) onClearSelection();
                },
                onLongPress: () => onToggleSelect(index),
                onEdit: () => onEdit(word),
                onDelete: () => onDelete(word),
              );
            },
          ),
        ),
      ),
    );
  }
}
