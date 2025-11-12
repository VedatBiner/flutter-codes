// 📃 <----- lib/screens/home_page.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Ana sayfa:
//  • Veritabanı ve dosya kontrolü (file_creator.dart)
//  • Film / Dizi kartlarını listeler (items_card.dart)
//  • Yükleme durumunu gösterir (loading_card.dart)
//  • Arama, liste yenileme ve Drawer menüsü içerir.
//
// -----------------------------------------------------------

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../utils/file_creator.dart'; // Veri oluşturma & kopyalama akışı
import '../utils/storage_permission_helper.dart';
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

  // 🔎 Arama & görünüm durumları
  bool isSearching = false;
  bool isFihristMode = true;
  final TextEditingController searchController = TextEditingController();

  // ⏳ Yükleme durumları
  bool isLoadingJson = false;
  double progress = 0.0;
  String? loadingItem;
  Duration elapsedTime = Duration.zero;

  // ℹ️ Uygulama sürümü (gelecekte dinamik alınabilir)
  String appVersion = "1.0.0";

  @override
  void initState() {
    super.initState();

    // 🚀 Uygulama başlatıldığında tüm veri akışı başlatılır
    _initializeData();
    _getAppVersion();
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  /// 🚀 Uygulama başlatıldığında veritabanı kontrolü ve yükleme işlemi
  Future<void> _initializeData() async {
    setState(() => isLoadingJson = true);
    final stopwatch = Stopwatch()..start();

    // Önce depolama iznini kontrol et ve iste
    await ensureStoragePermission();

    await initializeAppDataFlow();
    await _loadItems();

    stopwatch.stop();
    setState(() {
      isLoadingJson = false;
      elapsedTime = stopwatch.elapsed;
    });

    log(
      '✅ Uygulama verisi başarıyla yüklendi (${elapsedTime.inSeconds} sn)',
      name: 'HomePage',
    );
  }

  /// 🔄 Veritabanından kayıtları yeniden oku
  Future<void> _loadItems() async {
    final records = await DbHelper.instance.getRecords();
    final count = await DbHelper.instance.countRecords();

    // 🔹 İzlenme tarihine göre yeni → eski sırala
    records.sort((a, b) {
      // beklenen format: "gg/aa/yy"
      try {
        final da = _parseDate(a.watchDate);
        final db = _parseDate(b.watchDate);
        return db.compareTo(da); // en yeni en başta
      } catch (_) {
        return 0;
      }
    });

    setState(() {
      allNetflixItems = records;
      netflixItems = records;
    });

    log('📦 Toplam kayıt sayısı: $count', name: "HomePage");
  }

  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = int.tryParse(parts[1]) ?? 1;
        final year = int.tryParse(parts[2]) ?? 0;
        return DateTime(year < 100 ? 2000 + year : year, month, day);
      }
      return DateTime(1900);
    } catch (_) {
      return DateTime(1900);
    }
  }

  /// 🔍 Arama filtreleme
  void _filterItems(String query) {
    final filtered = allNetflixItems.where((item) {
      final q = query.toLowerCase();
      return item.netflixItemName.toLowerCase().contains(q) ||
          item.watchDate.toLowerCase().contains(q);
    }).toList();

    setState(() => netflixItems = filtered);
  }

  /// ❌ Aramayı temizle
  void _clearSearch() {
    searchController.clear();
    setState(() {
      isSearching = false;
      netflixItems = allNetflixItems;
    });
  }

  // -----------------------------------------------------------
  // 🧩 UI
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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

        // 🔽 Ana içerik alanı
        body: isLoadingJson
            ? LoadingCard(
                progress: progress,
                currentItem: loadingItem,
                elapsed: elapsedTime,
                title: "Veriler yükleniyor...",
              )
            : netflixItems.isEmpty
            ? const Center(
                child: Text(
                  "Henüz kayıt yok.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: netflixItems.length,
                itemBuilder: (context, index) {
                  final item = netflixItems[index];
                  return NetflixItemCard(item: item);
                },
              ),
      ),
    );
  }
}
