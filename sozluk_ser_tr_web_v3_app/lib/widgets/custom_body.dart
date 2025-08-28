// <📜 ----- lib/widgets/custom_body.dart ----->

// 📌 Flutter paketleri burada
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../models/word_model.dart';
import 'body_widgets/delete_word_dialog.dart';
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
        ///📌 Sayfa başlığı ve sonuç sayısı
        ResultCountBar(
          filteredCount: widget.filteredWords.length,
          totalCount: widget.allWords.length,
        ),

        ///📌 Kelime listesi
        Expanded(
          child: WordListView(
            words: widget.filteredWords,
            selectedIndex: selectedIndex,
            onClearSelection: () => setState(() => selectedIndex = null),
            onToggleSelect: (i) => setState(() {
              selectedIndex = (selectedIndex == i) ? null : i;
            }),

            /// ✅ kelime düzeltme işlemi için
            onEdit: (word) => editWordDialog(
              context: context,
              word: word,
              onRefetch: widget.onRefetch,
            ),

            /// ✅ kelime silme işlemi için
            onDelete: (word) => deleteWordDialog(
              context: context,
              word: word,
              onRefetch: widget.onRefetch,
            ),
          ),
        ),
      ],
    );
  }
}
