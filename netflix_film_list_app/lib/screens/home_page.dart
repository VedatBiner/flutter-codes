// 📦 screens/home_page.dart

// 📌 Flutter paketleri
import 'dart:developer';

import 'package:flutter/material.dart';

/// 📌 yardımcı paketler
import '../parsers/csv_parser.dart';
import '../utils/date_utils.dart';
import '../widgets/films_card.dart';
import '../widgets/series_card.dart';

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
    _loadCSVFromAssets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCSVFromAssets() async {
    try {
      final parsedData = await parseCsvData(
        'assets/database/NetflixFilmHistory.csv',
      );

      // 🔍 Konsola log yaz
      log("✅ Yüklenen satır sayısı: ${parsedData.length}", name: "home_page");
      if (parsedData.isNotEmpty) {
        log("📝 İlk satır: ${parsedData.first}", name: "home_page");
      }

      setState(() {
        _history = parsedData;
        _updateGroupedData();
      });
    } catch (e) {
      log("❌ CSV yükleme hatası: $e", name: "home_page");
    }
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
                      if (_seriesMap.isNotEmpty)
                        SeriesCard(seriesMap: _seriesMap),
                      if (_filmsList.isNotEmpty)
                        FilmsCard(filmsList: _filmsList),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
