// 📃 films_card.dart – IMDb poster + rating destekli, List<Map<String,String>> ile uyumlu
import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/imdb_service.dart';

class FilmsCard extends StatefulWidget {
  /// Örn: [{ "title": "Inception", "date": "2024-10-01" }, ...]
  final List<Map<String, String>> movies;

  const FilmsCard({required this.movies, super.key});

  @override
  State<FilmsCard> createState() => _FilmsCardState();
}

class _FilmsCardState extends State<FilmsCard> {
  final Map<String, Map<String, dynamic>> _imdbCache = {};

  String _extractTitle(Map<String, String> item) {
    const candidates = ['title', 'name', 'program', 'Program Title', 'Title'];
    for (final k in candidates) {
      final v = item[k];
      if (v != null && v.trim().isNotEmpty) return v.trim();
    }
    // hiçbiri yoksa ilk değeri kullan
    if (item.isNotEmpty) return item.values.first.trim();
    return 'Unknown';
  }

  Future<Map<String, dynamic>?> _loadImdb(String title) async {
    if (_imdbCache.containsKey(title)) return _imdbCache[title];
    final data = await ImdbService.fetchImdbData(title);
    if (data != null) _imdbCache[title] = data;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: const Text(
          "🎬 Filmler",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        collapsedIconColor: Colors.white,
        iconColor: Colors.redAccent,
        children: widget.movies.map((movie) {
          final title = _extractTitle(movie);
          return FutureBuilder<Map<String, dynamic>?>(
            future: _loadImdb(title),
            builder: (context, snapshot) {
              final imdb = snapshot.data;
              final loading =
                  snapshot.connectionState == ConnectionState.waiting;
              log('🎬 IMDb sorgusu: $title', name: 'films_card');
              return ListTile(
                leading: loading
                    ? const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      )
                    : (imdb?['poster'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                imdb!['poster'],
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.movie, color: Colors.white)),
                title: Text(
                  imdb?['originalTitle'] ?? title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: imdb == null
                    ? const Text(
                        "IMDb bilgisi bulunamadı",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text(
                        "⭐ ${imdb['rating']}  |  ${imdb['year']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
