import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants/file_info.dart';

class OmdbSeriesInfo {
  final String? originalTitle;
  final String? year;
  final String? genre;
  final String? rating;
  final String? poster;
  final String? type;
  final String? imdbId;

  const OmdbSeriesInfo({
    this.originalTitle,
    this.year,
    this.genre,
    this.rating,
    this.poster,
    this.type,
    this.imdbId,
  });
}

/// Diziler için OMDb loader (title → detail, gerekirse search fallback).
class OmdbSeriesLoader {
  static const tag = "omdb_series";

  /// Dizi adına göre OMDb’den metadata döndürür.
  static Future<OmdbSeriesInfo?> loadSeries(String seriesName) async {
    final name = seriesName.trim();
    if (name.isEmpty) return null;

    try {
      // 1) Direkt title ile dene
      final byTitleUrl = Uri.parse(
        "https://www.omdbapi.com/?t=${Uri.encodeQueryComponent(name)}&type=series&apikey=$apiKey",
      );

      log("🌐 OMDb (series, t=) çağrılıyor: $byTitleUrl", name: tag);
      final res = await http.get(byTitleUrl);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is Map && data["Response"] == "True") {
          return _mapToInfo(data);
        }
      }

      // 2) Fallback: s= ile ara → ilk sonucu imdbId ile çek
      final searchUrl = Uri.parse(
        "https://www.omdbapi.com/?s=${Uri.encodeQueryComponent(name)}&type=series&apikey=$apiKey",
      );

      log("🌐 OMDb (series, s=) fallback: $searchUrl", name: tag);
      final searchRes = await http.get(searchUrl);

      if (searchRes.statusCode != 200) return null;

      final searchData = jsonDecode(searchRes.body);
      if (searchData is! Map) return null;

      final list = searchData["Search"];
      if (list is! List || list.isEmpty) {
        log("⚠️ s= ile de bulunamadı: $name", name: tag);
        return null;
      }

      final first = list.first;
      final imdbId = (first is Map) ? first["imdbID"]?.toString() : null;
      if (imdbId == null || imdbId.isEmpty) return null;

      final byIdUrl = Uri.parse(
        "https://www.omdbapi.com/?i=${Uri.encodeQueryComponent(imdbId)}&plot=short&apikey=$apiKey",
      );

      log("🌐 OMDb (i=) detay: $byIdUrl", name: tag);
      final detailRes = await http.get(byIdUrl);

      if (detailRes.statusCode != 200) return null;

      final detailData = jsonDecode(detailRes.body);
      if (detailData is Map && detailData["Response"] == "True") {
        return _mapToInfo(detailData);
      }

      return null;
    } catch (e, st) {
      log("🚨 OMDb series yükleme hatası: $e", name: tag, error: e, stackTrace: st);
      return null;
    }
  }

  static OmdbSeriesInfo _mapToInfo(Map data) {
    final poster = data["Poster"];
    final posterUrl = (poster is String && poster.isNotEmpty && poster != "N/A") ? poster : null;

    return OmdbSeriesInfo(
      originalTitle: data["Title"]?.toString(),
      year: data["Year"]?.toString(),
      genre: data["Genre"]?.toString(),
      rating: data["imdbRating"]?.toString(),
      poster: posterUrl,
      type: data["Type"]?.toString(),
      imdbId: data["imdbID"]?.toString(),
    );
  }
}
