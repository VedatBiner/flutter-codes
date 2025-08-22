// <📜 ----- lib/widgets/custom_body.dart ----->
/*
  🧩 Liste gövdesi (CustomBody) — WordCard + seçim + düzenle/sil
  - filteredWords listesini WordCard satırlarıyla gösterir.
  - Uzun basınca satırı “seçili” yapar; tekrar basınca kaldırır.
  - Düzenle → basit bir dialog ile sirpca/turkce günceller, WordService.updateWord çağırır.
  - Sil     → onay dialogu ile WordService.deleteWord çağırır.
  - Her iki işlemden sonra parent’tan gelen onRefetch() ile verileri tazeler.
*/

import 'package:flutter/material.dart';

import '../models/word_model.dart';
import '../services/word_service.dart';
import 'word_card.dart';

class CustomBody extends StatefulWidget {
  final bool loading;
  final String? error;
  final List<Word> allWords;
  final List<Word> filteredWords;

  /// Kelime eklendi/güncellendi/silindiğinde veriyi baştan okumak için
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
    if (widget.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.error != null) {
      return Center(child: Text('Hata: ${widget.error}'));
    }
    if (widget.filteredWords.isEmpty) {
      return const Center(child: Text('Sonuç bulunamadı.'));
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sonuç: ${widget.filteredWords.length} / ${widget.allWords.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.filteredWords.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final word = widget.filteredWords[index];
                    final isSelected = selectedIndex == index;

                    // 🔽 İstediğin kullanım şekli:
                    return WordCard(
                      word: word,
                      isSelected: isSelected,
                      onTap: () {
                        if (selectedIndex != null) {
                          setState(() => selectedIndex = null);
                        }
                      },
                      onLongPress: () {
                        setState(
                          () => selectedIndex = isSelected ? null : index,
                        );
                      },
                      onEdit: () => _editWord(context: context, word: word),
                      onDelete: () =>
                          _confirmDelete(context: context, word: word),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✏️ Düzenleme akışı (basit dialog)
  Future<void> _editWord({
    required BuildContext context,
    required Word word,
  }) async {
    final sirpcaCtl = TextEditingController(text: word.sirpca);
    final turkceCtl = TextEditingController(text: word.turkce);

    final ok =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Kelimeyi Düzenle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: sirpcaCtl,
                  decoration: const InputDecoration(labelText: 'Sırpça'),
                ),
                TextField(
                  controller: turkceCtl,
                  decoration: const InputDecoration(labelText: 'Türkçe'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Vazgeç'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    final newSirpca = sirpcaCtl.text.trim();
    final newTurkce = turkceCtl.text.trim();
    if (newSirpca.isEmpty || newTurkce.isEmpty) return;

    // id varsa dokümandan güncelleme yapılır; yoksa oldSirpca ile arayıp günceller
    final updated = word.copyWith(sirpca: newSirpca, turkce: newTurkce);

    await WordService.updateWord(updated, oldSirpca: word.sirpca);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Güncellendi')));

    await widget.onRefetch();
  }

  // 🗑️ Silme akışı (onay dialogu)
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
