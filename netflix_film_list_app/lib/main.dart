// 📜<----- main.dart ----->
// Netflix CSV'sini asset'ten otomatik okur, dizileri sezona göre gruplar, filmleri ayrı listeler.

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const NetflixHistoryApp());
}

class NetflixHistoryApp extends StatelessWidget {
  const NetflixHistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Netflix İzleme Geçmişi',
      debugShowCheckedModeBanner: false,
      home: NetflixHistoryPage(),
    );
  }
}

class NetflixHistoryPage extends StatefulWidget {
  const NetflixHistoryPage({super.key});

  @override
  State<NetflixHistoryPage> createState() => _NetflixHistoryPageState();
}

class _NetflixHistoryPageState extends State<NetflixHistoryPage> {
  List<List<dynamic>> _history = [];

  Map<String, Map<String, List<Map<String, String>>>> _seriesMap = {};
  List<Map<String, String>> _filmsList = [];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCSVFromAssets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool isSeries(String title) {
    final lowered = title.toLowerCase();
    return lowered.contains("season") || lowered.contains("sezon");
  }

  String extractSeriesName(String fullTitle) {
    final parts = fullTitle.split(":");
    return parts.isNotEmpty ? parts.first.trim() : fullTitle;
  }

  String extractSeason(String fullTitle) {
    final regex = RegExp(r'(Season \d+|Sezon \d+)', caseSensitive: false);
    final match = regex.firstMatch(fullTitle);
    return match?.group(0)?.trim() ?? "Diğer";
  }

  Future<void> loadCSVFromAssets() async {
    try {
      final rawData = await rootBundle.loadString(
        'assets/NetflixFilmHistory.csv',
      );

      final parsedCsv = const CsvToListConverter().convert(
        rawData,
        fieldDelimiter: ',',
        eol: '\n',
      );

      final data = parsedCsv.skip(1).toList(); // başlık atla

      setState(() {
        _history = data;
        _updateGroupedData();
      });
    } catch (e) {
      debugPrint("CSV yükleme hatası: $e");
    }
  }

  void _updateGroupedData() {
    final Map<String, Map<String, List<Map<String, String>>>> series = {};
    final List<Map<String, String>> films = [];

    for (var row in _history) {
      final fullTitle = row[0].toString();
      final watchDate = row[1].toString();

      if (_searchQuery.isNotEmpty &&
          !fullTitle.toLowerCase().contains(_searchQuery.toLowerCase())) {
        continue;
      }

      if (isSeries(fullTitle)) {
        final seriesName = extractSeriesName(fullTitle);
        final season = extractSeason(fullTitle);

        series.putIfAbsent(seriesName, () => {});
        series[seriesName]!.putIfAbsent(season, () => []);
        series[seriesName]![season]!.add({
          'title': fullTitle,
          'date': watchDate,
        });
      } else {
        films.add({'title': fullTitle, 'date': watchDate});
      }
    }

    setState(() {
      _seriesMap = series;
      _filmsList = films;
    });
  }

  void _filterSearchResults(String query) {
    setState(() {
      _searchQuery = query;
      _updateGroupedData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Netflix İzleme Geçmişi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Dizi veya film ara...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterSearchResults,
            ),
          ),
          Expanded(
            child: (_seriesMap.isEmpty && _filmsList.isEmpty)
                ? const Center(child: Text("Veri yok veya CSV yüklenmedi."))
                : ListView(
                    children: [
                      if (_seriesMap.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "📺 Diziler",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ..._seriesMap.entries.map((seriesEntry) {
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
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
                                      "İlk: $firstDate • Son: $lastDate",
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
                                        subtitle: Text(
                                          "İzlenme: ${episode['date']}",
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }),
                      ],
                      if (_filmsList.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "🎬 Filmler",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ..._filmsList.map((film) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(film['title'] ?? ''),
                                subtitle: Text("İzlenme: ${film['date']}"),
                                leading: const Icon(Icons.movie),
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
