// <----- lib/screens/home_page.dart ----->

import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/color_constants.dart';
import '../constants/file_info.dart';
import '../constants/text_constants.dart';
import '../controllers/theme_controller.dart';
import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';
import '../utils/download_directory_helper.dart';
import '../utils/file_creator.dart';
import '../utils/omdb_lazy_loader.dart';
import '../utils/search_and_filter.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/filter_chips.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ThemeController themeController = Get.find();
  final _searchController = TextEditingController();

  List<NetflixItem> allMovies = [];
  List<SeriesGroup> allSeries = [];

  List<NetflixItem> movies = [];
  List<SeriesGroup> series = [];

  bool loading = true;
  bool _isSearchVisible = false;
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

    /// 🔹 Listeyi oluştur
    loadData();

    /// 🔹 CSV/JSON/XLSX oluştur
    initializeAppDataFlow(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  Future<void> loadOmdb(NetflixItem movie) async {
    await OmdbLazyLoader.loadOmdbIfNeeded(movie);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: drawerMenuTitleText.color),
          title: Text("Netflix Watchlist", style: drawerMenuTitleText),
          actions: [
            // 🔍 ARAMA BUTONU
            IconButton(
              icon: Icon(Icons.search, color: drawerMenuTitleText.color),
              tooltip: "Ara",
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                  if (!_isSearchVisible) {
                    _searchController.clear();
                    searchQuery = "";
                    _updateFilteredResults();
                  }
                });
              },
            ),

            // 📊 İSTATİSTİK SAYFASI
            IconButton(
              icon: Icon(Icons.bar_chart, color: drawerMenuTitleText.color),
              tooltip: "İstatistikler",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StatsPage(movies: allMovies, series: allSeries),
                  ),
                );
              },
            ),

            // 🌙 TEMA BUTONU
            IconButton(
              icon: Icon(Icons.brightness_6, color: drawerMenuTitleText.color),
              tooltip: "Tema Değiştir",
              onPressed: themeController.toggleTheme,
            ),
          ],
          bottom: _isSearchVisible
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Ara (Dizi, Film, Bölüm)...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: menuColor, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: menuColor, width: 2.0),
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
                )
              : null,
        ),
        drawer: CustomDrawer(appVersion: appVersion, allMovies: allMovies, allSeries: allSeries),
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
            return ListTile(title: Text(ep.title), subtitle: Text(formatDate(parseDate(ep.date))));
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
      leading: movie.poster == null ? const Icon(Icons.movie) : Image.network(movie.poster!, width: 50, fit: BoxFit.cover),
      title: Text(movie.title),
      subtitle: Text(
        "${formatDate(parseDate(movie.date))}\n"
        "${movie.year ?? ''} ${movie.genre ?? ''} IMDB: ${movie.rating ?? '...'}",
      ),
      onTap: () => loadOmdb(movie),
    );
  }
}
