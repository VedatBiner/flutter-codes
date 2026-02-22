// ============================================================================
// 📺 SeriesSection – Diziler Bölümü
// ============================================================================
//
// Bu widget Diziler ExpansionTile kartını oluşturur.
// İçerisinde her dizi için SeriesTile öğeleri bulunur.
//
// ---------------------------------------------------------------------------
// 🔹 Sorumlulukları
// ---------------------------------------------------------------------------
// 1️⃣ Dizi başlığını ve toplam sayıyı gösterir.
// 2️⃣ SeriesTile öğelerini listeler.
// 3️⃣ Expansion controller yönetimi yapar.
// 4️⃣ Filmler bölümü ile karşılıklı aç/kapa kontrolü sağlar.
//
// Not:
//  • OMDb yükleme, poster gösterimi, long-press poster viewer vb. detaylar
//    SeriesTile içinde çözülür. Bu dosya sadece “section layout” sorumludur.
//
// ============================================================================
import 'package:flutter/material.dart';

import '../../models/series_models.dart';
import 'series_tile.dart';

/// =========================================================================
/// 📺 SeriesSection
/// =========================================================================
/// “Diziler” bölümünün kartını ve üst ExpansionTile’ını üretir.
///
/// İçerik:
///  • Diziler başlığı + toplam dizi sayısı
///  • Her dizi için SeriesTile listesi
///
/// Sorumluluk:
///  • Section seviyesinde layout & tema renkleri
///  • Series listesi için ListView üretmek
///  • Expansion controller ’ı dışarıdan alıp kullanmak
///  • Diziler açılınca diğer section ’ı kapatacak callback ’i tetiklemek
/// =========================================================================
class SeriesSection extends StatelessWidget {
  final List<SeriesGroup> series;
  final ExpansibleController seriesController;

  /// Diziler açılınca filmleri kapatmak için
  final VoidCallback onExpand;

  const SeriesSection({
    super.key,
    required this.series,
    required this.seriesController,
    required this.onExpand,
  });

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// Diziler kartını ve ExpansionTile içeriğini oluşturur.
  ///
  /// • Light theme ’de kırmızı tonlu bir başlık arka planı kullanılır.
  /// • Dark theme ’de varsayılan tema renkleri korunur.
  ///
  /// Expansion davranışı:
  /// • Diziler section açılırken (isExpanding==true) → onExpand() çağrılır.
  ///   Böylece Filmler bölümü otomatik kapanır.
  ///
  /// Liste alanı:
  /// • İçteki ListView, ekran yüksekliğinin %55’i ile sınırlandırılır.
  ///   (Aksi halde ExpansionTile içeriği sonsuz yükseklik isteyebilir.)
  ///
  /// Not:
  /// • Dizi detayları (poster/OMDb/long press) SeriesTile içinde yönetilir.
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        controller: seriesController,
        onExpansionChanged: (isExpanding) {
          if (isExpanding) onExpand();
        },
        collapsedBackgroundColor: isLightTheme ? Colors.red : null,
        backgroundColor: isLightTheme ? Colors.red.shade700 : null,
        childrenPadding: isLightTheme
            ? const EdgeInsets.all(2)
            : EdgeInsets.zero,
        iconColor: isLightTheme ? Colors.white : null,
        collapsedIconColor: isLightTheme ? Colors.white : null,
        title: Text(
          "Diziler (${series.length})",
          style: isLightTheme
              ? const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              : null,
        ),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView.separated(
              itemCount: series.length,
              separatorBuilder: (_, _) =>
                  Divider(color: Colors.grey.shade300, height: 1),
              itemBuilder: (context, index) =>
                  SeriesTile(group: series[index], isLightTheme: isLightTheme),
            ),
          ),
        ],
      ),
    );
  }
}
