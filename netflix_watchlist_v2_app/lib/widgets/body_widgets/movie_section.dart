// ============================================================================
// 🎬 MovieSection – Filmler Bölümü (ExpansionTile Kartı)
// ============================================================================
//
// Bu widget, ana ekrandaki “Filmler” bölümünün tamamını (kart + ExpansionTile)
// oluşturmaktan sorumludur.
//
// ---------------------------------------------------------------------------
// Neden ayrı dosya?
// ---------------------------------------------------------------------------
// MovieSection, sadece “section-level” (bölüm seviyesinde) sorumlulukları taşır:
//  ✅ Başlık + film sayısı
//  ✅ ExpansionTile görünümü (light/dark tema renkleri, padding, ikon rengi)
//  ✅ Film listesini üretmek (ListView.separated)
//  ✅ Açılınca diğer bölümü kapatmak için dışarıdan gelen onExpand callback ’ini çağırmak
//
// Filmin detayları (OMDb yükleme, poster thumbnail, long press Hero viewer vb.)
// bu dosyada değil, MovieTile içinde yönetilir.
//
// ---------------------------------------------------------------------------
// Veri akışı (kısaca)
// ---------------------------------------------------------------------------
// HomePage/CustomBody  →  MovieSection(movies, controller, onExpand, onMovieTap)
// MovieSection         →  MovieTile(movie, onMovieTap)
//
// onMovieTap: Film satırına dokunulduğunda OMDb lazy-load başlatmak için
// üst katmana sinyal taşır (MovieTile içinden çağrılır).
// ============================================================================
import 'package:flutter/material.dart';

import '../../models/netflix_item.dart';
import 'movie_tile.dart';

/// =========================================================================
/// 🎬 MovieSection
/// =========================================================================
/// “Filmler” bölüm kartını oluşturur.
/// - ExpansionTile başlığı: “Filmler (N)”
/// - İçerik: MovieTile listesi
///
/// Bu widget stateless ’tir; çünkü:
/// - Liste verisi (movies) üst katmandan gelir.
/// - Aç/kapa yönetimi controller + callback ile dışarıda yapılır.
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
  /// 🏗 build
  /// =========================================================================
  /// Filmler bölümünü Card içinde bir ExpansionTile olarak üretir.
  ///
  /// Light mode davranışı:
  /// - Başlık arka planı indigo tonlarında
  /// - İkonlar ve başlık yazısı beyaz
  ///
  /// Dark mode davranışı:
  /// - Renkleri temanın varsayılanlarına bırakır (null verilir)
  ///
  /// Expansion akışı:
  /// - Kullanıcı “Filmler”i açarsa onExpand() çağrılır.
  ///   (Bu sayede üst katman Diziler bölümünü collapse edebilir.)
  ///
  /// İçerik alanı:
  /// - ListView.separated ile MovieTile listesi
  /// - Yüksekliği ekranın %55’i (kayan içerik için sabit bir alan)
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        controller: moviesController,

        /// Section açılınca diğer section ’ı kapat.
        onExpansionChanged: (isExpanding) {
          if (isExpanding) onExpand();
        },

        /// Light theme ’de belirgin görünüm veriyoruz.
        backgroundColor: isLightTheme ? Colors.indigo.shade700 : null,
        collapsedBackgroundColor: isLightTheme ? Colors.indigo : null,
        childrenPadding: isLightTheme
            ? const EdgeInsets.all(2)
            : EdgeInsets.zero,
        iconColor: isLightTheme ? Colors.white : null,
        collapsedIconColor: isLightTheme ? Colors.white : null,

        /// Başlık (film sayısı dinamik)
        title: Text(
          "Filmler (${movies.length})",
          style: isLightTheme
              ? const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              : null,
        ),

        /// İçerik: MovieTile listesi
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
