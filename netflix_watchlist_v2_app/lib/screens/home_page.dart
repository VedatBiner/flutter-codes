// <----- lib/screens/home_page.dart ----->

import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/color_constants.dart';
import '../constants/file_info.dart';
import '../constants/text_constants.dart';
import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';
import '../utils/download_directory_helper.dart';
import '../utils/omdb_lazy_loader.dart';
import '../utils/search_and_filter.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/filter_chips.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? toggleTheme; // 🌙 Tema değiştirme butonu

  const HomePage({super.key, this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NetflixItem> allMovies = [];
  List<SeriesGroup> allSeries = [];

  List<NetflixItem> movies = [];
  List<SeriesGroup> series = [];

  bool loading = true;
  String searchQuery = "";
  FilterOption filter = FilterOption.all;

  /// ℹ️  Uygulama versiyonu
  String appVersion = '';

  static const tag = "home_page";

  @override
  void initState() {
    super.initState();

    /// 🔹 Cihaz bilgisi
    _logDeviceInfo();

    /// 🔹 Versiyon bilgisi
    _getAppVersion();

    /// 🔹 Download klasörü hazırlığı (1 kez)
    _prepareDownloadDirectory();

    loadData();
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  /// 📌 Cihaz bilgilerini log 'a yazar
  Future<void> _logDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    log(logLine, name: tag);
    log("📱 Cihaz: ${android.model}", name: tag);
    log("🧩 Android Sürüm: ${android.version.release}", name: tag);
    log("🛠 API: ${android.version.sdkInt}", name: tag);
    log(logLine, name: tag);
  }

  /// 📌 Download dizini kontrol et
  Future<void> _prepareDownloadDirectory() async {
    final dir = await prepareDownloadDirectory(tag: tag);

    if (dir != null) {
      log("📂 Download klasörü hazır: ${dir.path}", name: tag);
    } else {
      log("⚠️ Download klasörü hazırlanamadı.", name: tag);
    }
    log(logLine, name: tag);
  }

  Future<void> loadData() async {
    final parsed = await CsvParser.parseCsvFast();
    log("📜 CSV dosyası yüklendi.", name: tag);
    log(logLine, name: tag);

    setState(() {
      allMovies = parsed.movies;
      allSeries = parsed.series;

      movies = parsed.movies;
      series = parsed.series;

      loading = false;
    });
  }

  void _updateFilteredResults() {
    final results = applySearchAndFilter(
      searchQuery: searchQuery,
      filter: filter,
      allMovies: allMovies,
      allSeries: allSeries,
    );

    setState(() {
      movies = results['movies'] as List<NetflixItem>;
      series = results['series'] as List<SeriesGroup>;
    });
  }

  // ----------------------------------------------------------------
  Future<void> loadOmdb(NetflixItem movie) async {
    await OmdbLazyLoader.loadOmdbIfNeeded(movie);
    setState(() {});
  }

  // ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Netflix Watchlist", style: drawerMenuTitleText),

          actions: [
            // 📊 İSTATİSTİK SAYFASI
            IconButton(
              icon: const Icon(Icons.bar_chart),
              tooltip: "İstatistikler",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        StatsPage(movies: allMovies, series: allSeries),
                  ),
                );
              },
            ),

            // 🌙 TEMA BUTONU
            IconButton(
              icon: const Icon(Icons.brightness_6),
              tooltip: "Tema Değiştir",
              onPressed: widget.toggleTheme,
            ),
          ],

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Ara (Dizi, Film, Bölüm)...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: menuColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: menuColor),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _updateFilteredResults();
                  });
                },
              ),
            ),
          ),
        ),

        // 📁 Drawer
        drawer: CustomDrawer(
          appVersion: appVersion,
          allMovies: allMovies,
          allSeries: allSeries,
        ),

        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  FilterChips(
                    filter: filter,
                    onSelected: (newFilter) {
                      setState(() {
                        filter = newFilter;
                        _updateFilteredResults();
                      });
                    },
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        _buildSeriesSection(),
                        const SizedBox(height: 20),
                        _buildMovieSection(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // 📺 Diziler → Sezon → Bölüm
  // ----------------------------------------------------------------
  Widget _buildSeriesSection() {
    return Card(
      child: ExpansionTile(
        title: Text("Diziler (${series.length})"),
        children: series.map(_buildSeriesTile).toList(),
      ),
    );
  }

  Widget _buildSeriesTile(SeriesGroup group) {
    return ExpansionTile(
      title: Text(group.seriesName),
      children: group.seasons.map((season) {
        return ExpansionTile(
          title: Text("Sezon ${season.seasonNumber}"),
          children: season.episodes.map((ep) {
            return ListTile(
              title: Text(ep.title),
              subtitle: Text(formatDate(parseDate(ep.date))),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  // ----------------------------------------------------------------
  // 🎬 Filmler
  // ----------------------------------------------------------------
  Widget _buildMovieSection() {
    return Card(
      child: ExpansionTile(
        title: Text("Filmler (${movies.length})"),
        children: movies.map(_buildMovieTile).toList(),
      ),
    );
  }

  Widget _buildMovieTile(NetflixItem movie) {
    return ListTile(
      leading: movie.poster == null
          ? const Icon(Icons.movie)
          : Image.network(movie.poster!, width: 50, fit: BoxFit.cover),
      title: Text(movie.title),
      subtitle: Text(
        "${formatDate(parseDate(movie.date))}\n"
        "${movie.year ?? ''} ${movie.genre ?? ''} IMDB: ${movie.rating ?? '...'}",
      ),
      onTap: () => loadOmdb(movie),
    );
  }
}
