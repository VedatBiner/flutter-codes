// ============================================================================
// 🌐 OMDbSeriesLoader – Dizi Metadata Servisi
// ============================================================================
//
// Bu yardımcı servis OMDb API üzerinden dizi bilgilerini çeker.
//
// ---------------------------------------------------------------------------
// 🔹 Çalışma Mantığı
// ---------------------------------------------------------------------------
// 1️⃣ Önce title (t=) ile doğrudan sorgu yapar.
// 2️⃣ Bulamazsa search (s=) ile arar.
// 3️⃣ İlk sonucu imdbID ile detay (i=) çağrısı yapar.
// 4️⃣ Poster "N/A" ise null döndürür.
// 5️⃣ Map verisini OmdbSeriesInfo modeline dönüştürür.
//
// ---------------------------------------------------------------------------
// Amaç:
// Film ve dizi metadata yükleme mantığını UI ’dan ayırmak.
//
// ============================================================================
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../constants/file_info.dart';
import '../models/series_models.dart';

class OmdbSeriesLoader {
  static const tag = "omdb_series";

  static Future<void> loadIfNeeded(SeriesGroup group) async {
    // Zaten yüklüyse çık
    if (group.imdbId != null && group.imdbId!.isNotEmpty) {
      log("⏭ Dizi zaten yüklü: ${group.seriesName}", name: tag);
      return;
    }

    try {
      final title = Uri.encodeQueryComponent(group.seriesName);

      // 1️⃣ Direkt arama (type=series önemli!)
      final url = Uri.parse(
        "https://www.omdbapi.com/?t=$title&type=series&apikey=$apiKey",
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data["Response"] == "False") {
        // 2️⃣ Fallback search
        final searchUrl = Uri.parse(
          "https://www.omdbapi.com/?s=$title&type=series&apikey=$apiKey",
        );

        final searchRes = await http.get(searchUrl);
        final searchData = jsonDecode(searchRes.body);

        if (searchData["Search"] == null) {
          log("❌ OMDb bulamadı: ${group.seriesName}", name: tag);
          return;
        }

        final firstSeries = searchData["Search"]
            .firstWhere((e) => e["Type"] == "series");

        final imdbId = firstSeries["imdbID"];

        final detailUrl = Uri.parse(
          "https://www.omdbapi.com/?i=$imdbId&apikey=$apiKey",
        );

        final detailRes = await http.get(detailUrl);
        final detailData = jsonDecode(detailRes.body);

        _applyData(group, detailData);
        return;
      }

      _applyData(group, data);
    } catch (e) {
      log("🚨 OMDb series error: $e", name: tag);
    }
  }

  static void _applyData(SeriesGroup group, Map<String, dynamic> data) {
    group.originalTitle = data["Title"];
    group.year = data["Year"];
    group.genre = data["Genre"];
    group.rating = data["imdbRating"];
    group.type = data["Type"];
    group.imdbId = data["imdbID"];

    final poster = data["Poster"];
    group.poster = (poster != null && poster != "N/A") ? poster : null;

    log("✅ Dizi yüklendi: ${group.originalTitle}", name: tag);
  }
}