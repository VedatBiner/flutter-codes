// 📃 <----- lib/widgets/custom_body.dart ----->
//
// CustomBody: HomePage gövdesini (liste / yükleniyor / hata) gösteren
// stateless, tekrar kullanılabilir bir widget.
//
// Parametreler:
// - isLoading   : Yükleniyor mu?
// - error       : Hata mesajı (varsa)
// - filtered    : Filtrelenmiş Word listesi (ekranda gösterilecek)
// - totalCount  : Tüm kayıt sayısı (üstteki bilgi satırı için)
// - maxWidth    : İsteğe bağlı, sayfanın genişlik sınırı (varsayılan 720)

import 'package:flutter/material.dart';

import '../models/word_model.dart';

class CustomBody extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<Word> filtered;
  final int totalCount;
  final double maxWidth;

  const CustomBody({
    super.key,
    required this.isLoading,
    required this.error,
    required this.filtered,
    required this.totalCount,
    this.maxWidth = 720,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text('Hata: $error'))
              : filtered.isEmpty
              ? const Center(child: Text('Sonuç bulunamadı.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sonuç: ${filtered.length} / $totalCount',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final w = filtered[i];
                          return ListTile(
                            dense: true,
                            title: Text(
                              w.sirpca,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(w.turkce),
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
}
