// 📃 <----- lib/utils/imdb_fetcher.dart ----->
//
// 🎬 IMDb / OMDb Verisi Getirici
// Netflix geçmişindeki başlıkları IMDb ’den sorgular ve
// türüne göre (film / dizi) ayırır.
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants/file_info.dart';

// 🎬 Tür enum 'u (movie / series / episode)
enum ImdbTitleType { movie, series, episode, unknown }

class ImdbFetcher {
  static const _baseUrl = 'https://www.omdbapi.com/';

  /// 🔍 IMDb ’den başlığa göre bilgi getirir.
  Future<Map<String, dynamic>?> fetchInfo(String title) async {
    final tag = 'imdb_fetcher';
    try {
      final uri = Uri.parse(
        '$_baseUrl?t=${Uri.encodeComponent(title)}&apikey=$apiKey',
      );

      final res = await http.get(uri);

      if (res.statusCode != 200) {
        log('⚠️ HTTP hata kodu: ${res.statusCode}', name: tag);
        return null;
      }

      final data = json.decode(res.body);
      if (data['Response'] == 'False') {
        log('❌ Bulunamadı:  ' /*$title', name: tag*/);
        return null;
      }

      return {
        'title': data['Title'],
        'year': data['Year'],
        'type': data['Type'], // movie / series / episode
        'genre': data['Genre'],
        'poster': data['Poster'],
        'rating': data['imdbRating'],
      };
    } catch (e, st) {
      log(
        '❌ IMDb isteği hatası: $e',
        name: 'imdb_fetcher',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// 🎬 Yalnızca TYPE bilgisini döndürür (movie / series / episode)
  Future<ImdbTitleType> getTitleType(String title) async {
    final data = await fetchInfo(title);

    if (data == null) return ImdbTitleType.unknown;

    final t = (data['type'] ?? '').toString().toLowerCase();

    if (t == 'movie') return ImdbTitleType.movie;
    if (t == 'series') return ImdbTitleType.series;
    if (t == 'episode') return ImdbTitleType.episode;

    return ImdbTitleType.unknown;
  }
}
