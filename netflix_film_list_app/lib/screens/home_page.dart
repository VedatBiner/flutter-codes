// 📃 home_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../db/db_helper.dart';
import '../parsers/csv_parser.dart';
import '../services/imdb_service.dart';
import '../widgets/films_card.dart';
import '../widgets/series_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  List<Map<String, String>> _filmsList = [];
  Map<String, Map<String, List<Map<String, String>>>> _seriesMap = {};
  int _csvRowCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  // 📂 CSV dosyasını assets klasöründen yükle
  Future<void> _loadCsvData() async {
    try {
      final rawCsv = await rootBundle.loadString(
        'assets/database/NetflixFilmHistory.csv',
      );
      final parsed = await parseCsvData(rawCsv);
      _csvRowCount = parsed.length;
      _separateSeriesAndFilms(parsed);
    } catch (e) {
      log('❌ CSV yükleme hatası: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🎬 Başlıktan dizi olup olmadığını tespit et
  bool _isSeries(String title) {
    final lower = title.toLowerCase();
    return lower.contains("season") ||
        lower.contains("part") ||
        lower.contains("episode");
  }

  // 🧩 Veriyi diziler ve filmler olarak ayır
  Future<void> _separateSeriesAndFilms(List<Map<String, String>> parsed) async {
    final films = <Map<String, String>>[];
    final series = <String, Map<String, List<Map<String, String>>>>{};
    final occurrenceMap = <String, int>{};

    // 1️⃣ Her başlığın kaç kez geçtiğini say
    for (final item in parsed) {
      final title =
          item['Title'] ?? item['Name'] ?? item['Program Title'] ?? '';
      if (title.isEmpty) continue;
      final mainTitle = title.split(':').first.trim();
      occurrenceMap[mainTitle] = (occurrenceMap[mainTitle] ?? 0) + 1;
    }

    // 2️⃣ Veriyi dizi veya filme ayır
    for (final item in parsed) {
      final title =
          item['Title'] ?? item['Name'] ?? item['Program Title'] ?? '';
      if (title.isEmpty) continue;
      final mainTitle = title.split(':').first.trim();

      final bool looksLikeSeries = _isSeries(title);
      final bool repeatsOften = (occurrenceMap[mainTitle] ?? 0) > 1;

      if (looksLikeSeries || repeatsOften) {
        final seasonPart = _extractSeasonPart(title);
        final episode = _extractEpisode(title);

        series.putIfAbsent(mainTitle, () => {});
        series[mainTitle]!.putIfAbsent(seasonPart, () => []);
        series[mainTitle]![seasonPart]!.add({
          'episode': episode,
          'date': item['Date'] ?? '',
        });
      } else {
        films.add(item);
      }
    }

    // 3️⃣ Log istatistikleri
    int totalEpisodes = 0;
    for (var show in series.values) {
      for (var season in show.values) {
        totalEpisodes += season.length;
      }
    }

    log('✅ CSV başarıyla parse edildi. Satır sayısı: $_csvRowCount');
    log('🎥 Film sayısı: ${films.length}');
    log('📺 Dizi sayısı (başlık bazında): ${series.length}');
    log('📑 Toplam bölüm sayısı: $totalEpisodes');
    log('📊 Toplam işlenen kayıt: ${films.length + totalEpisodes}');
    if (_csvRowCount != (films.length + totalEpisodes)) {
      log(
        '⚠️ UYARI: CSV satır sayısı ile işlenen toplam kayıt sayısı eşleşmiyor!',
      );
    } else {
      log('✅ CSV satır sayısı ile işlenen toplam kayıt sayısı eşleşiyor.');
    }

    setState(() {
      _filmsList = films;
      _seriesMap = series;
    });

    // 4️⃣ Veritabanına kaydet
    await _saveToDatabase();
  }

  // 🗂️ Veritabanına yazma işlemi
  Future<void> _saveToDatabase() async {
    final db = DatabaseHelper();

    // Eski kayıtları temizle (opsiyonel)
    await db.clearTable();

    // 🎬 Filmleri ekle
    for (final film in _filmsList) {
      final title = film['Title'] ?? '';
      final date = film['Date'] ?? '';

      final imdb = await ImdbService.fetchImdbData(title);

      await db.insertRecord({
        'title': title,
        'watch_date': date,
        'imdb_title': imdb?['originalTitle'] ?? '',
        'imdb_rating': imdb?['rating'] ?? '',
        'imdb_poster': imdb?['poster'] ?? '',
      });
    }

    // 📺 Dizileri ekle (her bölüm için kayıt)
    for (final entry in _seriesMap.entries) {
      final seriesTitle = entry.key;
      for (final season in entry.value.entries) {
        for (final ep in season.value) {
          final date = ep['date'] ?? '';

          final imdb = await ImdbService.fetchImdbData(seriesTitle);

          await db.insertRecord({
            'title': seriesTitle,
            'watch_date': date,
            'imdb_title': imdb?['originalTitle'] ?? '',
            'imdb_rating': imdb?['rating'] ?? '',
            'imdb_poster': imdb?['poster'] ?? '',
          });
        }
      }
    }

    log('✅ Veritabanına yazma tamamlandı.');
  }

  // 🎞️ Sezon veya Part bilgisini çıkar
  String _extractSeasonPart(String title) {
    final parts = title.split(':');
    for (final part in parts) {
      final trimmed = part.trim().toLowerCase();
      if (trimmed.startsWith('season') || trimmed.startsWith('part')) {
        return part.trim();
      }
    }
    return 'Sezon Bilinmiyor';
  }

  // 📺 Bölüm adını çıkar
  String _extractEpisode(String title) {
    final parts = title.split(':');
    if (parts.length > 2) return parts.last.trim();
    return 'Bölüm Bilinmiyor';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Netflix İzleme Geçmişi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Column(
                  children: [
                    if (_seriesMap.isNotEmpty)
                      SeriesCard(seriesData: _seriesMap),
                    if (_filmsList.isNotEmpty) FilmsCard(movies: _filmsList),
                    if (_seriesMap.isEmpty && _filmsList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          'Hiç veri bulunamadı.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
