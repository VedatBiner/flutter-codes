// 📁 <----- lib/utils/watchlist_filter_engine.dart ----->
//
// ============================================================================
// 🧠 WatchlistFilterEngine – Arama ve Filtreleme Motoru
// ============================================================================
//
// Bu yardımcı yapı, film ve dizi listelerini:
//
// • arama metni
// • seçili filtre
//
// bilgilerine göre yeniden hesaplar.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// Filtreleme mantığını HomePage içinden çıkarıp tek bir yerde toplamak.
//
// Böylece:
// • HomePage sadeleşir
// • test etmek kolaylaşır
// • yeni filtre eklemek kolaylaşır
//
// ============================================================================

import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import 'csv_parser.dart';

/// ============================================================================
/// 📦 WatchlistFilterResult
/// ============================================================================
///
/// Filtreleme sonrası dönen sonucu temsil eder.
///
/// • movies → filtrelenmiş film listesi
/// • series → filtrelenmiş dizi listesi
/// ============================================================================
class WatchlistFilterResult {
  final List<NetflixItem> movies;
  final List<SeriesGroup> series;

  const WatchlistFilterResult({
    required this.movies,
    required this.series,
  });
}

/// ============================================================================
/// 🧠 WatchlistFilterEngine
/// ============================================================================
///
/// Film ve dizi listeleri üzerinde arama + filtre uygular.
/// ============================================================================
class WatchlistFilterEngine {
  /// =========================================================================
  /// 🔍 apply()
  /// =========================================================================
  ///
  /// Girilen arama metni ve filtre seçeneğine göre
  /// film ve dizi listelerini yeniden hesaplar.
  ///
  /// İşleyiş:
  /// 1) Önce arama metni uygulanır
  /// 2) Sonra seçili filtre uygulanır
  /// 3) Sonuç WatchlistFilterResult olarak döner
  ///
  /// Arama mantığı:
  /// • Filmler → sadece title içinde arar
  /// • Diziler  → dizi adında veya bölüm adlarında arar
  ///
  /// Filtre mantığı:
  /// • all        → her şeyi göster
  /// • movies     → sadece filmler
  /// • series     → sadece diziler
  /// • last30days → son 30 gün içindeki içerikler
  /// =========================================================================
  static WatchlistFilterResult apply({
    required String searchQuery,
    required FilterOption filter,
    required List<NetflixItem> allMovies,
    required List<SeriesGroup> allSeries,
  }) {
    final query = searchQuery.toLowerCase().trim();

    List<NetflixItem> filteredMovies = _applyMovieSearch(
      allMovies: allMovies,
      query: query,
    );

    List<SeriesGroup> filteredSeries = _applySeriesSearch(
      allSeries: allSeries,
      query: query,
    );

    final filtered = _applyFilterOption(
      filter: filter,
      movies: filteredMovies,
      series: filteredSeries,
    );

    return WatchlistFilterResult(
      movies: filtered.movies,
      series: filtered.series,
    );
  }

  /// =========================================================================
  /// 🎬 _applyMovieSearch()
  /// =========================================================================
  ///
  /// Film listesinde başlığa göre arama yapar.
  /// =========================================================================
  static List<NetflixItem> _applyMovieSearch({
    required List<NetflixItem> allMovies,
    required String query,
  }) {
    if (query.isEmpty) return List<NetflixItem>.from(allMovies);

    return allMovies.where((movie) {
      return movie.title.toLowerCase().contains(query);
    }).toList();
  }

  /// =========================================================================
  /// 📺 _applySeriesSearch()
  /// =========================================================================
  ///
  /// Dizi listesinde:
  /// • dizi adı
  /// • bölüm adı
  ///
  /// alanlarında arama yapar.
  /// =========================================================================
  static List<SeriesGroup> _applySeriesSearch({
    required List<SeriesGroup> allSeries,
    required String query,
  }) {
    if (query.isEmpty) return List<SeriesGroup>.from(allSeries);

    return allSeries.where((group) {
      final seriesMatch = group.seriesName.toLowerCase().contains(query);

      final episodeMatch = group.seasons.any(
            (season) => season.episodes.any(
              (episode) => episode.title.toLowerCase().contains(query),
        ),
      );

      return seriesMatch || episodeMatch;
    }).toList();
  }

  /// =========================================================================
  /// 🎛 _applyFilterOption()
  /// =========================================================================
  ///
  /// Seçili filtre seçeneğine göre film ve dizi listelerini sınırlar.
  /// =========================================================================
  static WatchlistFilterResult _applyFilterOption({
    required FilterOption filter,
    required List<NetflixItem> movies,
    required List<SeriesGroup> series,
  }) {
    switch (filter) {
      case FilterOption.all:
        return WatchlistFilterResult(
          movies: movies,
          series: series,
        );

      case FilterOption.movies:
        return WatchlistFilterResult(
          movies: movies,
          series: const [],
        );

      case FilterOption.series:
        return WatchlistFilterResult(
          movies: const [],
          series: series,
        );

      case FilterOption.last30days:
        return _filterLast30Days(
          movies: movies,
          series: series,
        );
    }
  }

  /// =========================================================================
  /// 🕒 _filterLast30Days()
  /// =========================================================================
  ///
  /// Son 30 gün içindeki:
  /// • filmleri
  /// • en az bir bölümü son 30 günde izlenmiş dizileri
  ///
  /// döndürür.
  /// =========================================================================
  static WatchlistFilterResult _filterLast30Days({
    required List<NetflixItem> movies,
    required List<SeriesGroup> series,
  }) {
    final now = DateTime.now();
    final last30 = now.subtract(const Duration(days: 30));

    final filteredMovies = movies.where((movie) {
      return parseDate(movie.date).isAfter(last30);
    }).toList();

    final filteredSeries = series.where((group) {
      final latestEpisodeDate = group.seasons
          .expand((season) => season.episodes)
          .map((episode) => parseDate(episode.date))
          .reduce((a, b) => a.isAfter(b) ? a : b);

      return latestEpisodeDate.isAfter(last30);
    }).toList();

    return WatchlistFilterResult(
      movies: filteredMovies,
      series: filteredSeries,
    );
  }
}