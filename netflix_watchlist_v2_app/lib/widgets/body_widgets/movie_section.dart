// ============================================================================
// 🎬 MovieSection – Filmler Bölümü
// ============================================================================
//
// Bu widget Filmler ExpansionTile kartını oluşturur.
// İçerisinde film listesi ve MovieTile öğeleri yer alır.
//
// ---------------------------------------------------------------------------
// 🔹 Sorumlulukları
// ---------------------------------------------------------------------------
// 1️⃣ Filmler başlığını gösterir.
// 2️⃣ Film sayısını dinamik olarak yazar.
// 3️⃣ MovieTile öğelerini liste halinde render eder.
// 4️⃣ Expansion controller ile diğer section 'ı kapatır.
//
// ---------------------------------------------------------------------------
// UI Özellikleri:
// • Light mode 'da indigo renkli başlık.
// • Hero animasyon destekli poster thumbnail.
// • Uzun basınca tam ekran poster açılır.
//
// ============================================================================
import 'package:flutter/material.dart';

import '../../models/netflix_item.dart';
import 'movie_tile.dart';

/// =========================================================================
/// 🎬 MovieSection
/// =========================================================================
/// “Filmler” bölümünün kartını ve üst ExpansionTile’ını üretir.
///
/// İçerik:
///  • Filmler başlığı + toplam film sayısı
///  • Her film için MovieTile listesi
///
/// Sorumluluk:
///  • Section seviyesinde tema renkleri ve layout
///  • Listeyi üretmek
///  • Controller üzerinden aç/kapa kontrolünü dışarıdan almak
/// =========================================================================
class MovieSection extends StatelessWidget {
  final List<NetflixItem> movies;
  final ExpansibleController moviesController;
  final VoidCallback onExpand;
  final ValueChanged<NetflixItem> onMovieTap;

  const MovieSection({
    super.key,
    required this.movies,
    required this.moviesController,
    required this.onExpand,
    required this.onMovieTap,
  });

  /// =========================================================================
  /// 🎬 MovieSection
  /// =========================================================================
  /// “Filmler” bölümünün kartını ve üst ExpansionTile’ını üretir.
  ///
  /// İçerik:
  ///  • Filmler başlığı + toplam film sayısı
  ///  • Her film için MovieTile listesi
  ///
  /// Sorumluluk:
  ///  • Section seviyesinde tema renkleri ve layout
  ///  • Listeyi üretmek
  ///  • Controller üzerinden aç/kapa kontrolünü dışarıdan almak
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        controller: moviesController,
        onExpansionChanged: (isExpanding) {
          if (isExpanding) onExpand();
        },
        backgroundColor: isLightTheme ? Colors.indigo.shade700 : null,
        collapsedBackgroundColor: isLightTheme ? Colors.indigo : null,
        childrenPadding: isLightTheme ? const EdgeInsets.all(2) : EdgeInsets.zero,
        iconColor: isLightTheme ? Colors.white : null,
        collapsedIconColor: isLightTheme ? Colors.white : null,
        title: Text(
          "Filmler (${movies.length})",
          style: isLightTheme
              ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              : null,
        ),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView.separated(
              itemCount: movies.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade300, height: 1),
              itemBuilder: (context, index) => MovieTile(
                movie: movies[index],
                isLightTheme: isLightTheme,
                onMovieTap: onMovieTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
