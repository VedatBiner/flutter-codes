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

/// Güvenli min tarih (invalid tarihleri en sona atmak için)
DateTime _minDate() => DateTime.fromMillisecondsSinceEpoch(0);

/// Tarih parse (MM/DD/YY veya MM/DD/YYYY → DateTime)
DateTime parseDate(String date) {
  final raw = date.trim();
  final p = raw.split("/");

  if (p.length != 3) return _minDate();

  final month = int.tryParse(p[0]) ?? 0;
  final day = int.tryParse(p[1]) ?? 0;

  // YY veya YYYY olabilir
  final yRaw = int.tryParse(p[2]) ?? 0;
  final year = (yRaw < 100) ? (2000 + yRaw) : yRaw;

  // Basit validasyon (0 olursa DateTime exception olmasın)
  if (month < 1 || month > 12) return _minDate();
  if (day < 1 || day > 31) return _minDate();
  if (year < 1900 || year > 2100) return _minDate();

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

/// Bir SeriesGroup içindeki en güncel episode tarihini güvenli şekilde bulur.
DateTime _latestEpisodeDate(SeriesGroup g) {
  final allEpisodes = g.seasons.expand((s) => s.episodes);
  if (allEpisodes.isEmpty) return _minDate();

  DateTime latest = _minDate();
  for (final ep in allEpisodes) {
    final d = parseDate(ep.date);
    if (d.isAfter(latest)) latest = d;
  }
  return latest;
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
  final List<NetflixItem> movies = [];
  final Map<String, Map<int, List<EpisodeItem>>> seriesMap = {};

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

  // Filmleri en yeni -> en eski sırala
  movies.sort((a, b) => parseDate(b.date).compareTo(parseDate(a.date)));

  // Series map -> model list
  final List<SeriesGroup> seriesGroups = [];
  seriesMap.forEach((seriesName, seasonMap) {
    final List<SeasonGroup> seasons = [];
    seasonMap.forEach((seasonNumber, episodes) {
      episodes.sort((a, b) => parseDate(b.date).compareTo(parseDate(a.date)));
      seasons.add(SeasonGroup(seasonNumber: seasonNumber, episodes: episodes));
    });
    seasons.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));
    seriesGroups.add(SeriesGroup(seriesName: seriesName, seasons: seasons));
  });

  // Dizileri en güncel izlenen -> daha eski sırala (güvenli)
  seriesGroups.sort((a, b) => _latestEpisodeDate(b).compareTo(_latestEpisodeDate(a)));

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
