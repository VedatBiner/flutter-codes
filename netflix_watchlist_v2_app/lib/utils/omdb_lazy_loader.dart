// <----- lib/utils/omdb_lazy_loader.dart ----->

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants/file_info.dart';
import '../models/netflix_item.dart';

/// OMDb API isteklerini gereksiz yere tekrar yapmamak için
/// sadece filmde bilgi yoksa çağrı yapılır.
class OmdbLazyLoader {
  static const tag = "omdb_lazy";

  /// Bir filme ait OMDb bilgileri henüz yoksa API’den yükler.
  static Future<void> loadOmdbIfNeeded(NetflixItem item) async {
    // ✅ Cache kriteri: imdbId veya originalTitle varsa "yüklenmiş" kabul et.
    if ((item.imdbId != null && item.imdbId!.isNotEmpty) ||
        (item.originalTitle != null && item.originalTitle!.isNotEmpty)) {
      log("⏭ OMDb zaten yüklü: ${item.title}", name: tag);
      return;
    }

    try {
      // 1) Önce title ile dene
      final url = Uri.parse(
        "https://www.omdbapi.com/?t=${Uri.encodeQueryComponent(item.title)}&apikey=$apiKey&type=movie",
      );

      log("🌐 OMDb çağrılıyor (t=): $url", name: tag);

      final response = await http.get(url);
      if (response.statusCode != 200) {
        log("❌ OMDb Hatası: HTTP ${response.statusCode}", name: tag);
        return;
      }

      final data = jsonDecode(response.body);

      // ✅ Başarılıysa direkt yaz
      if (data["Response"] == "True") {
        _applyOmdbData(item, data);
        log("✅ OMDb yüklendi (t=): ${item.originalTitle}", name: tag);
        return;
      }

      // 2) Bulunamadıysa fallback: s= ile ara, ilk sonucu al, imdbID ile detay çek
      log("⚠️ t= ile bulunamadı, fallback (s=) deneniyor: ${item.title}", name: tag);

      final searchUrl = Uri.parse(
        "https://www.omdbapi.com/?s=${Uri.encodeQueryComponent(item.title)}&apikey=$apiKey&type=movie",
      );

      log("🌐 OMDb çağrılıyor (s=): $searchUrl", name: tag);

      final searchRes = await http.get(searchUrl);
      if (searchRes.statusCode != 200) {
        log("❌ OMDb Search Hatası: HTTP ${searchRes.statusCode}", name: tag);
        return;
      }

      final searchData = jsonDecode(searchRes.body);

      if (searchData["Response"] != "True" || searchData["Search"] == null) {
        log("⚠️ s= ile de bulunamadı: ${item.title}", name: tag);
        return;
      }

      final first = (searchData["Search"] as List).first;
      final imdbId = first["imdbID"];

      final byIdUrl = Uri.parse(
        "https://www.omdbapi.com/?i=$imdbId&apikey=$apiKey",
      );

      log("🌐 OMDb çağrılıyor (i=): $byIdUrl", name: tag);

      final detailRes = await http.get(byIdUrl);
      if (detailRes.statusCode != 200) {
        log("❌ OMDb Detail Hatası: HTTP ${detailRes.statusCode}", name: tag);
        return;
      }

      final detailData = jsonDecode(detailRes.body);

      if (detailData["Response"] != "True") {
        log("⚠️ imdbID ile de bulunamadı: $imdbId", name: tag);
        return;
      }

      _applyOmdbData(item, detailData);
      log("✅ OMDb yüklendi (fallback): ${item.originalTitle}", name: tag);
    } catch (e, st) {
      log("🚨 OMDb yükleme hatası: $e", name: tag, error: e, stackTrace: st);
    }
  }

  static void _applyOmdbData(NetflixItem item, dynamic data) {
    item.originalTitle = data["Title"];
    item.year = data["Year"];
    item.genre = data["Genre"];
    item.rating = data["imdbRating"];
    item.type = data["Type"];
    item.imdbId = data["imdbID"];

    final poster = data["Poster"];
    item.poster = (poster is String && poster != "N/A") ? poster : null;
  }
}
