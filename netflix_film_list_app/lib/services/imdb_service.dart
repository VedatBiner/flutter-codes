// 📁 lib/services/imdb_service.dart
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ImdbService {
  static const String _apiKey =
      'YOUR_OMDB_API_KEY'; // 🔑 OMDb API anahtarını buraya yaz
  static const String _baseUrl = 'https://www.omdbapi.com/';

  /// Belirtilen film veya dizi adıyla IMDb verisi çeker.
  static Future<Map<String, dynamic>?> fetchImdbData(String title) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?t=${Uri.encodeComponent(title)}&apikey=$_apiKey',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Response'] == 'True') {
          return {
            'title': data['Title'],
            'originalTitle': data['Title'],
            'year': data['Year'],
            'rating': data['imdbRating'],
            'poster': data['Poster'] != "N/A" ? data['Poster'] : null,
            'type': data['Type'], // "movie" veya "series"
          };
        } else {
          log('🔸 IMDb bulunamadı: $title');
        }
      } else {
        log('⚠️ IMDb bağlantı hatası: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ IMDb sorgusu hatası: $e');
    }
    return null;
  }
}
