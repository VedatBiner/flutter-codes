// <----- lib/utils/csv_parser.dart ----->

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../constants/file_info.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';

class ParsedNetflixData {
  final List<NetflixItem> movies;
  final List<SeriesGroup> series;

  ParsedNetflixData({required this.movies, required this.series});
}

/// Tarih parse (MM/DD/YY → DateTime)
DateTime parseDate(String date) {
  final p = date.split("/");
  final month = int.parse(p[0]);
  final day = int.parse(p[1]);
  final year = 2000 + int.parse(p[2]); // 25 → 2025
  return DateTime(year, month, day);
}

/// Tarihi DD/MM/YYYY formatında yaz
String formatDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, "0");
  final mm = d.month.toString().padLeft(2, "0");
  final yyyy = d.year.toString();
  return "$dd/$mm/$yyyy";
}

class CsvParser {
  static Future<ParsedNetflixData> parseCsvFast() async {
    final raw = await rootBundle.loadString(
      "assets/database/$assetsFileNameCsv",
    );

    final List<Map<String, String>> rows =
        await compute<String, List<Map<String, String>>>(_parseCsvIsolate, raw);

    List<NetflixItem> movies = [];
    Map<String, Map<int, List<EpisodeItem>>> seriesMap = {};

    for (final row in rows) {
      final title = row['title']!;
      final date = row['date']!;

      if (_isSeriesTitle(title)) {
        final parts = title.split(":");
        final seriesName = _normalizeSeriesName(parts[0].trim());

        int season = 1;
        String epTitle;

        if (parts.length > 2) {
          final rawSeason = parts[1].replaceAll(RegExp(r'[^0-9]'), '');
          season = int.tryParse(rawSeason) ?? 1;
          epTitle = parts[2].trim();
        } else if (parts.length == 2) {
          final part2 = parts[1].trim();
          if (part2.toLowerCase().startsWith('sezon')) {
            final rawSeason = part2.replaceAll(RegExp(r'[^0-9]'), '');
            season = int.tryParse(rawSeason) ?? 1;
            epTitle = "Bölüm";
          } else {
            epTitle = part2;
          }
        } else {
          epTitle = "Bölüm";
        }

        seriesMap.putIfAbsent(seriesName, () => {});
        seriesMap[seriesName]!.putIfAbsent(season, () => []);
        seriesMap[seriesName]![season]!.add(EpisodeItem(title: epTitle, date: date));
      } else {
        movies.add(NetflixItem(title: title, date: date, type: "movie"));
      }
    }

    movies.sort((a, b) => parseDate(b.date).compareTo(parseDate(a.date)));

    List<SeriesGroup> seriesGroups = [];
    seriesMap.forEach((seriesName, seasonMap) {
      List<SeasonGroup> seasons = [];
      seasonMap.forEach((seasonNumber, episodes) {
        episodes.sort((a, b) => parseDate(b.date).compareTo(parseDate(a.date)));
        seasons.add(SeasonGroup(seasonNumber: seasonNumber, episodes: episodes));
      });
      seasons.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));
      seriesGroups.add(SeriesGroup(seriesName: seriesName, seasons: seasons));
    });

    seriesGroups.sort((a, b) {
      final lastA = a.seasons.expand((s) => s.episodes).map((e) => parseDate(e.date)).reduce((x, y) => x.isAfter(y) ? x : y);
      final lastB = b.seasons.expand((s) => s.episodes).map((e) => parseDate(e.date)).reduce((x, y) => x.isAfter(y) ? x : y);
      return lastB.compareTo(lastA);
    });

    return ParsedNetflixData(movies: movies, series: seriesGroups);
  }

  static List<Map<String, String>> _parseCsvIsolate(String raw) {
    final rows = const CsvToListConverter().convert(raw, eol: "\n");
    if (rows.isNotEmpty) rows.removeAt(0);
    return rows.map((r) => {'title': r[0].toString().trim(), 'date': r[1].toString().trim()}).toList();
  }

  static bool _isSeriesTitle(String title) {
    final t = title.toLowerCase();
    if (t.contains("mini dizi") || t.contains("sezon")) return true;
    if (":".allMatches(title).length >= 2) return true;

    if (title.contains(":")) {
      final parts = title.split(":");
      if (parts.length > 1) {
        final subtitle = parts[1].trim();
        final wordCount = subtitle.split(" ").where((s) => s.isNotEmpty).length;
        if (wordCount < 4) {
          return true;
        }
      }
    }
    return false;
  }

  static String _normalizeSeriesName(String name) {
    return name.replaceAll(RegExp(r"\s*mini dizi\s*", caseSensitive: false), "").trim();
  }
}
