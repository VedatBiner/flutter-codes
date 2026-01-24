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

    /// compute → isolate içinde CSV satırlarını çıkarır
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
          // Format: "Series: Season X: Episode"
          final rawSeason = parts[1]
              .replaceAll("Sezon", "")
              .replaceAll(".", "")
              .replaceAll("Mini Dizi", "")
              .trim();
          season = int.tryParse(rawSeason) ?? 1;
          epTitle = parts[2].trim();
        } else if (parts.length == 2) {
          // Format: "Series: Episode" or "Series: Season X"
          final part2 = parts[1].trim();
          final rawSeason = part2
              .replaceAll("Sezon", "")
              .replaceAll(".", "")
              .replaceAll("Mini Dizi", "")
              .trim();
          final parsedSeason = int.tryParse(rawSeason);

          if (part2.toLowerCase().contains('sezon') && parsedSeason != null) {
            season = parsedSeason;
            epTitle = "Bölüm"; // Default episode name
          } else {
            epTitle = part2;
          }
        } else {
          // Format: "Series" (e.g. from "My Mini Dizi")
          epTitle = "Bölüm";
        }

        seriesMap.putIfAbsent(seriesName, () => {});
        seriesMap[seriesName]!.putIfAbsent(season, () => []);

        seriesMap[seriesName]![season]!.add(
          EpisodeItem(title: epTitle, date: date),
        );
      } else {
        // ----------------------------------------------------------
        // 🎬 FİLM
        // ----------------------------------------------------------
        movies.add(NetflixItem(title: title, date: date, type: "movie"));
      }
    }

    // 🔥 Filmleri en son izlenene göre sırala
    movies.sort((a, b) {
      return parseDate(b.date).compareTo(parseDate(a.date));
    });

    // 🔥 Dizileri oluştur
    List<SeriesGroup> seriesGroups = [];

    seriesMap.forEach((seriesName, seasonMap) {
      List<SeasonGroup> seasons = [];

      seasonMap.forEach((seasonNumber, episodes) {
        // Bölümleri tarihe göre sırala
        episodes.sort((a, b) {
          return parseDate(b.date).compareTo(parseDate(a.date));
        });

        seasons.add(
          SeasonGroup(seasonNumber: seasonNumber, episodes: episodes),
        );
      });

      seasons.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

      seriesGroups.add(SeriesGroup(seriesName: seriesName, seasons: seasons));
    });

    // 🔥 Dizileri tüm bölümlerin en yeni tarihine göre sırala
    seriesGroups.sort((a, b) {
      final lastA = a.seasons
          .expand((s) => s.episodes)
          .map((e) => parseDate(e.date))
          .reduce((x, y) => x.isAfter(y) ? x : y);

      final lastB = b.seasons
          .expand((s) => s.episodes)
          .map((e) => parseDate(e.date))
          .reduce((x, y) => x.isAfter(y) ? x : y);

      return lastB.compareTo(lastA);
    });

    return ParsedNetflixData(movies: movies, series: seriesGroups);
  }

  /// isolate fonksiyonu (sadece CSV satırlarını çıkarır)
  static List<Map<String, String>> _parseCsvIsolate(String raw) {
    final rows = const CsvToListConverter().convert(raw, eol: "\n");

    if (rows.isNotEmpty) rows.removeAt(0);

    return rows
        .map(
          (r) => {
        'title': r[0].toString().trim(),
        'date': r[1].toString().trim(),
      },
    )
        .toList();
  }

  /// 📺 Dizi tespiti
  /// - "Sezon" geçenler
  /// - "Mini Dizi" geçenler
  /// - ":" içerenler
  static bool _isSeriesTitle(String title) {
    final t = title.toLowerCase();

    if (t.contains("mini dizi")) return true;
    if (t.contains("sezon")) return true;

    // Örn: Dizi: Bölüm
    if (title.contains(":")) return true;

    return false;
  }

  /// 🔧 "Mini Dizi" ifadesini dizi adından temizler
  static String _normalizeSeriesName(String name) {
    return name
        .replaceAll(RegExp(r"\s*mini dizi\s*", caseSensitive: false), "")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();
  }
}
