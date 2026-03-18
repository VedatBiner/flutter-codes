// <----- lib/screens/home_page.dart ----->
//
// ============================================================================
// 🏠 HomePage – Ana Ekran (Film & Dizi Listeleme Merkezi)
// ============================================================================
//
// Bu dosya uygulamanın ana ekranıdır.
// Netflix izleme geçmişinden oluşturulan film ve dizi listelerini
// yükler, filtreler, arama yapar ve kullanıcıya sunar.
//
// ---------------------------------------------------------------------------
// 🔹 Sorumlulukları
// ---------------------------------------------------------------------------
// 1️⃣ CSV verisini parse ederek film ve dizileri oluşturur.
// 2️⃣ Film ve dizileri ayrı listelerde tutar (movies / series).
// 3️⃣ Arama (search) ve filtre (FilterOption) işlemlerini yönetir.
// 4️⃣ OMDb bilgilerini lazy-loading mantığıyla yükler.
// 5️⃣ Stats sayfasına verileri Get.arguments ile gönderir.
// 6️⃣ Download klasörü hazırlığını başlatır.
// 7️⃣ Uygulama versiyon ve cihaz bilgilerini loglar.
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Rolü
// ---------------------------------------------------------------------------
// • UI container görevi görür.
// • Veri işleme (parse, filtreleme) burada başlatılır.
// • Görsel bileşenler CustomBody, CustomAppBar, CustomDrawer ile ayrılmıştır.
// • İş mantığı yardımcı utils dosyalarına dağıtılmıştır.
//
// ---------------------------------------------------------------------------
// ⚙️ Önemli Akış
// ---------------------------------------------------------------------------
// initState() içinde:
//   - Cihaz bilgisi loglanır
//   - Versiyon bilgisi alınır
//   - Download klasörü hazırlanır
//   - CSV parse edilir
//
// Filtreleme mantığı artık HomePage içinde yazılmaz.
// Bunun yerine WatchlistFilterEngine kullanılır.
//
// ============================================================================

import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/color_constants.dart';
import '../constants/file_info.dart';
import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';
import '../utils/download_directory_helper.dart';
import '../utils/omdb_lazy_loader.dart';
import '../utils/watchlist_filter_engine.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_body.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ==========================================================================
  // 🔎 Arama kontrolcüsü
  // ==========================================================================
  // AppBar içindeki arama TextField’ını kontrol eder.
  final _searchController = TextEditingController();

  // ==========================================================================
  // 📦 Ham veri listeleri
  // ==========================================================================
  // CSV ’den parse edilen tüm veriler burada tutulur.
  List<NetflixItem> allMovies = [];
  List<SeriesGroup> allSeries = [];

  // ==========================================================================
  // 🎯 Filtrelenmiş veri listeleri
  // ==========================================================================
  // Arama ve filtre sonrası ekrana gösterilecek listeler burada tutulur.
  List<NetflixItem> movies = [];
  List<SeriesGroup> series = [];

  // ==========================================================================
  // ⏳ UI state
  // ==========================================================================
  bool loading = true;
  bool _isSearchVisible = false;
  String searchQuery = "";
  FilterOption filter = FilterOption.all;

  /// ℹ️ Uygulama versiyon bilgisi
  String appVersion = '';

  static const tag = "home_page";

  // ==========================================================================
  // 🚀 initState()
  // ==========================================================================
  // Sayfa ilk oluşturulduğunda:
  // • cihaz bilgisi loglanır
  // • uygulama versiyonu alınır
  // • download klasörü hazırlanır
  // • CSV verisi yüklenir
  @override
  void initState() {
    super.initState();

    _logDeviceInfo();
    _getAppVersion();
    _prepareDownloadDirectory();
    loadData();
  }

  // ==========================================================================
  // 🧹 dispose()
  // ==========================================================================
  // TextEditingController bellekten temizlenir.
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // 📦 _getAppVersion()
  // ==========================================================================
  // package_info_plus ile uygulama versiyonunu alır.
  // Drawer alt bölümünde kullanıcıya gösterilir.
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  // ==========================================================================
  // 📱 _logDeviceInfo()
  // ==========================================================================
  // Android cihaz modelini ve sürüm bilgilerini log ’a yazar.
  // Gerçek cihaz / emülatör farklarını izlemek için faydalıdır.
  Future<void> _logDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    log(logLine, name: tag);
    log("📱 Cihaz: ${android.model}", name: tag);
    log("🧩 Android Sürüm: ${android.version.release}", name: tag);
    log("🛠 API: ${android.version.sdkInt}", name: tag);
    log(logLine, name: tag);
  }

  // ==========================================================================
  // 📂 _prepareDownloadDirectory()
  // ==========================================================================
  // Download/{appName} klasörünü hazırlamaya çalışır.
  // Export ve paylaşım işlemlerinin sorunsuz çalışması için ön hazırlıktır.
  Future<void> _prepareDownloadDirectory() async {
    final dir = await prepareDownloadDirectory(tag: tag);

    if (dir != null) {
      log("📂 Download klasörü hazır: ${dir.path}", name: tag);
    } else {
      log("⚠️ Download klasörü hazırlanamadı.", name: tag);
    }

    log(logLine, name: tag);
  }

  // ==========================================================================
  // 📜 loadData()
  // ==========================================================================
  // CSV verisini parse eder ve:
  // • allMovies / allSeries listelerine yazar
  // • ilk filtreleme sonucunu üretir
  // • loading state ’i kapatır
  Future<void> loadData() async {
    final parsed = await CsvParser.parseCsvFast();

    log("📜 CSV dosyası yüklendi.", name: tag);
    log(logLine, name: tag);

    allMovies = parsed.movies;
    allSeries = parsed.series;

    final result = WatchlistFilterEngine.apply(
      searchQuery: searchQuery,
      filter: filter,
      allMovies: allMovies,
      allSeries: allSeries,
    );

    if (!mounted) return;

    setState(() {
      movies = result.movies;
      series = result.series;
      loading = false;
    });
  }

  // ==========================================================================
  // 🔄 _updateFilteredResults()
  // ==========================================================================
  // Arama metni ve aktif filtreye göre film/dizi listelerini yeniden hesaplar.
  //
  // Bu mantık artık doğrudan burada yazılmaz.
  // WatchlistFilterEngine.apply(...) çağrılır.
  void _updateFilteredResults() {
    final result = WatchlistFilterEngine.apply(
      searchQuery: searchQuery,
      filter: filter,
      allMovies: allMovies,
      allSeries: allSeries,
    );

    setState(() {
      movies = result.movies;
      series = result.series;
    });
  }

  // ==========================================================================
  // 🌐 loadOmdb()
  // ==========================================================================
  // Filme ait OMDb bilgisini ihtiyaç halinde yükler.
  // Poster, yıl, tür ve rating bilgileri burada doldurulur.
  Future<void> loadOmdb(NetflixItem movie) async {
    await OmdbLazyLoader.loadOmdbIfNeeded(movie);
    if (!mounted) return;
    setState(() {});
  }

  // ==========================================================================
  // 🏗 build()
  // ==========================================================================
  // Ana sayfanın UI ağacını üretir:
  // • CustomAppBar
  // • CustomDrawer
  // • CustomBody
  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isLightTheme ? cardLightColor : null,

        // 🔵 AppBar
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
            Get.toNamed(
              '/stats',
              arguments: {
                'movies': allMovies,
                'series': allSeries,
              },
            );
          },

          searchController: _searchController,

          onSearchChanged: (value) {
            searchQuery = value;
            _updateFilteredResults();
          },
        ),

        // 🔵 Drawer
        drawer: CustomDrawer(
          appVersion: appVersion,
          allMovies: allMovies,
          allSeries: allSeries,
        ),

        // 🔵 Body
        body: CustomBody(
          loading: loading,
          movies: movies,
          series: series,
          filter: filter,

          onFilterSelected: (newFilter) {
            filter = newFilter;
            _updateFilteredResults();
          },

          onMovieTap: (movie) => loadOmdb(movie),
        ),
      ),
    );
  }
}