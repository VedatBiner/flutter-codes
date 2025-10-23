// 📄 screens/home_page.dart
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<void> loadCSVFromAssets() async {
    try {
      final rawData = await rootBundle.loadString(
        'assets/NetflixFilmHistory.csv',
      );
      final parsedData = await compute(parseCsvData, rawData);
      setState(() {
        _history = parsedData;
        _updateGroupedData();
      });
    } catch (e) {
      debugPrint("CSV yükleme hatası: $e");
    }
  }

  static List<List<dynamic>> parseCsvData(String rawData) {
    final parsedCsv = const CsvToListConverter().convert(
      rawData,
      fieldDelimiter: ',',
      eol: '\n',
    );
    return parsedCsv.skip(1).toList();
  }

  String convertDateFormat(String dateStr) {
    try {
      final parts = dateStr.trim().split('/');
      if (parts.length != 3) return dateStr;

      int month = int.tryParse(parts[0]) ?? 1;
      int day = int.tryParse(parts[1]) ?? 1;
      int year = int.tryParse(parts[2]) ?? 0;
      if (year < 100) year += 2000;

      final date = DateTime(year, month, day);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      debugPrint("Tarih dönüştürme hatası: $e - Tarih: $dateStr");
      return dateStr;
    }
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
    return match?.group(0)?.trim() ?? "Detay";
  }

  void _updateGroupedData() {
    final Map<String, Map<String, List<Map<String, String>>>> series = {};
    final List<Map<String, String>> films = [];

    for (var row in _history) {
      final fullTitle = row[0].toString();
      final watchDate = convertDateFormat(row[1].toString());

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

    _seriesMap = series;
    _filmsList = films;
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
                : ListView(children: [_buildSeriesCard(), _buildFilmsCard()]),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesCard() {
    if (_seriesMap.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: const Text(
            "📺 Diziler",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: _seriesMap.entries.map((seriesEntry) {
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

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seriesTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("$totalEpisodes bölüm izlendi"),
                    Text("$firstDate - $lastDate"),
                  ],
                ),
                children: seasonMap.entries.map((seasonEntry) {
                  final seasonName = seasonEntry.key;
                  final episodes = seasonEntry.value;
                  episodes.sort((a, b) => a['date']!.compareTo(b['date']!));
                  return ExpansionTile(
                    title: Text(seasonName),
                    children: episodes.map((episode) {
                      return ListTile(
                        title: Text(episode['title'] ?? ''),
                        subtitle: Text("İzlenme: ${episode['date']}"),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilmsCard() {
    if (_filmsList.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: const Text(
            "🎬 Filmler",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: _filmsList.map((film) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(film['title'] ?? ''),
                subtitle: Text("İzlenme: ${film['date']}"),
                leading: const Icon(Icons.movie),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
