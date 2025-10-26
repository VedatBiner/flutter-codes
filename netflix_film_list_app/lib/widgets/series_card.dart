// 📃 series_card.dart – IMDb sadece ana diziye ait olacak
import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/imdb_service.dart';

class SeriesCard extends StatefulWidget {
  final Map<String, Map<String, List<Map<String, String>>>> seriesData;

  const SeriesCard({required this.seriesData, super.key});

  @override
  State<SeriesCard> createState() => _SeriesCardState();
}

class _SeriesCardState extends State<SeriesCard> {
  final Map<String, Map<String, dynamic>> _imdbCache = {};

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
          "📺 Diziler",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        collapsedIconColor: Colors.white,
        iconColor: Colors.redAccent,
        children: widget.seriesData.entries.map((seriesEntry) {
          final seriesTitle = seriesEntry.key;
          final seasons = seriesEntry.value;

          // IMDb sadece dizinin ana adı için
          return FutureBuilder<Map<String, dynamic>?>(
            future: _loadImdb(seriesTitle),
            builder: (context, snapshot) {
              final imdb = snapshot.data;
              log(
                '🔍 IMDb sorgusu başlatıldı: $seriesTitle',
                name: 'series_card',
              );
              return ExpansionTile(
                title: Row(
                  children: [
                    if (imdb?['poster'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          imdb!['poster'],
                          width: 45,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        imdb?['originalTitle'] ?? seriesTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: imdb == null
                    ? const Text(
                        "IMDb verisi bulunamadı",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text(
                        "⭐ ${imdb['rating']}  |  ${imdb['year']}",
                        style: const TextStyle(color: Colors.grey),
                      ),

                // Sezon ve bölümler sadece metin olarak gösterilecek
                children: seasons.entries.map((seasonEntry) {
                  final seasonName = seasonEntry.key;
                  final episodes = seasonEntry.value;

                  return ExpansionTile(
                    title: Text(
                      seasonName,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: episodes.map((ep) {
                      final episodeName =
                          ep['episode'] ?? ep['title'] ?? 'Bölüm';
                      return ListTile(
                        title: Text(
                          episodeName,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
