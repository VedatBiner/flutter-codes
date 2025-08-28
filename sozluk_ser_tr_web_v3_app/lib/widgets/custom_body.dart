// <📜 ----- lib/widgets/custom_body.dart ----->
import 'package:flutter/material.dart';

import '../models/word_model.dart';
import '../services/word_service.dart';
import 'body_widgets/edit_word_dialog.dart';
import 'body_widgets/result_count_bar.dart';
import 'body_widgets/word_list_view.dart';

class CustomBody extends StatefulWidget {
  final bool loading;
  final String? error;
  final List<Word> allWords;
  final List<Word> filteredWords;
  final Future<void> Function() onRefetch;

  const CustomBody({
    super.key,
    required this.loading,
    required this.error,
    required this.allWords,
    required this.filteredWords,
    required this.onRefetch,
  });

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.loading) return const Center(child: CircularProgressIndicator());
    if (widget.error != null) {
      return Center(child: Text('Hata: ${widget.error}'));
    }
    if (widget.filteredWords.isEmpty) {
      return const Center(child: Text('Sonuç bulunamadı.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResultCountBar(
          filteredCount: widget.filteredWords.length,
          totalCount: widget.allWords.length,
        ),
        Expanded(
          child: WordListView(
            words: widget.filteredWords,
            selectedIndex: selectedIndex,
            onClearSelection: () => setState(() => selectedIndex = null),
            onToggleSelect: (i) => setState(() {
              selectedIndex = (selectedIndex == i) ? null : i;
            }),
            onEdit: (word) => editWordDialog(
              context: context,
              word: word,
              onRefetch: widget.onRefetch,
            ),
            onDelete: (word) => _confirmDelete(context: context, word: word),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete({
    required BuildContext context,
    required Word word,
  }) async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Silinsin mi?'),
            content: Text(
              '"${word.sirpca}" kaydını silmek istediğinize emin misiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sil'),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    await WordService.deleteWord(word);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Silindi')));
    await widget.onRefetch();
  }
}
