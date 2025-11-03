// 📃 <----- lib/widgets/loading_card.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Bu widget, veri yükleme (import veya sync) işlemi sırasında
// kullanıcıya görsel bir geri bildirim sağlar.
//
// Özellikler:
//  • İlerleme çubuğu (LinearProgressIndicator)
//  • Şu anda yüklenen öğe adı (isteğe bağlı)
//  • Geçen süre göstergesi (saniye)
//  • Tema: koyu zemin + kırmızı vurgu
//
// Kullanım:
//   LoadingCard(
//     progress: 0.45,
//     currentItem: "Example.json",
//     elapsed: Duration(seconds: 32),
//   )
//
// -----------------------------------------------------------

import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  /// 0.0 → 1.0 arasında ilerleme değeri
  final double progress;

  /// Şu anda yüklenen dosya veya öğe (isteğe bağlı)
  final String? currentItem;

  /// Geçen süre (isteğe bağlı)
  final Duration? elapsed;

  /// Kartın başlığı (örnek: “Veriler yükleniyor...”)
  final String title;

  const LoadingCard({
    super.key,
    required this.progress,
    this.currentItem,
    this.elapsed,
    this.title = "Veriler yükleniyor...",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // 🔹 İlerleme çubuğu
              LinearProgressIndicator(
                value: progress,
                color: Colors.redAccent,
                backgroundColor: Colors.white12,
                minHeight: 6,
              ),

              const SizedBox(height: 8),

              // 🔹 O anda yüklenen öğe (isteğe bağlı)
              if (currentItem != null)
                Text(
                  '📦 Şu anda: $currentItem',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),

              const SizedBox(height: 6),

              // 🔹 Geçen süre (isteğe bağlı)
              if (elapsed != null)
                Text(
                  '⏱️ Geçen süre: ${elapsed!.inSeconds} sn',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
