// <----- lib/screens/stats_page.dart ----->

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';

class StatsPage extends StatelessWidget {
  final List<NetflixItem> movies;
  final List<SeriesGroup> series;

  const StatsPage({
    super.key,
    required this.movies,
    required this.series,
  });

  int get totalEpisodes {
    return series.expand((g) => g.seasons).expand((s) => s.episodes).length;
  }

  @override
  Widget build(BuildContext context) {
    final totalMovies = movies.length;
    final totalSeries = series.length;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? cardLightColor : null,
      appBar: AppBar(
        title: Text("İzleme İstatistikleri", style: appBarTitleText),
      ),
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
            Text("Genel Özet", style: drawerMenuTitleText.copyWith(fontSize: 18)),
            const SizedBox(height: 10),
            Text("🎬 Filmler: $movieCount", style: normalBlackText),
            const SizedBox(height: 4),
            Text("📺 Diziler: $seriesCount", style: normalBlackText),
            const SizedBox(height: 4),
            Text("🎞 Bölümler: $episodeCount", style: normalBlackText),
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

    // total = 0 ise (CSV boş vs.) yüzde hesapları patlamasın
    final moviePct = total == 0 ? 0.0 : (movieCount / total) * 100;
    final seriesPct = total == 0 ? 0.0 : (seriesCount / total) * 100;

    return Column(
      children: [
        Text("Film / Dizi Dağılımı", style: drawerMenuTitleText.copyWith(fontSize: 18)),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: [
                PieChartSectionData(
                  value: movieCount.toDouble(),
                  color: drawerColor, // 🔵 sabit renk
                  title: "Filmler\n${moviePct.toStringAsFixed(1)}%",
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  value: seriesCount.toDouble(),
                  color: menuColor, // 🟡 sabit renk
                  title: "Diziler\n${seriesPct.toStringAsFixed(1)}%",
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.black,
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
    final barData = <BarChartGroupData>[];

    for (var i = 0; i < series.length; i++) {
      final g = series[i];
      barData.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: g.seasons.length.toDouble(),
              color: filmLightColor, // 🎨 sabit renk
              width: 14,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Text("Dizi → Sezon Sayısı", style: drawerMenuTitleText.copyWith(fontSize: 18)),
        const SizedBox(height: 10),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              barGroups: barData,
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
