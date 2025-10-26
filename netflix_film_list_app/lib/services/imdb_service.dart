// 📃 imdb_service.dart
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ImdbService {
  static const String _apiKey = 'bb34e17c'; // 🔑 Buraya kendi anahtarını yaz
  static const String _baseUrl = 'https://www.omdbapi.com/';

  static Future<Map<String, dynamic>?> fetchImdbData(String title) async {
    try {
      final cleanTitle = title.split(':').first.trim();
      final uri = Uri.parse(
        '$_baseUrl?t=${Uri.encodeComponent(cleanTitle)}&apikey=$_apiKey',
      );

      final response = await http.get(uri);

      log('🎯 IMDb sorgusu: $cleanTitle');
      log('📩 Yanıt: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Response'] == 'True') {
          return {
            'title': data['Title'],
            'originalTitle': data['Title'],
            'year': data['Year'],
            'rating': data['imdbRating'],
            'poster': data['Poster'] != "N/A" ? data['Poster'] : null,
            'type': data['Type'],
          };
        }
      }
    } catch (e) {
      log("❌ IMDb hata: $e");
    }
    return null;
  }
}
