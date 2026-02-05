// 📁 lib/utils/search_and_filter.dart
import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import 'csv_parser.dart';

Map<String, dynamic> applySearchAndFilter({
  required String searchQuery,
  required FilterOption filter,
  required List<NetflixItem> allMovies,
  required List<SeriesGroup> allSeries,
}) {
  final q = searchQuery.toLowerCase().trim();

  List<NetflixItem> filteredMovies = allMovies.where((m) {
    return q.isEmpty || m.title.toLowerCase().contains(q);
  }).toList();

  List<SeriesGroup> filteredSeries = allSeries.where((s) {
    final seriesMatch = s.seriesName.toLowerCase().contains(q);
    final episodeMatch = s.seasons.any(
          (season) => season.episodes.any((ep) => ep.title.toLowerCase().contains(q)),
    );
    return q.isEmpty ? true : (seriesMatch || episodeMatch);
  }).toList();

  final now = DateTime.now();
  final last30 = now.subtract(const Duration(days: 30));

  if (filter == FilterOption.movies) {
    filteredSeries = [];
  } else if (filter == FilterOption.series) {
    filteredMovies = [];
  } else if (filter == FilterOption.last30days) {
    filteredMovies = filteredMovies
        .where((m) => parseDate(m.date).isAfter(last30))
        .toList();

    filteredSeries = filteredSeries.where((s) {
      // Tüm episode 'ları düzleştir
      final allEpisodes = s.seasons.expand((season) => season.episodes);

      // Hiç episode yoksa bu diziyi ele
      if (allEpisodes.isEmpty) return false;

      // En güncel episode tarihini bul (güvenli)
      DateTime latest = DateTime.fromMillisecondsSinceEpoch(0);
      for (final ep in allEpisodes) {
        final d = parseDate(ep.date);
        if (d.isAfter(latest)) latest = d;
      }

      return latest.isAfter(last30);
    }).toList();
  }

  return {
    'movies': filteredMovies,
    'series': filteredSeries,
  };
}
