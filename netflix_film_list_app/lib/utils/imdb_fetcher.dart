import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/file_info.dart';

Future<Map<String, dynamic>?> fetchImdbData(String title) async {
  final url = Uri.parse(
    'https://www.omdbapi.com/?t=${Uri.encodeComponent(title)}&apikey=$apiKey',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['Response'] == 'True') {
      return {
        'type': data['Type'] ?? 'movie',
        'poster': data['Poster'],
        'rating': data['imdbRating'],
        // 'genre': data['Genre'],
        'year': data['Year'],
      };
    }
  }
  return null;
}
