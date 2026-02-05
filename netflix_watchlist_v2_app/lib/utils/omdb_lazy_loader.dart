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
    // ✅ Daha doğru cache kriteri:
    // imdbId veya originalTitle varsa bu öğeyi "yüklenmiş" kabul et.
    if ((item.imdbId != null && item.imdbId!.isNotEmpty) ||
        (item.originalTitle != null && item.originalTitle!.isNotEmpty)) {
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
      item.originalTitle = data["Title"];
      item.year = data["Year"];
      item.genre = data["Genre"];
      item.rating = data["imdbRating"];
      item.type = data["Type"];
      item.imdbId = data["imdbID"];

      final poster = data["Poster"];
      item.poster = (poster is String && poster != "N/A") ? poster : null;

      log("✅ OMDb yüklendi: ${item.originalTitle}", name: tag);
    } catch (e, st) {
      log("🚨 OMDb yükleme hatası: $e", name: tag, error: e, stackTrace: st);
    }
  }
}
