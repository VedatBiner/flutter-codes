import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/item_model.dart';

class WordsStatsPage extends StatefulWidget {
  const WordsStatsPage({super.key});

  @override
  State<WordsStatsPage> createState() => _WordsStatsPageState();
}

class _WordsStatsPageState extends State<WordsStatsPage> {
  Map<int, int> lengthStats = {};
  List<Word> allWords = [];
  List<Word> filteredWords = [];

  int? selectedLength; // dropdown seçimi

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  /// ----------------------------------------------------------
  /// 🔹 DB’den kelimeleri al + istatistik çıkar
  /// ----------------------------------------------------------
  Future<void> _loadStats() async {
    final words = await DbHelper.instance.getRecords();

    final Map<int, int> stats = {};

    for (final w in words) {
      final len = w.word.length;
      stats[len] = (stats[len] ?? 0) + 1;
    }

    setState(() {
      allWords = words;
      lengthStats = stats;
    });

    log("📊 Kelime uzunlukları: $lengthStats", name: "words_stats");
  }

  /// ----------------------------------------------------------
  /// 🔹 Dropdown filtre
  /// ----------------------------------------------------------
  void _filterByLength(int? length) {
    setState(() {
      selectedLength = length;
      if (length == null) {
        filteredWords = [];
      } else {
        filteredWords = allWords.where((w) => w.word.length == length).toList();
      }
    });
  }

  /// ----------------------------------------------------------
  /// 🔹 Pie Chart data
  /// ----------------------------------------------------------
  List<PieChartSectionData> _buildPieSections() {
    final total = lengthStats.values.fold<int>(0, (a, b) => a + b);

    return lengthStats.entries.map((e) {
      final percent = (e.value / total) * 100;

      return PieChartSectionData(
        value: e.value.toDouble(),
        title: "${e.key}\n(${percent.toStringAsFixed(1)}%)",
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelime İstatistikleri")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------------- PIE CHART ----------------
            SizedBox(
              height: 260,
              child: PieChart(
                PieChartData(
                  sections: _buildPieSections(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- DROPDOWN ----------------
            Row(
              children: [
                const Text(
                  "Harf Sayısı:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: selectedLength,
                  hint: const Text("Seç"),
                  items: [2, 3, 4, 5, 6, 7]
                      .map(
                        (e) =>
                            DropdownMenuItem(value: e, child: Text("$e harf")),
                      )
                      .toList(),
                  onChanged: _filterByLength,
                ),
                if (selectedLength != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _filterByLength(null),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // ---------------- LIST ----------------
            Expanded(
              child: filteredWords.isEmpty
                  ? const Center(
                      child: Text(
                        "Filtre seçilmedi",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredWords.length,
                      itemBuilder: (_, i) {
                        final w = filteredWords[i];
                        return ListTile(
                          title: Text(w.word),
                          subtitle: Text(w.meaning),
                          trailing: Text("${w.word.length}"),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
