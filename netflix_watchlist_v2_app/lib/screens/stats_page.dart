// <----- lib/screens/stats_page.dart ----->
//
// ============================================================================
// 📊 StatsPage – İzleme İstatistikleri Ekranı
// ============================================================================
//
// Bu sayfa HomePage’den gelen film ve dizi listelerini kullanarak
// kullanıcının izleme verilerini özetler.
//
// ---------------------------------------------------------------------------
// 🔹 Gösterilenler
// ---------------------------------------------------------------------------
// 1) Genel Özet Kartı
//    • Film sayısı
//    • Dizi sayısı
//    • Toplam bölüm sayısı
//
// 2) Pie Chart (Film vs Dizi dağılımı)
//    • Toplam içindeki yüzde oranlarını gösterir
//
// 3) Bar Chart (Dizi başına sezon sayısı)
//    • Her dizinin kaç sezon içerdiğini görsel olarak gösterir
//
// ---------------------------------------------------------------------------
// 🔹 Tema Uyum Mantığı
// ---------------------------------------------------------------------------
// • Dark/Light tema durumuna göre metin rengi, kart rengi ve başlık rengi
//   daha okunur olacak şekilde otomatik ayarlanır.
// • PieChart dilimlerinin üstündeki yazılar, dilim renginin parlaklığına göre
//   siyah/beyaz seçilir (kontrast için).
//
// ============================================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';

/// ============================================================================
/// 📊 StatsPage
/// ============================================================================
/// Bu widget, istatistik ekranını üretir.
///
/// Dışarıdan aldığı veriler:
///  • movies → tüm filmler listesi
///  • series → tüm diziler (SeriesGroup) listesi
///
/// Not:
/// Bu sayfa veriyi hesaplar ama “veri üretmez”. Yani:
///  • CSV parse etmez
///  • OMDb çağırmaz
///  • sadece hazır listeler üzerinden toplam/dağılım çıkarır
///
/// Bu yaklaşım ile:
///  • StatsPage saf (pure) bir görselleştirme ekranı olur
///  • HomePage → “veri hazırlama”
///  • StatsPage → “veri gösterme”
/// ayrımı korunur.
/// ============================================================================

class StatsPage extends StatelessWidget {
  final List<NetflixItem> movies;
  final List<SeriesGroup> series;

  const StatsPage({super.key, required this.movies, required this.series});

  /// =========================================================================
  /// 🎞 totalEpisodes (computed getter)
  /// =========================================================================
  /// Diziler içindeki toplam bölüm sayısını hesaplar.
  ///
  /// Nasıl çalışır?
  ///  • series -> seasons -> episodes seviyelerine “expand” ile iner
  ///  • en sonunda length ile toplam bölüm sayısını verir
  ///
  /// Neden getter?
  ///  • build içinde tekrar tekrar aynı hesap yapılmasın
  ///  • okuması daha temiz olsun: totalEpisodes
  ///
  int get totalEpisodes {
    return series.expand((g) => g.seasons).expand((s) => s.episodes).length;
  }

  /// =========================================================================
  /// 🎨 _labelColorForSlice
  /// =========================================================================
  /// PieChart dilimlerinin üstündeki yazının rengini belirler.
  ///
  /// Problem:
  ///  • Dilim rengi açık ise beyaz yazı okunmaz
  ///  • Dilim rengi koyu ise siyah yazı okunmaz
  ///
  /// Çözüm:
  ///  • computeLuminance() ile rengin “parlaklığını” ölçeriz (0..1)
  ///  • parlaklık yüksekse → siyah
  ///  • parlaklık düşükse → beyaz
  ///
  /// Bu fonksiyon, hem light hem dark temada otomatik kontrast sağlar.
  Color _labelColorForSlice(Color sliceColor) {
    final lum = sliceColor.computeLuminance();
    return lum > 0.55 ? Colors.black : Colors.white;
  }

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// Sayfanın ana iskeletini kurar:
  ///  • AppBar
  ///  • Body: ListView içinde 3 ana bölüm
  ///      1) Summary Card
  ///      2) Pie Chart
  ///      3) Bar Chart
  ///
  /// Tema uyumları burada hazırlanır:
  ///  • isDark → dark mod mu?
  ///  • fg/sub → metin renkleri
  ///  • titleColor → başlık rengi (light: mavi / dark: sarı)
  ///  • cardBg → dark modda kartın daha belirgin olması için özel arka plan
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ana (başlık gibi) foreground rengi
    final fg = isDark ? Colors.white : Colors.black;
    // Normal satır/alt metin rengi
    final sub = isDark ? Colors.white70 : Colors.black87;

    // ✅ Light mode başlıklar mavi, Dark mode sarı
    final titleColor = isDark ? menuColor : drawerColor;

    // ✅ Dark mod kart zemini: siyah üzerine daha okunur “koyu gri”
    final cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;

    // Toplamlar
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
          // 1) Genel özet kartı
          _buildSummaryCard(
            cardBg: cardBg,
            fg: fg,
            sub: sub,
            movieCount: totalMovies,
            seriesCount: totalSeries,
            episodeCount: totalEpisodes,
          ),
          const SizedBox(height: 20),

          // 2) Film / Dizi dağılımı pie chart
          _buildPieChart(
            titleColor: titleColor,
            fg: fg,
            movieCount: totalMovies,
            seriesCount: totalSeries,
          ),
          const SizedBox(height: 30),

          // 3) Dizi başına sezon sayısı bar chart
          _buildBarChart(titleColor: titleColor, isDark: isDark, fg: fg),
        ],
      ),
    );
  }

  /// =========================================================================
  /// 🧾 _buildSummaryCard
  /// =========================================================================
  /// “Genel Özet” kartını üretir.
  ///
  /// İçerik:
  ///  • Filmler sayısı
  ///  • Diziler sayısı
  ///  • Bölümler sayısı
  ///
  /// Parametreler:
  ///  • cardBg → kart arka plan rengi (tema uyumlu)
  ///  • fg     → başlık rengi
  ///  • sub    → satırların rengi
  ///  • movieCount / seriesCount / episodeCount → sayılar
  ///
  /// Not:
  /// DefaultTextStyle kullanımıyla kart içindeki satırların
  /// tek tek stilini tekrar etmekten kurtuluyoruz.
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
              // Kart başlığı
              Text(
                "Genel Özet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: fg,
                ),
              ),
              const SizedBox(height: 10),

              // Satırlar (DefaultTextStyle’dan stil alır)
              Text("🎬 Filmler: $movieCount"),
              Text("📺 Diziler: $seriesCount"),
              Text("🎞 Bölümler: $episodeCount"),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================================================================
  /// 🥧 _buildPieChart
  /// =========================================================================
  /// Film ve dizi sayılarının oranını gösteren PieChart üretir.
  ///
  /// Neden PieChart?
  ///  • “Toplam içindeki yüzde” algısı en kolay bu grafikte anlaşılır
  ///
  /// Edge case:
  ///  • total == 0 ise (hiç veri yoksa) grafik çizmek yerine
  ///    bilgilendirici bir metin gösteririz.
  ///
  /// Renkler:
  ///  • movieColor  → sabit mavi
  ///  • seriesColor → menuColor (marka rengiyle uyum)
  ///
  /// Dilim yazıları:
  ///  • _labelColorForSlice() ile otomatik kontrast seçimi yapılır
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
            color: titleColor, // ✅ Light mode ’da mavi
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
                // Filmler dilimi
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

                // Diziler dilimi
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

  /// ----------------------------------------------------------------
  /// 📊 Bar Chart: Dizi başına sezon sayısı
  /// ----------------------------------------------------------------
  /// =========================================================================
  /// 📊 _buildBarChart
  /// =========================================================================
  /// Her dizinin sezon sayısını bar chart olarak çizer.
  ///
  /// Edge case:
  ///  • series boşsa grafik yerine "(Veri yok)" mesajı gösterilir.
  ///
  /// Bar verisi:
  ///  • Her SeriesGroup için:
  ///     x → index (grafikteki konum)
  ///     toY → sezon sayısı
  ///
  /// Görsel tercihler:
  ///  • titlesData kapalı (şimdilik daha sade)
  ///  • border kapalı
  ///  • grid açık: yatay/dikey çizgiler okunabilirlik için (tema uyumlu)
  ///
  /// Renk:
  ///  • Dark mod: lightBlueAccent (koyu zeminde parlak)
  ///  • Light mod: blue
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

              // Şimdilik axis başlıklarını kapalı tutuyoruz
              titlesData: FlTitlesData(show: false),

              // Çerçeveyi kapat (daha modern, sade görünür)
              borderData: FlBorderData(show: false),

              // Grid çizgileri tema uyumlu (dark: beyaz12, light: siyah12)
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








