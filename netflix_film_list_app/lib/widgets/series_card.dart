// 📦 widgets/series_card.dart

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

class SeriesCard extends StatelessWidget {
  final Map<String, Map<String, List<Map<String, String>>>> seriesMap;

  const SeriesCard({super.key, required this.seriesMap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ExpansionTile(
            initiallyExpanded: false,
            title: const Text(
              "📺 Diziler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: seriesMap.entries.map((seriesEntry) {
                    final seriesTitle = seriesEntry.key;
                    final seasonMap = seriesEntry.value;
                    int totalEpisodes = seasonMap.values.fold(
                      0,
                      (sum, list) => sum + list.length,
                    );
                    List<String> allDates =
                        seasonMap.values
                            .expand((e) => e.map((ep) => ep['date']!))
                            .toList()
                          ..sort();
                    final firstDate = allDates.first;
                    final lastDate = allDates.last;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seriesTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$totalEpisodes bölüm izlendi",
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                "Son İzleme Tarihi : $firstDate • İlk İzleme Tarihi : $lastDate",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          children: seasonMap.entries.map((seasonEntry) {
                            final seasonName = seasonEntry.key;
                            final episodes = seasonEntry.value;
                            episodes.sort(
                              (a, b) => a['date']!.compareTo(b['date']!),
                            );
                            return ExpansionTile(
                              title: Text(
                                seasonName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: episodes.map((episode) {
                                return ListTile(
                                  title: Text(episode['title'] ?? ''),
                                  subtitle: Text("İzlenme: ${episode['date']}"),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
