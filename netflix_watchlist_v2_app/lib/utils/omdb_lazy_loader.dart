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

  /// Bir filme ait OMDb bilgileri henüz yoksa API ’den yükler.
  static Future<void> loadOmdbIfNeeded(NetflixItem item) async {
    /// Eğer daha önce yüklenmişse API çağrısı yapma
    if (item.originalTitle != null ||
        item.year != null ||
        item.genre != null ||
        item.rating != null ||
        item.poster != null) {
      log("⏭ OMDb zaten yüklü: ${item.title}", name: tag);
      return;
    }

    try {
      final url = Uri.parse(
        "https://www.omdbapi.com/?t=${Uri.encodeQueryComponent(item.title)}&apikey=$apiKey",
      );

      log("🌐 OMDb çağrılıyor: $url", name: tag);

      final response = await http.get(url);

      if (response.statusCode != 200) {
        log("❌ OMDb Hatası: HTTP ${response.statusCode}", name: tag);
        return;
      }

      final data = jsonDecode(response.body);

      if (data["Response"] == "False") {
        log("⚠️ OMDb bulamadı: ${item.title}", name: tag);
        return;
      }

      // -----------------------------
      // 🔥 OMDb VERİLERİNİ FİLME YAZ
      // -----------------------------
      item.originalTitle = data["Title"]; // 🎬 Orijinal isim
      item.year = data["Year"];
      item.genre = data["Genre"];
      item.rating = data["imdbRating"];
      item.poster = data["Poster"];
      item.type = data["Type"]; // movie / series
      item.imdbId = data["imdbID"]; // ⭐ IMDB ID

      log("✅ OMDb yüklendi: ${item.originalTitle}", name: tag);
    } catch (e, st) {
      log("🚨 OMDb yükleme hatası: $e", name: tag, error: e, stackTrace: st);
    }
  }
}
