// <----- lib/utils/omdb_lazy_loader.dart ----->

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../file_info.dart';
import '../models/netflix_item.dart';

class OmdbLazyLoader {
  static const String omdbApiKey = apiKey;

  static final Map<String, Map<String, dynamic>> _cache = {};

  static Future<void> loadOmdbIfNeeded(NetflixItem item) async {
    if (item.omdbLoaded) return;

    final query = item.title.split(":")[0].trim();

    if (_cache.containsKey(query)) {
      item.applyOmdb(_cache[query]!);
      return;
    }

    try {
      final url = Uri.parse(
        "https://www.omdbapi.com/?t=$query&apikey=$omdbApiKey",
      );

      final response = await http.get(url).timeout(const Duration(seconds: 3));

      final json = jsonDecode(response.body);

      if (json["Response"] == "True") {
        _cache[query] = json;
        item.applyOmdb(json);
      }
    } catch (_) {
      // timeout / rate limit / ağ hatası → uygulamayı kilitlemesin
    }
  }
}
