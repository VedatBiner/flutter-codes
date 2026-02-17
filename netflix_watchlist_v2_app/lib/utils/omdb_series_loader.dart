import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants/file_info.dart';
import '../models/series_models.dart';

class OmdbSeriesLoader {
  static const tag = "omdb_series";

  static Future<void> loadSeriesIfNeeded(SeriesGroup group) async {
    // ✅ Cache: imdbId veya originalTitle varsa yüklenmiş say
    if ((group.imdbId != null && group.imdbId!.isNotEmpty) ||
        (group.originalTitle != null && group.originalTitle!.isNotEmpty)) {
      log("⏭ Series OMDb zaten yüklü: ${group.seriesName}", name: tag);
      return;
    }

    try {
      // 1) t= ile dene (type=series)
      final url = Uri.parse(
        "https://www.omdbapi.com/?t=${Uri.encodeQueryComponent(group.seriesName)}&apikey=$apiKey&type=series",
      );
      log("🌐 OMDb (series t=): $url", name: tag);

      final res = await http.get(url).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) {
        log("❌ HTTP ${res.statusCode}", name: tag);
        return;
      }

      final data = jsonDecode(res.body);
      if (data["Response"] == "True") {
        _apply(group, data);
        log("✅ Series OMDb yüklendi (t=): ${group.originalTitle}", name: tag);
        return;
      }

      // 2) fallback: s= ara, imdbID ile detay çek
      log("⚠️ t= ile bulunamadı, fallback s= deneniyor: ${group.seriesName}", name: tag);

      final searchUrl = Uri.parse(
        "https://www.omdbapi.com/?s=${Uri.encodeQueryComponent(group.seriesName)}&apikey=$apiKey&type=series",
      );
      log("🌐 OMDb (series s=): $searchUrl", name: tag);

      final searchRes = await http.get(searchUrl).timeout(const Duration(seconds: 8));
      if (searchRes.statusCode != 200) return;

      final searchData = jsonDecode(searchRes.body);
      if (searchData["Response"] != "True" || searchData["Search"] == null) {
        log("⚠️ s= ile de bulunamadı: ${group.seriesName}", name: tag);
        return;
      }

      final first = (searchData["Search"] as List).first;
      final imdbId = first["imdbID"];

      final byIdUrl = Uri.parse("https://www.omdbapi.com/?i=$imdbId&apikey=$apiKey");
      log("🌐 OMDb (series i=): $byIdUrl", name: tag);

      final detailRes = await http.get(byIdUrl).timeout(const Duration(seconds: 8));
      if (detailRes.statusCode != 200) return;

      final detailData = jsonDecode(detailRes.body);
      if (detailData["Response"] != "True") return;

      _apply(group, detailData);
      log("✅ Series OMDb yüklendi (fallback): ${group.originalTitle}", name: tag);
    } catch (e, st) {
      log("🚨 Series OMDb hatası: $e", name: tag, error: e, stackTrace: st);
    }
  }

  static void _apply(SeriesGroup group, dynamic data) {
    group.originalTitle = data["Title"];
    group.year = data["Year"];
    group.genre = data["Genre"];
    group.rating = data["imdbRating"];
    group.type = data["Type"];
    group.imdbId = data["imdbID"];

    final poster = data["Poster"];
    group.poster = (poster is String && poster != "N/A") ? poster : null;
  }
}
