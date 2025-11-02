// 📦 lib/screens/home_page.dart
//
// 🎬 Netflix Film List App
// Ana ekran — uygulama açıldığında veritabanı, CSV/JSON/Excel dosyaları
// ve Download kopyalama işlemleri initializeAppDataFlow() ile yönetilir.
//

import 'dart:developer';

import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../utils/file_creator.dart'; // initializeAppDataFlow burada
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🔢  Veri listeleri
  List<NetflixItem> netflixItems = [];
  List<NetflixItem> allNetflixItems = [];

  // 🔎  Arama & görünüm durumları
  bool isSearching = false;
  bool isFihristMode = true;
  final TextEditingController searchController = TextEditingController();

  // ⏳  Yükleme ekranı durumları
  bool isLoading = false;
  double progress = 0.0;
  String? loadingItem;
  Duration elapsedTime = Duration.zero;

  // ℹ️  Uygulama versiyonu
  String appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();

    // 🚀 Uygulama ilk açıldığında veri akışı başlat
    _initializeAppData();
  }

  /// 🚀 Tüm veri akışını başlatır
  Future<void> _initializeAppData() async {
    const tag = 'HomePage Init';
    try {
      setState(() => isLoading = true);

      // 1️⃣ Veritabanı + dosya kontrol & üretim işlemleri
      await initializeAppDataFlow();

      // 2️⃣ Veritabanından kayıtları oku
      await _loadItems();

      setState(() => isLoading = false);
      log('✅ Uygulama başlatıldı ve veriler yüklendi.', name: tag);
    } catch (e) {
      log('🚨 Başlatma hatası: $e', name: tag);
      setState(() => isLoading = false);
    }
  }

  /// 🔄  Veritabanından kayıtları yeniden oku
  Future<void> _loadItems() async {
    final records = await DbHelper.instance.getRecords();
    final count = await DbHelper.instance.countRecords();

    setState(() {
      allNetflixItems = records;
      netflixItems = records;
    });

    log('📦 Veritabanından $count kayıt yüklendi.', name: "HomePage");
  }

  /// ❌  Aramayı temizle
  void _clearSearch() {
    searchController.clear();
    setState(() {
      isSearching = false;
      netflixItems = allNetflixItems;
    });
  }

  /// 🔍  Arama filtreleme
  void _filterItems(String query) {
    final filtered = allNetflixItems.where((item) {
      final q = query.toLowerCase();
      return item.netflixItemName.toLowerCase().contains(q) ||
          item.watchDate.toLowerCase().contains(q);
    }).toList();

    setState(() => netflixItems = filtered);
  }

  /// 🖼️  UI
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

            // 🔽 Ana içerik
            body: isLoading
                ? _buildLoadingCard()
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
                      return Card(
                        color: Colors.grey[900],
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.movie,
                            color: Colors.white70,
                          ),
                          title: Text(
                            item.netflixItemName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "İzlenme Tarihi: ${item.watchDate}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  /// ⏳ Yükleme Kartı (AppDataFlow sırasında gösterilir)
  Widget _buildLoadingCard() {
    return Center(
      child: Card(
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Veriler hazırlanıyor...",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 12),
              LinearProgressIndicator(
                color: Colors.redAccent,
                backgroundColor: Colors.white12,
              ),
              SizedBox(height: 8),
              Text(
                "Lütfen bekleyin, ilk yükleme biraz sürebilir.",
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
