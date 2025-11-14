// 📦 home_page.dart
// --------------------------------------------------------------
// 🎬 Netflix Film List App
// Uygulamanın ana ekranı:
//  • SQL verilerini yükler
//  • Arama (search) işlemi yapar
//  • Drawer menüsünü kullanır
//  • IMDb verisiyle film / dizi ayrımı yapmaya hazırlanır
// --------------------------------------------------------------

import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

// 📦 Dahili dosyalar
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../utils/file_creator.dart';
import '../utils/imdb_fetcher.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/homepage_widgets/items_card.dart';
import '../widgets/homepage_widgets/loading_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🔢 Veri listeleri
  List<NetflixItem> netflixItems = [];
  List<NetflixItem> allNetflixItems = [];

  // 🆕 IMDb ile ayrıştırılmış listeler
  List<NetflixItem> movies = [];
  List<NetflixItem> series = [];

  // 🔎 Arama & görünüm
  bool isSearching = false;
  bool isFihristMode = true;
  final TextEditingController searchController = TextEditingController();

  // ⏳ Yükleme ekranı
  bool isLoadingJson = false;
  double progress = 0.0;
  Duration elapsedTime = Duration.zero; // Şimdilik sadece state ’te tutuluyor

  // ℹ️ Versiyon (şu an boş, istersen package_info_plus ile doldururuz)
  String appVersion = '';

  @override
  void initState() {
    super.initState();

    // 🔹 Cihaz bilgisi log
    _logDeviceInfo();

    // 🔹 Başlangıç veri akışı (SQL, CSV, JSON, EXCEL, Download kopyalama)
    initializeAppDataFlow().then((_) async {
      await _loadItems();
      await _applyImdbClassification(); // IMDb 'den ayrıştırma
    });
  }

  /// 📌 Cihaz bilgilerini log 'a yazar
  Future<void> _logDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    log("📱 Cihaz: ${android.model}", name: "device_info");
    log("🧩 Android Sürüm: ${android.version.release}", name: "device_info");
    log("🛠 API: ${android.version.sdkInt}", name: "device_info");
  }

  /// 🔄 SQL verilerini yükler
  Future<void> _loadItems() async {
    final records = await DbHelper.instance.getRecords();
    final count = await DbHelper.instance.countRecords();

    // 🆕 Tarihe göre sondan başa sırala (en son izlenen en üstte)
    records.sort((a, b) {
      try {
        final da = _parseDate(a.watchDate);
        final db = _parseDate(b.watchDate);
        return db.compareTo(da);
      } catch (_) {
        return 0;
      }
    });

    setState(() {
      allNetflixItems = records;
      netflixItems = records;
    });

    log('📦 SQL ’den yüklenen kayıt sayısı: $count', name: "HomePage");
  }

  /// 🧮 Tarih parse edici ("gg/aa/yy" bekliyoruz)
  DateTime _parseDate(String s) {
    final p = s.split('/');
    // s = "31/12/25" → yıl = 2025
    return DateTime(int.parse("20${p[2]}"), int.parse(p[1]), int.parse(p[0]));
  }

  /// 🎬 IMDb sınıfını kullanarak film/dizi ayır
  ///
  /// imdb_fetcher.dart şu an sadece `fetchInfo(title)` sağlıyor,
  /// o yüzden `type == 'series'` kontrolü ile ayırıyoruz.
  Future<void> _applyImdbClassification() async {
    final imdb = ImdbFetcher();

    List<NetflixItem> tempMovies = [];
    List<NetflixItem> tempSeries = [];

    for (final item in allNetflixItems) {
      final info = await imdb.fetchInfo(item.netflixItemName);

      final type = (info?['type'] ?? 'movie').toString().toLowerCase();

      if (type == 'series') {
        tempSeries.add(item);
      } else {
        tempMovies.add(item);
      }
    }

    setState(() {
      movies = tempMovies;
      series = tempSeries;
    });

    log(
      "🎬 Filmler: ${movies.length}, 📺 Diziler: ${series.length}",
      name: "IMDb",
    );
  }

  /// ❌ Aramayı temizle
  void _clearSearch() {
    searchController.clear();
    setState(() {
      isSearching = false;
      netflixItems = allNetflixItems;
    });
  }

  /// 🔍 Arama filtreleme
  void _filterItems(String query) {
    final q = query.toLowerCase();
    final filtered = allNetflixItems.where((item) {
      return item.netflixItemName.toLowerCase().contains(q) ||
          item.watchDate.toLowerCase().contains(q);
    }).toList();

    setState(() {
      isSearching = q.isNotEmpty;
      netflixItems = filtered;
    });
  }

  /// 🖼️ UI
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,

            // 📜 AppBar
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: CustomAppBar(
                isSearching: isSearching,
                searchController: searchController,
                onSearchChanged: _filterItems,
                onClearSearch: _clearSearch,
                onStartSearch: () => setState(() => isSearching = true),
              ),
            ),

            // 📁 Drawer
            drawer: CustomDrawer(
              onDatabaseUpdated: _loadItems,
              appVersion: appVersion,
              isFihristMode: isFihristMode,
              onToggleViewMode: () {
                setState(() => isFihristMode = !isFihristMode);
              },
            ),

            // 📄 Ana içerik
            body: isLoadingJson
                // 🔴 LoadingCard şu an sadece `progress` alıyor (hata mesajından biliyoruz)
                ? LoadingCard(progress: progress)
                : _buildContent(),
          ),
        ),
      ],
    );
  }

  /// 🎬 İçerik (Film / Dizi gruplu içerik + arama davranışı)
  Widget _buildContent() {
    // 🔎 Eğer arama aktifse IMDb gruplarını boşver, filtrelenmiş listeyi göster
    if (isSearching && searchController.text.isNotEmpty) {
      return ListView.builder(
        itemCount: netflixItems.length,
        itemBuilder: (context, index) {
          return NetflixItemCard(item: netflixItems[index]);
        },
      );
    }

    // Eğer IMDb ayrımı henüz yapılmadıysa, tüm listeyi tek blok göster
    final hasImdbSplit = movies.isNotEmpty || series.isNotEmpty;
    if (!hasImdbSplit) {
      return ListView.builder(
        itemCount: allNetflixItems.length,
        itemBuilder: (context, index) {
          return NetflixItemCard(item: allNetflixItems[index]);
        },
      );
    }

    // IMDb ayrımı varsa: Filmler + Diziler başlıklı bloklar
    return ListView(
      children: [
        if (movies.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Text(
              "🎬 Filmler",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...movies.map((item) => NetflixItemCard(item: item)).toList(),
          const SizedBox(height: 16),
        ],
        if (series.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Text(
              "📺 Diziler",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...series.map((item) => NetflixItemCard(item: item)).toList(),
        ],
      ],
    );
  }
}
