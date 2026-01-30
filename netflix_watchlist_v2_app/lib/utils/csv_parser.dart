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
  if (p.length != 3) return DateTime.now();
  final month = int.tryParse(p[0]) ?? 0;
  final day = int.tryParse(p[1]) ?? 0;
  final year = (int.tryParse(p[2]) ?? 0) + 2000;
  return DateTime(year, month, day);
}

/// Tarihi DD/MM/YYYY formatında yaz
String formatDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, "0");
  final mm = d.month.toString().padLeft(2, "0");
  final yyyy = d.year.toString();
  return "$dd/$mm/$yyyy";
}

/// Dizi adından "mini dizi" gibi ekleri temizler.
String _normalizeSeriesName(String name) {
  return name.replaceAll(RegExp(r"\s*mini dizi\s*", caseSensitive: false), "").trim();
}

/// Dizi başlığını tespit etmek için kullanılan yardımcı fonksiyon.
bool _isSeriesTitle(String title, Set<String> seriesPrefixes) {
  final t = title.toLowerCase();

  // 1. Kesin anahtar kelimelerle kontrol et.
  if (t.contains("bölüm") || t.contains("sezon") || t.contains("mini dizi")) {
    return true;
  }
  // 2. Birden fazla ":" içerenler her zaman dizidir (örn: Dizi: Sezon: Bölüm).
  if (":".allMatches(title).length >= 2) {
    return true;
  }

  if (title.contains(':')) {
    final prefix = title.split(':')[0].trim();

    // 3. Ön analizde birden çok kez tekrarlandığı tespit edilen başlıklar dizidir.
    if (seriesPrefixes.contains(prefix)) {
      return true;
    }
  }

  return false;
}

/// Performans için tüm CSV işleme mantığını içeren üst düzey fonksiyon.
/// Bu fonksiyon `compute` tarafından ayrı bir isolate 'te çalıştırılır.
ParsedNetflixData _parseAndStructureData(String raw) {
  final rows = const CsvToListConverter().convert(raw, eol: "\n");
  if (rows.isNotEmpty) rows.removeAt(0); // Başlık satırını kaldır

  final List<Map<String, String>> rowMaps = rows
      .map((r) => {
            'title': r[0].toString().trim(),
            'date': r[1].toString().trim(),
          })
      .toList();

  // 1. Ön Analiz: Tekrar eden başlıkları (dizi adlarını) bul.
  final prefixCounts = <String, int>{};
  for (final row in rowMaps) {
    final title = row['title']!;
    if (title.contains(':')) {
      final prefix = title.split(':')[0].trim();
      prefixCounts.update(prefix, (value) => value + 1, ifAbsent: () => 1);
    }
  }
  final seriesPrefixes = prefixCounts.entries
      .where((entry) => entry.value > 1)
      .map((entry) => entry.key)
      .toSet();

  // 2. Sınıflandırma ve Yapılandırma
  List<NetflixItem> movies = [];
  Map<String, Map<int, List<EpisodeItem>>> seriesMap = {};

  for (final row in rowMaps) {
    final title = row['title']!;
    final date = row['date']!;

    if (_isSeriesTitle(title, seriesPrefixes)) {
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

class CsvParser {
  static Future<ParsedNetflixData> parseCsvFast() async {
    final raw = await rootBundle.loadString(
      "assets/database/$assetsFileNameCsv",
    );
    // Tüm ağır işi (parsing, structuring, sorting) `compute` ile arka plana taşı.
    return compute<String, ParsedNetflixData>(_parseAndStructureData, raw);
  }
}
