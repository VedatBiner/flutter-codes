// <📜 ----- lib/widgets/custom_body.dart ----->

/*
  🧩 CustomBody — Ana içerik gövdesi

  NE YAPAR?
  - Üstte, AppBar ’a yapışık tam genişlik bir sayaç bandı (ResultCountBar) gösterir.
  - Filtrelenmiş kelimeleri performant bir liste (WordListView) ile sunar.
  - Satır seçimini (tek tık/uzun basış) local state ’te `selectedIndex` ile yönetir.
  - Düzenleme ve silme işlemlerini modüler diyalog yardımcılarına delege eder:
      • editWordDialog(...)   → kelime düzenler, başarıda onRefetch() çağırır
      • deleteWordDialog(...) → kelime siler, başarıda onRefetch() çağırır

  GİRDİLER (props):
    - loading, error         : üst seviye yükleme/hata kontrolleri (burada sadece içerik çizilir)
    - allWords, filteredWords: toplam ve filtreli liste sayıları üst bantta ve listede kullanılır
    - onRefetch              : düzenle/sil sonrası verileri tazelemek için geri çağırım

  BAĞIMLILIKLAR:
    - body_widgets/result_count_bar.dart
    - body_widgets/item_list_view.dart
    - body_widgets/edit_item_dialog.dart
    - body_widgets/delete_item_dialog.dart

  NOTLAR:
  - Bileşen, sadece seçili satır indeksini tutar; iş kuralları servislerde/diyaloglarda.
  - Yapı column → (ResultCountBar) + Expanded(WordListView) şeklindedir.
*/

// 📌 Flutter paketleri burada
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../models/item_model.dart';
import '../widgets/show_notifications_handler.dart';
import 'body_widgets/item_list_view.dart';
import 'body_widgets/result_count_bar.dart';

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
            onEdit: (word) => showEditWordDialogHandler(
              context,
              word: word,
              onRefetch: widget.onRefetch,
            ),

            /// ✅ kelime silme işlemi için
            onDelete: (word) => showDeleteWordHandler(
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
