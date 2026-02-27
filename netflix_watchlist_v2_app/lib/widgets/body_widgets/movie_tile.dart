// ============================================================================
// 🎞 MovieTile – Tekil Film Satırı
// ============================================================================
//
// Bu widget tek bir filmi temsil eder.
// Poster, başlık, tarih ve (varsa) OMDb bilgilerini gösterir.
//
// ---------------------------------------------------------------------------
// 🔹 Özellikleri
// ---------------------------------------------------------------------------
// • Küçük poster thumbnail (varsa).
// • Alt satırda: izlenme tarihi + (yıl / tür / IMDB rating).
// • onTap → OMDb lazy load tetikler (üst katmandan gelen callback).
// • onLongPress → Hero + tam ekran poster viewer.
// • PosterViewerPage içinde swipe-to-close ve tap-to-close vardır.
//
// ---------------------------------------------------------------------------
// Amaç:
// Film UI mantığını CustomBody / MovieSection’dan ayırarak modüler yapı sağlamak.
// ============================================================================

import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../models/netflix_item.dart';
import '../../screens/poster_viewer_page.dart';
import '../../utils/csv_parser.dart';

/// =========================================================================
/// 🎞 MovieTile
/// =========================================================================
/// Tek bir filmi ListTile üzerinde gösterir.
///
/// Not:
/// - OMDb çağrısı burada yapılmaz.
/// - Bu widget sadece UI üretir ve kullanıcının etkileşimini
///   üst katmana (HomePage/CustomBody) callback ile iletir.
///
/// Bu yaklaşım sayesinde:
/// ✅ Network/State yönetimi HomePage veya OmdbLazyLoader’da kalır
/// ✅ MovieTile saf UI bileşeni olarak sade kalır
/// =========================================================================
class MovieTile extends StatelessWidget {
  /// Gösterilecek film verisi.
  final NetflixItem movie;

  /// Light/Dark tema ayrımı için üst katmandan gelir.
  /// Light theme ’de kart arka planı/ikon/text rengi belirgin olsun diye kullanılır.
  final bool isLightTheme;

  /// Kullanıcı filme dokunduğunda tetiklenir.
  /// Genellikle: OmdbLazyLoader.loadOmdbIfNeeded(movie) gibi bir akış çağrılır.
  final ValueChanged<NetflixItem> onMovieTap;

  const MovieTile({
    super.key,
    required this.movie,
    required this.isLightTheme,
    required this.onMovieTap,
  });

  /// =========================================================================
  /// 🏷 Hero Tag (benzersiz anahtar)
  /// =========================================================================
  /// Poster büyütme ekranına geçerken Hero animasyonunun doğru çalışması için
  /// benzersiz bir tag gerekir.
  ///
  /// Öncelik:
  /// 1) imdbId varsa (en güvenilir benzersiz id)
  /// 2) yoksa title + date kombinasyonu
  ///
  /// Böylece:
  /// - Aynı isimli filmler çakışmaz
  /// - Aynı film farklı tarihlerde izlendiyse ayrı kayıtlar da çakışmaz
  /// =========================================================================
  String get _heroTag {
    final id = movie.imdbId;
    if (id != null && id.isNotEmpty) return "poster_$id";
    return "poster_${movie.title}_${movie.date}";
  }

  /// =========================================================================
  /// 🖼 Poster Thumbnail (leading)
  /// =========================================================================
  /// Film poster ’i varsa küçük bir thumbnail gösterir.
  /// Yoksa standart movie ikonu gösterilir.
  ///
  /// errorBuilder:
  /// - URL bozuksa veya yükleme başarısız olursa icon ’a düşer
  /// =========================================================================
  Widget _buildLeading() {
    final poster = movie.poster;

    if (poster == null || poster.isEmpty) {
      return const Icon(Icons.movie);
    }

    return Hero(
      tag: _heroTag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          poster,
          width: 50,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const Icon(Icons.movie),
        ),
      ),
    );
  }

  /// =========================================================================
  /// 🧾 Alt metin (subtitle) üretimi
  /// =========================================================================
  /// 1. satır: Tarih (Netflix CSV formatı → DD/MM/YYYY)
  /// 2. satır: Yıl + Tür + IMDb rating
  ///
  /// rating boşsa "..." gösterir (kullanıcı dokununca yüklenebilir).
  /// =========================================================================
  String _buildSubtitle() {
    final watchDate = formatDate(parseDate(movie.date));

    final year = (movie.year ?? '').trim();
    final genre = (movie.genre ?? '').trim();
    final rating = (movie.rating ?? '...').trim();

    // Boşlukları daha temiz birleştirelim
    final metaParts = <String>[];
    if (year.isNotEmpty) metaParts.add(year);
    if (genre.isNotEmpty) metaParts.add(genre);

    final meta = metaParts.join(' ');
    final imdbLine = "IMDB: $rating";

    return meta.isEmpty
        ? "$watchDate\n$imdbLine"
        : "$watchDate\n$meta  $imdbLine";
  }

  /// =========================================================================
  /// 🖼 Poster tam ekran aç (long press)
  /// =========================================================================
  /// Poster varsa PosterViewerPage’e gider.
  /// Poster yoksa hiçbir şey yapmaz (sessizce return).
  ///
  /// Route:
  /// - PageRouteBuilder ile transparan/opaque:false
  /// - FadeTransition ile yumuşak açılış
  /// =========================================================================
  void _openPosterViewer(BuildContext context) {
    final poster = movie.poster;
    if (poster == null || poster.isEmpty) return;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, _, _) =>
            PosterViewerPage(heroTag: _heroTag, posterUrl: poster),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// Film satırını üretir:
  ///  • leading: poster veya movie ikonu
  ///  • title: film adı
  ///  • subtitle: tarih + (yıl / tür / rating)
  ///  • onTap: OMDb yükleme callback ’i
  ///  • onLongPress: poster viewer (Hero + swipe-to-close)
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    final tileTextColor = isLightTheme ? Colors.black : null;

    return Container(
      color: isLightTheme ? cardLightColor : null,
      child: ListTile(
        iconColor: tileTextColor,
        textColor: tileTextColor,

        leading: _buildLeading(),
        title: Text(movie.title),
        subtitle: Text(_buildSubtitle()),

        /// Film satırına dokununca üst katmana sinyal gönder:
        /// (ör. OMDb lazy load tetiklenecek)
        onTap: () => onMovieTap(movie),

        /// Uzun basınca poster büyütme
        onLongPress: () => _openPosterViewer(context),
      ),
    );
  }
}
