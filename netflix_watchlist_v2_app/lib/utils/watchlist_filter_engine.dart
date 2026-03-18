// 📁 <----- lib/utils/watchlist_filter_engine.dart ----->
//
// ============================================================================
// 🧠 WatchlistFilterEngine – Film & Dizi Filtreleme Motoru
// ============================================================================
//
// Bu yardımcı sınıf Netflix izleme listesindeki:
//
// • film listesi
// • dizi listesi
//
// üzerinde arama ve filtreleme işlemlerini merkezi olarak yapar.
//
// Böylece:
//
// ❌ HomePage içinde uzun filtre kodları olmaz
// ❌ filtreleme mantığı UI içine karışmaz
//
// Bunun yerine:
//
// ✅ filtre mantığı tek dosyada olur
// ✅ test etmek kolaylaşır
// ✅ yeni filtre eklemek kolay olur
//
// ---------------------------------------------------------------------------
// 📌 Kullanım
// ---------------------------------------------------------------------------
//
// final result = WatchlistFilterEngine.apply(
//   searchQuery: searchQuery,
//   filter: filter,
//   allMovies: allMovies,
//   allSeries: allSeries,
// );
//
// movies = result.movies;
// series = result.series;
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
/// Filtreleme sonucunda dönen modeldir.
///
/// İçerir:
///
/// • movies → filtrelenmiş film listesi
/// • series → filtrelenmiş dizi listesi
///
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
/// Film ve diziler için arama + filtre işlemlerini yapan motor.
///
/// Bu sınıf statik metotlardan oluşur.
/// State tutmaz.
///
/// ============================================================================
class WatchlistFilterEngine {

  /// =========================================================================
  /// 🚀 apply()
  /// =========================================================================
  ///
  /// Tüm filtreleme işlemini başlatan ana fonksiyondur.
  ///
  /// Parametreler:
  ///
  /// • searchQuery → kullanıcı arama metni
  /// • filter → aktif filtre
  /// • allMovies → tüm film listesi
  /// • allSeries → tüm dizi listesi
  ///
  /// İşleyiş:
  ///
  /// 1️⃣ arama uygulanır
  /// 2️⃣ filtre uygulanır
  ///
  /// =========================================================================
  static WatchlistFilterResult apply({

    required String searchQuery,
    required FilterOption filter,
    required List<NetflixItem> allMovies,
    required List<SeriesGroup> allSeries,

  }) {

    final query = searchQuery.toLowerCase().trim();

    final searchedMovies = _applyMovieSearch(
      movies: allMovies,
      query: query,
    );

    final searchedSeries = _applySeriesSearch(
      series: allSeries,
      query: query,
    );

    return _applyFilterOption(
      filter: filter,
      movies: searchedMovies,
      series: searchedSeries,
    );
  }



  /// =========================================================================
  /// 🎬 Film Araması
  /// =========================================================================
  ///
  /// Film başlığı üzerinden arama yapar.
  ///
  /// =========================================================================
  static List<NetflixItem> _applyMovieSearch({

    required List<NetflixItem> movies,
    required String query,

  }) {

    if (query.isEmpty) {
      return List.from(movies);
    }

    return movies.where((movie) {

      return movie.title
          .toLowerCase()
          .contains(query);

    }).toList();
  }

  /// =========================================================================
  /// 📺 Dizi Araması
  /// =========================================================================
  ///
  /// Arama alanları:
  ///
  /// • dizi adı
  /// • bölüm adı
  ///
  /// =========================================================================
  static List<SeriesGroup> _applySeriesSearch({

    required List<SeriesGroup> series,
    required String query,

  }) {

    if (query.isEmpty) {
      return List.from(series);
    }

    return series.where((group) {

      final seriesMatch =
      group.seriesName
          .toLowerCase()
          .contains(query);

      final episodeMatch = group.seasons.any(

            (season) => season.episodes.any(

              (ep) => ep.title
              .toLowerCase()
              .contains(query),

        ),

      );

      return seriesMatch || episodeMatch;

    }).toList();
  }



  /// =========================================================================
  /// 🎛 Filtre Seçeneği Uygulama
  /// =========================================================================
  ///
  /// Kullanıcının seçtiği FilterOption değerine göre
  /// listeyi sınırlar.
  ///
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
  /// 🕒 Son 30 Gün Filtresi
  /// =========================================================================
  ///
  /// Son 30 gün içinde izlenen içerikleri döndürür.
  ///
  /// Filmler:
  /// movie.date
  ///
  /// Diziler:
  /// en son izlenen bölüm tarihi
  ///
  /// =========================================================================
  static WatchlistFilterResult _filterLast30Days({

    required List<NetflixItem> movies,
    required List<SeriesGroup> series,

  }) {

    final now = DateTime.now();

    final last30Days =
    now.subtract(
      const Duration(days: 30),
    );


    final filteredMovies = movies.where((movie) {

      final date = parseDate(movie.date);

      return date.isAfter(last30Days);

    }).toList();



    final filteredSeries = series.where((group) {

      final latestDate = group.seasons
          .expand((s) => s.episodes)
          .map((ep) => parseDate(ep.date))
          .reduce((a, b) => a.isAfter(b) ? a : b);

      return latestDate.isAfter(last30Days);

    }).toList();


    return WatchlistFilterResult(

      movies: filteredMovies,
      series: filteredSeries,

    );
  }

}