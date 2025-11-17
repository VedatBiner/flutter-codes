// <----- lib/screens/stats_page.dart ----->

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/netflix_item.dart';
import '../models/series_models.dart';

class StatsPage extends StatelessWidget {
  final List<NetflixItem> movies;
  final List<SeriesGroup> series;

  const StatsPage({super.key, required this.movies, required this.series});

  int get totalEpisodes {
    return series.expand((g) => g.seasons).expand((s) => s.episodes).length;
  }

  @override
  Widget build(BuildContext context) {
    final totalMovies = movies.length;
    final totalSeries = series.length;

    return Scaffold(
      appBar: AppBar(title: const Text("İzleme İstatistikleri")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(totalMovies, totalSeries, totalEpisodes),
          const SizedBox(height: 20),
          _buildPieChart(totalMovies, totalSeries),
          const SizedBox(height: 30),
          _buildBarChart(),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // 🎯 Özet Kartı
  // ----------------------------------------------------------------
  Widget _buildSummaryCard(int movieCount, int seriesCount, int episodeCount) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Genel Özet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("🎬 Filmler: $movieCount"),
            Text("📺 Diziler: $seriesCount"),
            Text("🎞 Bölümler: $episodeCount"),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // 🥧 Pie Chart: Film vs Dizi
  // ----------------------------------------------------------------
  Widget _buildPieChart(int movieCount, int seriesCount) {
    final total = movieCount + seriesCount;

    return Column(
      children: [
        const Text(
          "Film / Dizi Dağılımı",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: movieCount.toDouble(),
                  color: Colors.blue,
                  title:
                      "Filmler\n${((movieCount / total) * 100).toStringAsFixed(1)}%",
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  value: seriesCount.toDouble(),
                  color: Colors.orange,
                  title:
                      "Diziler\n${((seriesCount / total) * 100).toStringAsFixed(1)}%",
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // 📊 Bar Chart: Dizi başına sezon sayısı
  // ----------------------------------------------------------------
  Widget _buildBarChart() {
    final barData = series
        .map(
          (s) => BarChartGroupData(
            x: series.indexOf(s),
            barRods: [
              BarChartRodData(
                toY: s.seasons.length.toDouble(),
                color: Colors.red,
              ),
            ],
          ),
        )
        .toList();

    return Column(
      children: [
        const Text(
          "Dizi → Sezon Sayısı",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              barGroups: barData,
              titlesData: FlTitlesData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
