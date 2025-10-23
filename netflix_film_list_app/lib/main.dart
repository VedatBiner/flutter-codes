import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Netflix İzleme Geçmişi',
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
  Map<String, Map<String, List<Map<String, String>>>> _seriesMap = {};
  List<Map<String, String>> _filmsList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadAndProcessCSV();
  }

  Future<void> loadAndProcessCSV() async {
    setState(() => _isLoading = true);
    try {
      final rawCsv = await rootBundle.loadString(
        'assets/NetflixFilmHistory.csv',
      );
      final result = await compute(processCSV, {
        'csv': rawCsv,
        'query': _searchQuery,
      });

      setState(() {
        _seriesMap = Map<String, Map<String, List<Map<String, String>>>>.from(
          result['series'],
        );
        _filmsList = List<Map<String, String>>.from(result['films']);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  static Map<String, dynamic> processCSV(Map<String, String> args) {
    final rawCsv = args['csv']!;
    final query = args['query']!.toLowerCase();
    final parsedCsv = const CsvToListConverter().convert(
      rawCsv,
      fieldDelimiter: ',',
      eol: '\n',
    );
    final data = parsedCsv.skip(1).toList();

    final Map<String, Map<String, List<Map<String, String>>>> series = {};
    final List<Map<String, String>> films = [];

    for (var row in data) {
      final fullTitle = row[0].toString();
      final dateStr = row[1].toString();

      if (query.isNotEmpty && !fullTitle.toLowerCase().contains(query))
        continue;

      // 🔄 Tarih formatı düzeltme: MM/DD/YY → DD/MM/YY
      final dateParts = dateStr.split('/');
      if (dateParts.length != 3) continue;
      final formattedDate =
          '${dateParts[1].padLeft(2, '0')}/${dateParts[0].padLeft(2, '0')}/${dateParts[2]}';

      final isSeries =
          fullTitle.toLowerCase().contains('season') ||
          fullTitle.toLowerCase().contains('sezon');
      if (isSeries) {
        final name = fullTitle.split(":").first.trim();
        final season =
            RegExp(
              r'(Season \d+|Sezon \d+)',
            ).firstMatch(fullTitle)?.group(0)?.trim() ??
            "Detay";
        series.putIfAbsent(name, () => {});
        series[name]!.putIfAbsent(season, () => []);
        series[name]![season]!.add({'title': fullTitle, 'date': formattedDate});
      } else {
        films.add({'title': fullTitle, 'date': formattedDate});
      }
    }

    return {'series': series, 'films': films};
  }

  void _onSearch(String value) {
    _searchQuery = value;
    loadAndProcessCSV();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Netflix İzleme Geçmişi')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Dizi veya film ara...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onSearch,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      if (_seriesMap.isNotEmpty) _buildSeriesCard(),
                      if (_filmsList.isNotEmpty) _buildFilmsCard(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSeriesCard() {
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
          children: _seriesMap.entries.map((entry) {
            final seriesTitle = entry.key;
            final seasonMap = entry.value;
            final totalEpisodes = seasonMap.values.fold(
              0,
              (sum, list) => sum + list.length,
            );
            final allDates =
                seasonMap.values
                    .expand((e) => e.map((ep) => ep['date']!))
                    .toList()
                  ..sort();

            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seriesTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("$totalEpisodes bölüm izlendi"),
                      Text("İlk: ${allDates.first} - Son: ${allDates.last}"),
                    ],
                  ),
                  children: seasonMap.entries.map((seasonEntry) {
                    final season = seasonEntry.key;
                    final episodes = seasonEntry.value
                      ..sort((a, b) => a['date']!.compareTo(b['date']!));

                    return ExpansionTile(
                      title: Text(
                        season,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      children: episodes.map((episode) {
                        return ListTile(
                          title: Text(episode['title']!),
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
    );
  }

  Widget _buildFilmsCard() {
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: const Icon(Icons.movie),
                  title: Text(film['title'] ?? ''),
                  subtitle: Text("İzlenme: ${film['date']}"),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
