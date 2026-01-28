// <----- lib/screens/home_page.dart ----->

import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/file_info.dart';
import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';
import '../utils/download_directory_helper.dart';
import '../utils/file_creator.dart';
import '../utils/omdb_lazy_loader.dart';
import '../utils/search_and_filter.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_body.dart';
import '../widgets/custom_drawer.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

        /// 🔵 appBar
        appBar: CustomAppBar(
          isSearchVisible: _isSearchVisible,
          onSearchPressed: () {
            setState(() {
              _isSearchVisible = !_isSearchVisible;
              if (!_isSearchVisible) {
                _searchController.clear();
                searchQuery = "";
                _updateFilteredResults();
              }
            });
          },
          onStatsPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StatsPage(movies: allMovies, series: allSeries),
              ),
            );
          },
          searchController: _searchController,
          onSearchChanged: (value) {
            setState(() {
              searchQuery = value;
              _updateFilteredResults();
            });
          },
        ),

        /// 🔵 drawer
        drawer: CustomDrawer(
          appVersion: appVersion,
          allMovies: allMovies,
          allSeries: allSeries,
        ),

        /// 🔵 body
        body: CustomBody(
          loading: loading,
          movies: movies,
          series: series,
          filter: filter,
          onFilterSelected: (newFilter) {
            setState(() {
              filter = newFilter;
              _updateFilteredResults();
            });
          },
          onMovieTap: (movie) => loadOmdb(movie),
        ),
      ),
    );
  }
}
