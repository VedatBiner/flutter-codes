// 📃 <----- word_stats_page.dart ----->

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';

import '../constants/chart_colors.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../widgets/word_length_legend.dart';

class WordsStatsPage extends StatefulWidget {
  const WordsStatsPage({super.key});

  @override
  State<WordsStatsPage> createState() => _WordsStatsPageState();
}

class _WordsStatsPageState extends State<WordsStatsPage> {
  final Map<int, List<Word>> _byLength = {};
  List<Word> _filteredWords = [];
  int? _selectedLength;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final words = await DbHelper.instance.getRecords();

    _byLength.clear();

    for (final w in words) {
      final len = w.word.length;
      if (len > 15) continue; // 🔒 maksimum 15

      _byLength.putIfAbsent(len, () => []).add(w);
    }

    setState(() {
      _filteredWords = words.where((w) => w.word.length <= 15).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalWords = _byLength.values.fold<int>(0, (a, b) => a + b.length);

    final legendData = {
      for (final e in _byLength.entries) e.key: e.value.length,
    };

    return Scaffold(
      backgroundColor: cardPageColor,
      appBar: AppBar(
        backgroundColor: drawerColor,
        title: Text('Kelime İstatistikleri', style: itemCountStil),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // ---------------- PIE CHART ----------------
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: _buildSections(totalWords),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    final touched = response?.touchedSection;
                    final keys = _byLength.keys.toList()..sort();

                    // 🔹 Ortaya / boşluğa dokunuldu
                    if (touched == null ||
                        touched.touchedSectionIndex < 0 ||
                        touched.touchedSectionIndex >= keys.length) {
                      setState(() {
                        _selectedLength = null;
                        _filteredWords = _byLength.values
                            .expand((e) => e)
                            .toList();
                      });
                      return;
                    }

                    // 🔹 Dilime dokunuldu
                    final index = touched.touchedSectionIndex;

                    setState(() {
                      _selectedLength = keys[index];
                      _filteredWords = _byLength[_selectedLength]!;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 2),
          // ---------------- LEGEND ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: WordLengthLegend(
              data: legendData,
              selected: _selectedLength,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _selectedLength == null
                  ? 'Toplam kelime sayısı: ${_filteredWords.length}'
                  : '$_selectedLength harfli kelimeler (${_filteredWords.length})',
              style: anlamText,
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 2),

          // ---------------- WORD LIST ----------------
          Expanded(
            child: ListView.builder(
              itemCount: _filteredWords.length,
              itemBuilder: (_, i) {
                final w = _filteredWords[i];
                return ListTile(title: Text(w.word), subtitle: Text(w.meaning));
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PIE SECTIONS ----------------
  List<PieChartSectionData> _buildSections(int total) {
    final keys = _byLength.keys.toList()..sort();

    return List.generate(keys.length, (i) {
      final len = keys[i];
      final count = _byLength[len]!.length;
      final percent = (count / total * 100);

      return PieChartSectionData(
        value: count.toDouble(),
        title: '${len}h\n$count\n${percent.toStringAsFixed(1)}%',
        radius: _selectedLength == len ? 110 : 100,
        titleStyle: pieChartText,
        color: ChartColors.wordLengthColors[len - 1],
      );
    });
  }
}
