// <----- lib/screens/home_page.dart ----->
//
// ============================================================================
// 📺 HomePage – Ana Ekran (Film & Dizi Listeleme Merkezi)
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
//   - Export dosyaları oluşturulur (varsa)
//
// ---------------------------------------------------------------------------
// Bu dosya uygulamanın ana koordinasyon merkezidir.
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
import '../utils/search_and_filter.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_body.dart';
import '../widgets/custom_drawer.dart';
import '../utils/watchlist_filter_engine.dart';

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

  /// ℹ️ Uygulama versiyonu
  String appVersion = '';

  static const tag = "home_page";

  @override
  void initState() {
    super.initState();

    _logDeviceInfo();
    _getAppVersion();
    _prepareDownloadDirectory();
    loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// =========================================================================
  /// 📦 _getAppVersion
  /// =========================================================================
  /// PackageInfo kullanarak uygulamanın versiyon bilgisini alır.
  ///
  /// Bu bilgi Drawer içinde veya UI üzerinde gösterilebilir.
  ///
  /// Amaç:
  /// Kullanıcının hangi sürümü kullandığını görünür kılmak.
  /// =========================================================================
  Future<void> _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  /// =========================================================================
  /// 📱 _logDeviceInfo
  /// =========================================================================
  /// device_info_plus paketi ile cihaz modelini ve Android sürümünü loglar.
  ///
  /// Debug amaçlıdır.
  /// Özellikle gerçek cihaz / emülatör farklarını anlamak için kullanılır.
  ///
  /// Amaç:
  /// OMDb, internet veya dosya erişim sorunlarını cihaz bazında analiz etmek.
  /// =========================================================================
  Future<void> _logDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;
    log(logLine, name: tag);
    log("📱 Cihaz: ${android.model}", name: tag);
    log("🧩 Android Sürüm: ${android.version.release}", name: tag);
    log("🛠 API: ${android.version.sdkInt}", name: tag);
    log(logLine, name: tag);
  }

  /// =========================================================================
  /// 📂 _prepareDownloadDirectory
  /// =========================================================================
  /// Download/{appName} klasörünü hazırlar.
  ///
  ///  • Gerekirse depolama izni ister.
  ///  • Download klasörünü oluşturur.
  ///  • Log çıktısı üretir.
  ///
  /// Amaç:
  /// Export edilen CSV / JSON / XLSX dosyalarının paylaşılabilir
  /// konuma yazılmasını garanti altına almak.
  /// =========================================================================
  Future<void> _prepareDownloadDirectory() async {
    final dir = await prepareDownloadDirectory(tag: tag);
    if (dir != null) {
      log("📂 Download klasörü hazır: ${dir.path}", name: tag);
    } else {
      log("⚠️ Download klasörü hazırlanamadı.", name: tag);
    }
    log(logLine, name: tag);
  }

  /// =========================================================================
  /// 📜 loadData
  /// =========================================================================
  /// CSV dosyasını parse ederek film ve dizi listelerini oluşturur.
  ///
  ///  • CsvParser.parseCsvFast() çağrılır.
  ///  • Filmler ve diziler ayrı listelere ayrılır.
  ///  • loading state false yapılır.
  ///
  /// Amaç:
  /// Uygulamanın ana verisini belleğe yüklemek.
  /// =========================================================================
  Future<void> loadData() async {
    final parsed = await CsvParser.parseCsvFast();
    log("📜 CSV dosyası yüklendi.", name: tag);
    log(logLine, name: tag);

    if (!mounted) return;
    setState(() {
      allMovies = parsed.movies;
      allSeries = parsed.series;
      movies = parsed.movies;
      series = parsed.series;
      loading = false;
    });
  }

  /// =========================================================================
  /// 🔍 _updateFilteredResults
  /// =========================================================================
  /// Arama metni (searchQuery) ve seçili filtreye göre
  /// film ve dizi listelerini yeniden hesaplar.
  ///
  /// applySearchAndFilter() yardımcı fonksiyonunu kullanır.
  ///
  /// Amaç:
  /// Gerçek zamanlı filtreleme ve arama deneyimi sağlamak.
  /// =========================================================================
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

  /// =========================================================================
  /// 🌐 loadOmdb
  /// =========================================================================
  /// Bir filme ait OMDb bilgilerini lazy-loading yöntemiyle yükler.
  ///
  ///  • Eğer filmde imdbId veya originalTitle yoksa API çağrısı yapılır.
  ///  • Poster, yıl, tür ve rating bilgileri doldurulur.
  ///  • setState() ile UI güncellenir.
  ///
  /// Amaç:
  /// Gereksiz API çağrılarından kaçınarak performansı korumak.
  /// =========================================================================
  Future<void> loadOmdb(NetflixItem movie) async {
    await OmdbLazyLoader.loadOmdbIfNeeded(movie);
    if (!mounted) return;
    setState(() {});
  }

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// Ana ekranın UI ağacını oluşturur.
  ///
  /// Bileşenler:
  ///  • CustomAppBar
  ///  • CustomDrawer
  ///  • CustomBody (Film & Dizi listeleri)
  ///
  /// Tema (Light/Dark) kontrolü burada dinamik olarak uygulanır.
  ///
  /// Amaç:
  /// Tüm ana ekran layout ’unu tek merkezden üretmek.
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isLightTheme ? cardLightColor : null,

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
              arguments: {'movies': allMovies, 'series': allSeries},
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

        drawer: CustomDrawer(
          appVersion: appVersion,
          allMovies: allMovies,
          allSeries: allSeries,
        ),

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
