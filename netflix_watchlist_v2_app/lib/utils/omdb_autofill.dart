// <----- lib/utils/omdb_autofill.dart ----->

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants/file_info.dart';
import '../models/netflix_item.dart';

class OmdbAutoFill {
  static const tag = "omdb_autofill";

  /// 🔥 SADECE FİLMLER için OMDb doldurulur
  static Future<void> fillMissingData(List<NetflixItem> movies) async {
    int completed = 0;

    for (final movie in movies) {
      // ------------------------------------------------------
      // 1️⃣ Dizi bölümleri tamamen atlanacak
      // ------------------------------------------------------
      if (movie.type == "series" || movie.type == "episode") {
        log("⏭ Dizi bölümü atlandı: ${movie.title}", name: tag);
        continue;
      }

      // ------------------------------------------------------
      // 2️⃣ Zaten OMDb bilgisi olanlar atlanır
      // ------------------------------------------------------
      if (movie.imdbId != null &&
          movie.imdbId!.isNotEmpty &&
          movie.poster != null &&
          movie.poster!.isNotEmpty) {
        continue;
      }

      // ------------------------------------------------------
      // 3️⃣ OMDb API çağrısı (sadece FİLM)
      // ------------------------------------------------------
      final url =
          "https://www.omdbapi.com/?apikey=$apiKey&t=${Uri.encodeComponent(movie.title)}";

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data["Response"] == "True") {
            movie.originalTitle = data["Title"];
            movie.year = data["Year"];
            movie.genre = data["Genre"];
            movie.rating = data["imdbRating"];
            movie.poster = data["Poster"];
            movie.type = data["Type"];
            movie.imdbId = data["imdbID"];

            completed++;
            log("⭐ OMDb OK (${movie.title}) → ${movie.imdbId}", name: tag);
          } else {
            log("❌ OMDb bulunamadı: ${movie.title}", name: tag);
          }
        }
      } catch (e) {
        log("⚠️ OMDb hata: $e", name: tag);
      }

      // Free API rate limit
      await Future.delayed(const Duration(milliseconds: 400));
    }

    log(
      "🎉 OMDb Auto-Fill tamamlandı → $completed film güncellendi",
      name: tag,
    );
  }
}
