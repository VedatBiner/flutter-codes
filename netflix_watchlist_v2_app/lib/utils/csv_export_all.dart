// <----- lib/utils/csv_export_all.dart ----->
//
// 🎬 Netflix Film List App
// Filmler + Diziler → TEK CSV
// • Global A→Z sıralama
// • OMDb bilgileri + IMDB linki dahil
// • Tarihler dd/MM/yy formatında
// • Category en sondaki sütun
// • CSV otomatik Downloads/{appName} içine taşınır
//

import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import 'download_directory_helper.dart';
import 'omdb_autofill.dart';

/// 📌 CSV tarih formatı dönüştürme (MM/DD/YY → DD/MM/YY)
String formatCsvDate(String raw) {
  try {
    final parts = raw.split("/");

    if (parts.length != 3) return raw;

    final month = parts[0].padLeft(2, '0');
    final day = parts[1].padLeft(2, '0');
    final year = parts[2].length == 4 ? parts[2].substring(2) : parts[2];

    return "$day/$month/$year";
  } catch (_) {
    return raw;
  }
}

/// 📦 Filmler + Diziler tek CSV olarak dışa aktarılır (GLOBAL A→Z)
Future<File?> exportAllToCsv(
    List<NetflixItem> movies,
    List<SeriesGroup> series,
    ) async {
  const tag = "csv_export";

  try {
    // ---------------------------------------------------------
    // 🔥 0) CSV export ’tan önce OMDb Auto-Fill çalıştır
    // ---------------------------------------------------------
    log("⏳ OMDb Auto-Fill başlıyor...", name: tag);
    await OmdbAutoFill.fillMissingData(movies);
    log("✅ OMDb Auto-Fill bitti. CSV üretimine geçiliyor.", name: tag);

    final buffer = StringBuffer();

    // 1️⃣ CSV başlığı (CATEGORY en sonda + IMDB LINK EKLENDİ)
    buffer.writeln(
      "Series Name,Season,Episode,Title,Original Title,Date,Year,Genre,IMDB Rating,Poster,Type,IMDB Link,Category",
    );

    // ---------------------------------------------------------
    // 2️⃣ Global karma liste (film + dizi)
    // ---------------------------------------------------------
    final List<Map<String, dynamic>> allEntries = [];

    // 🎬 Filmler
    for (final m in movies) {
      final imdbLink = (m.imdbId != null && m.imdbId!.isNotEmpty)
          ? "https://www.imdb.com/title/${m.imdbId}/"
          : "";

      allEntries.add({
        "sortKey": m.title.toLowerCase(),
        "series": "",
        "season": "",
        "episode": "",
        "title": m.title.replaceAll(",", " "),
        "original": (m.originalTitle ?? "").replaceAll(",", " "),
        "date": formatCsvDate(m.date),
        "year": m.year ?? "",
        "genre": (m.genre ?? "").replaceAll(",", " "),
        "rating": m.rating ?? "",
        "poster": m.poster ?? "",
        "type": m.type ?? "movie",
        "imdb": imdbLink,
        "category": "movie",
      });
    }

    // 📺 Diziler
    for (final group in series) {
      final seriesName = group.seriesName.replaceAll(",", " ");

      for (final season in group.seasons) {
        for (int i = 0; i < season.episodes.length; i++) {
          final ep = season.episodes[i];
          final episodeNumber = i + 1;

          allEntries.add({
            "sortKey": seriesName.toLowerCase(),
            "series": seriesName,
            "season": season.seasonNumber.toString(),
            "episode": episodeNumber.toString(),
            "title": ep.title.replaceAll(",", " "),
            "original": "",
            "date": formatCsvDate(ep.date),
            "year": "",
            "genre": "",
            "rating": "",
            "poster": "",
            "type": "episode",
            "imdb": "",
            "category": "series",
          });
        }
      }
    }

    // ---------------------------------------------------------
    // 3️⃣ Global alfabetik sıralama
    // ---------------------------------------------------------
    allEntries.sort((a, b) => a["sortKey"].compareTo(b["sortKey"]));

    // ---------------------------------------------------------
    // 4️⃣ CSV'ye satır satır yaz
    // ---------------------------------------------------------
    for (final row in allEntries) {
      buffer.writeln(
        [
          row["series"],
          row["season"],
          row["episode"],
          row["title"],
          row["original"],
          row["date"],
          row["year"],
          row["genre"],
          row["rating"],
          row["poster"],
          row["type"],
          row["imdb"], // ⭐ IMDB Link eklendi
          row["category"], // ⭐ En son sütun
        ].join(","),
      );
    }

    // ---------------------------------------------------------
    // 5️⃣ CSV'yi app_flutter içine yaz
    // ---------------------------------------------------------
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, fileNameCsv));

    await file.writeAsString(buffer.toString());
    log("💾 CSV oluşturuldu: ${file.path}", name: tag);

    // ---------------------------------------------------------
    // 6️⃣ Downloads/{appName} içine kopyala
    // ---------------------------------------------------------
    final downloadFolder = await prepareDownloadDirectory(tag: tag);

    if (downloadFolder != null) {
      final target = File(join(downloadFolder.path, fileNameCsv));
      await file.copy(target.path);
      log("📁 CSV taşındı → ${target.path}", name: tag);
    } else {
      log("⚠️ Download klasörü hazırlanılamadı!", name: tag);
    }

    return file;
  } catch (e, st) {
    log("🚨 CSV export hatası: $e", name: tag, stackTrace: st);
    return null;
  }
}