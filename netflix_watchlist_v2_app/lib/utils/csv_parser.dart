// <----- lib/utils/csv_parser.dart ----->
//
// ============================================================================
// 📄 CsvParser – Netflix CSV Okuma ve Yapılandırma Motoru
// ============================================================================
//
// Bu dosya, Netflix izleme geçmişi CSV dosyasını okuyup uygulamanın
// kullanabileceği yapılara dönüştürmekten sorumludur.
//
// ---------------------------------------------------------------------------
// 🎯 Ana Amaç
// ---------------------------------------------------------------------------
// CSV içindeki ham satır verisini:
//
// • film listesine
// • dizi / sezon / bölüm yapısına
//
// dönüştürmek.
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Rol
// ---------------------------------------------------------------------------
// Bu dosya sadece veri ayrıştırma (parsing) ve yapılandırma işini yapar.
// UI üretmez.
// Bildirim göstermez.
// Widget içermez.
//
// Yani bu dosyanın görevi:
// • CSV oku
// • satırları çözümle
// • film mi dizi mi karar ver
// • tarihleri parse et
// • verileri sıralı model listelerine dönüştür
//
// ---------------------------------------------------------------------------
// ⚙️ Performans Notu
// ---------------------------------------------------------------------------
// Ağır CSV işleme mantığı `_parseAndStructureData()` fonksiyonunda toplanmıştır.
// Bu fonksiyon `compute()` ile ayrı isolate içinde çalıştırılır.
//
// Böylece:
// ✅ ana thread bloklanmaz
// ✅ UI donmaz
// ✅ büyük CSV dosyalarında performans korunur
//
// ============================================================================

// import 'package:csv/csv.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../constants/file_info.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';


// ============================================================================
// 📦 ParsedNetflixData
// ============================================================================
//
// CSV parse işlemi tamamlandıktan sonra dönen sonuç modelidir.
//
// İçerdiği alanlar:
//
// • movies → filme dönüştürülen kayıtlar
// • series → dizi/sezon/bölüm yapısına dönüştürülen kayıtlar
//
// Bu model HomePage gibi üst katmanlara tek nesne halinde döndürülür.
//
// ============================================================================
class ParsedNetflixData {
  final List<NetflixItem> movies;
  final List<SeriesGroup> series;

  ParsedNetflixData({
    required this.movies,
    required this.series,
  });
}


// ============================================================================
// 🛡 _minDate()
// ============================================================================
//
// Geçersiz veya parse edilemeyen tarihleri sıralama sırasında en sona atmak için
// kullanılan güvenli minimum tarih döndürür.
//
// Neden gerekli?
// CSV içindeki bazı tarih alanları bozuk veya beklenmeyen formatta olabilir.
// Böyle durumlarda exception atmak yerine güvenli fallback kullanılır.
//
// ============================================================================
DateTime _minDate() => DateTime.fromMillisecondsSinceEpoch(0);


// ============================================================================
// 📅 parseDate()
// ============================================================================
//
// Netflix CSV içindeki tarihi DateTime nesnesine çevirir.
//
// Desteklenen formatlar:
//
// • MM/DD/YY
// • MM/DD/YYYY
//
// Örnek:
//   "03/14/24"   -> DateTime(2024, 3, 14)
//   "03/14/2024" -> DateTime(2024, 3, 14)
//
// Geçersiz veri gelirse _minDate() döner.
//
// Neden böyle?
// • Uygulama çökmemeli
// • Geçersiz tarihler sıralamada en sona düşmeli
//
// ============================================================================
DateTime parseDate(String date) {
  final raw = date.trim();
  final p = raw.split("/");

  if (p.length != 3) return _minDate();

  final month = int.tryParse(p[0]) ?? 0;
  final day = int.tryParse(p[1]) ?? 0;

  // YY veya YYYY olabilir
  final yRaw = int.tryParse(p[2]) ?? 0;
  final year = (yRaw < 100) ? (2000 + yRaw) : yRaw;

  // Basit validasyon
  if (month < 1 || month > 12) return _minDate();
  if (day < 1 || day > 31) return _minDate();
  if (year < 1900 || year > 2100) return _minDate();

  return DateTime(year, month, day);
}


// ============================================================================
// 🗓 formatDate()
// ============================================================================
//
// DateTime nesnesini DD/MM/YYYY formatında metne çevirir.
//
// Örnek:
//   DateTime(2024, 3, 14) -> "14/03/2024"
//
// Bu fonksiyon özellikle:
// • UI gösteriminde
// • export sırasında
// tarih formatını standartlaştırmak için kullanılır.
//
// ============================================================================
String formatDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, "0");
  final mm = d.month.toString().padLeft(2, "0");
  final yyyy = d.year.toString();
  return "$dd/$mm/$yyyy";
}


// ============================================================================
// 🧹 _normalizeSeriesName()
// ============================================================================
//
// Dizi adındaki gereksiz ekleri temizler.
//
// Şu anda özellikle:
// • "mini dizi"
//
// ifadesi temizlenmektedir.
//
// Amaç:
// Aynı dizinin farklı yazılmış kayıtlarını tek isim altında toplamak.
//
// Örnek:
//   "Dark mini dizi" -> "Dark"
//
// ============================================================================
String _normalizeSeriesName(String name) {
  return name
      .replaceAll(
    RegExp(r"\s*mini dizi\s*", caseSensitive: false),
    "",
  )
      .trim();
}


// ============================================================================
// 🔍 _isSeriesTitle()
// ============================================================================
//
// Bir başlığın film mi yoksa dizi mi olduğunu anlamaya çalışır.
//
// Karar kuralları:
//
// 1) "bölüm", "sezon", "mini dizi" gibi ifadeler varsa → dizi
// 2) Birden fazla ":" varsa → dizi
// 3) Başlık ön eki birden çok kez tekrar etmişse → dizi
//
// Neden gerekli?
// Netflix CSV ’de her kayıt açık biçimde "film" ya da "series" diye gelmeyebilir.
// Bu yüzden başlıktan çıkarım yapılır.
//
// ============================================================================
bool _isSeriesTitle(String title, Set<String> seriesPrefixes) {
  final t = title.toLowerCase();

  if (t.contains("bölüm") ||
      t.contains("sezon") ||
      t.contains("mini dizi")) {
    return true;
  }

  if (":".allMatches(title).length >= 2) {
    return true;
  }

  if (title.contains(':')) {
    final prefix = title.split(':')[0].trim();

    if (seriesPrefixes.contains(prefix)) {
      return true;
    }
  }

  return false;
}


// ============================================================================
// 🕒 _latestEpisodeDate()
// ============================================================================
//
// Bir dizi grubundaki tüm bölümler arasında en güncel tarihi bulur.
//
// Kullanım amacı:
// Dizileri “en son izlenen” tarihe göre sıralamak.
//
// Eğer hiç bölüm yoksa _minDate() döner.
//
// ============================================================================
DateTime _latestEpisodeDate(SeriesGroup g) {
  final allEpisodes = g.seasons.expand((s) => s.episodes);

  if (allEpisodes.isEmpty) {
    return _minDate();
  }

  DateTime latest = _minDate();

  for (final ep in allEpisodes) {
    final d = parseDate(ep.date);
    if (d.isAfter(latest)) {
      latest = d;
    }
  }

  return latest;
}


// ============================================================================
// 🧠 _parseAndStructureData()
// ============================================================================
//
// Tüm ağır CSV işleme mantığını içeren üst düzey fonksiyondur.
// Bu fonksiyon `compute()` tarafından ayrı isolate ’te çalıştırılır.
//
// İş akışı:
//
// 1) CSV raw string → satır listesi
// 2) Başlık satırı kaldırılır
// 3) Her satır map yapısına çevrilir
// 4) Ön analiz ile dizi prefix ’leri bulunur
// 5) Her kayıt film/dizi olarak sınıflandırılır
// 6) Filmler listeye eklenir
// 7) Diziler season / episode yapısına dönüştürülür
// 8) Tüm sonuçlar sıralanır
//
// Önemli:
// Burada `CsvToListConverter()` const olmadan kullanılır.
// Senin ortamında const constructor hatası oluşuyordu.
//
// ============================================================================
ParsedNetflixData _parseAndStructureData(String raw) {
  final rows = CsvToListConverter().convert(raw, eol: "\n");

  // Başlık satırını kaldır
  if (rows.isNotEmpty) {
    rows.removeAt(0);
  }

  final List<Map<String, String>> rowMaps = rows.map((r) {
    return {
      'title': r[0].toString().trim(),
      'date': r[1].toString().trim(),
    };
  }).toList();

  // 1️⃣ Ön analiz: tekrar eden prefix ’leri bul
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

  // 2️⃣ Sınıflandırma ve yapılandırma
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
      seriesMap[seriesName]![season]!.add(
        EpisodeItem(title: epTitle, date: date),
      );
    } else {
      movies.add(
        NetflixItem(
          title: title,
          date: date,
          type: "movie",
        ),
      );
    }
  }

  // 3️⃣ Filmleri sırala (en yeni → en eski)
  movies.sort((a, b) => parseDate(b.date).compareTo(parseDate(a.date)));

  // 4️⃣ seriesMap → model listesi
  final List<SeriesGroup> seriesGroups = [];

  seriesMap.forEach((seriesName, seasonMap) {
    final List<SeasonGroup> seasons = [];

    seasonMap.forEach((seasonNumber, episodes) {
      episodes.sort((a, b) => parseDate(b.date).compareTo(parseDate(a.date)));
      seasons.add(
        SeasonGroup(
          seasonNumber: seasonNumber,
          episodes: episodes,
        ),
      );
    });

    seasons.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

    seriesGroups.add(
      SeriesGroup(
        seriesName: seriesName,
        seasons: seasons,
      ),
    );
  });

  // 5️⃣ Dizileri en güncel izlenme tarihine göre sırala
  seriesGroups.sort(
        (a, b) => _latestEpisodeDate(b).compareTo(_latestEpisodeDate(a)),
  );

  return ParsedNetflixData(
    movies: movies,
    series: seriesGroups,
  );
}


// ============================================================================
// 📄 CsvParser
// ============================================================================
//
// Uygulamanın dışarıya açılan CSV parse servisidir.
//
// parseCsvFast():
// • assets içindeki CSV ’yi okur
// • `_parseAndStructureData` fonksiyonunu compute ile arka planda çalıştırır
//
// Böylece büyük dosyalarda bile UI akıcı kalır.
//
// ============================================================================
class CsvParser {
  static Future<ParsedNetflixData> parseCsvFast() async {
    final raw = await rootBundle.loadString(
      "assets/database/$assetsFileNameCsv",
    );

    return compute<String, ParsedNetflixData>(
      _parseAndStructureData,
      raw,
    );
  }
}