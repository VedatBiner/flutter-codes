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

  const StatsPage({super.key, required this.movies, required this.series});

  int get totalEpisodes {
    return series.expand((g) => g.seasons).expand((s) => s.episodes).length;
  }

  Color _labelColorForSlice(Color sliceColor) {
    final lum = sliceColor.computeLuminance();
    return lum > 0.55 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fg = isDark ? Colors.white : Colors.black;
    final sub = isDark ? Colors.white70 : Colors.black87;

    // ✅ Light mode başlıklar mavi, Dark mode sarı
    final titleColor = isDark ? menuColor : drawerColor;

    // Karanlık modda kart arka planını belirgin yap
    final cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;

    final totalMovies = movies.length;
    final totalSeries = series.length;

    return Scaffold(
      appBar: AppBar(
        title: Text("İzleme İstatistikleri", style: appBarTitleText),
        iconTheme: IconThemeData(color: drawerMenuTitleText.color),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(
            cardBg: cardBg,
            fg: fg,
            sub: sub,
            movieCount: totalMovies,
            seriesCount: totalSeries,
            episodeCount: totalEpisodes,
          ),
          const SizedBox(height: 20),
          _buildPieChart(
            titleColor: titleColor,
            fg: fg,
            movieCount: totalMovies,
            seriesCount: totalSeries,
          ),
          const SizedBox(height: 30),
          _buildBarChart(
            titleColor: titleColor,
            isDark: isDark,
            fg: fg,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // 🎯 Özet Kartı
  // ----------------------------------------------------------------
  Widget _buildSummaryCard({
    required Color cardBg,
    required Color fg,
    required Color sub,
    required int movieCount,
    required int seriesCount,
    required int episodeCount,
  }) {
    return Card(
      elevation: 1,
      color: cardBg,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: TextStyle(
            color: sub,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Genel Özet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: fg,
                ),
              ),
              const SizedBox(height: 10),
              Text("🎬 Filmler: $movieCount"),
              Text("📺 Diziler: $seriesCount"),
              Text("🎞 Bölümler: $episodeCount"),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // 🥧 Pie Chart: Film vs Dizi
  // ----------------------------------------------------------------
  Widget _buildPieChart({
    required Color titleColor,
    required Color fg,
    required int movieCount,
    required int seriesCount,
  }) {
    final total = movieCount + seriesCount;
    if (total == 0) {
      return Text(
        "Film / Dizi Dağılımı\n(Veri yok)",
        textAlign: TextAlign.center,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 18),
      );
    }

    final movieColor = Colors.blue;
    final seriesColor = menuColor; // dilim rengi aynı kalsın

    return Column(
      children: [
        Text(
          "Film / Dizi Dağılımı",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: titleColor, // ✅ Light mode’da mavi
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              sectionsSpace: 2,
              sections: [
                PieChartSectionData(
                  value: movieCount.toDouble(),
                  color: movieColor,
                  title:
                  "Filmler\n${((movieCount / total) * 100).toStringAsFixed(1)}%",
                  radius: 85,
                  titleStyle: TextStyle(
                    color: _labelColorForSlice(movieColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                PieChartSectionData(
                  value: seriesCount.toDouble(),
                  color: seriesColor,
                  title:
                  "Diziler\n${((seriesCount / total) * 100).toStringAsFixed(1)}%",
                  radius: 85,
                  titleStyle: TextStyle(
                    color: _labelColorForSlice(seriesColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
  Widget _buildBarChart({
    required Color titleColor,
    required bool isDark,
    required Color fg,
  }) {
    if (series.isEmpty) {
      return Text(
        "Dizi → Sezon Sayısı\n(Veri yok)",
        textAlign: TextAlign.center,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 18),
      );
    }

    final barData = series
        .map(
          (s) => BarChartGroupData(
        x: series.indexOf(s),
        barRods: [
          BarChartRodData(
            toY: s.seasons.length.toDouble(),
            color: isDark ? Colors.lightBlueAccent : Colors.blue,
            width: 10,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    )
        .toList();

    return Column(
      children: [
        Text(
          "Dizi  →  Sezon Sayısı",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: titleColor, // ✅ Light mode ’da mavi
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              barGroups: barData,
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: isDark ? Colors.white12 : Colors.black12,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (_) => FlLine(
                  color: isDark ? Colors.white12 : Colors.black12,
                  strokeWidth: 1,
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
