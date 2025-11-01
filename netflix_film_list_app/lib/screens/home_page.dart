// 📦 home_page.dart

import 'dart:developer';

import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../utils/file_creator.dart';
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
  bool isLoadingJson = false;
  double progress = 0.0;
  String? loadingItem;
  Duration elapsedTime = Duration.zero;

  // ℹ️  Uygulama versiyonu
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    // 🚀 Uygulama ilk açıldığında veritabanı ve dosyaları kontrol et
    checkIfDatabaseExists().then((_) async {
      /// asset ’ten cihaz CSV ’si üret
      await createDeviceCsvFromAssetWithDateFix();

      /// asset ’ten cihaz JSON ’si üret
      await createJsonFromAssetCsv();

      /// asset ’ten cihaz XLSX ’si üret
      await createExcelFromAssetCsvSyncfusion();

      /// 🔥 JSON → SQL aktarımı
      await importJsonToDatabaseFast();
    });
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

  /// 🔄  Veritabanından kayıtları yeniden oku
  Future<void> _loadItems() async {
    final records = await DbHelper.instance.getRecords();
    final count = await DbHelper.instance.countRecords();

    setState(() {
      allNetflixItems = records;
      netflixItems = records;
    });

    log('📦 Toplam kayıt sayısı: $count', name: "HomePage");
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

            /// 📁 Drawer
            drawer: CustomDrawer(
              onDatabaseUpdated: _loadItems,
              appVersion: appVersion,
              isFihristMode: isFihristMode,
              onToggleViewMode: () {
                setState(() => isFihristMode = !isFihristMode);
              },

              // 🔹 JSON/SQL yükleme işlemi geçici olarak devre dışı
              // onLoadJsonData: (...) { ... },
            ),

            // 🔽 Ana içerik
            body: isLoadingJson
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

  /// ⏳ Yükleme Kartı (ileride tekrar aktif edilebilir)
  Widget _buildLoadingCard() {
    return Center(
      child: Card(
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Veriler yükleniyor...",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                color: Colors.redAccent,
                backgroundColor: Colors.white12,
              ),
              const SizedBox(height: 8),
              if (loadingItem != null)
                Text(
                  'Şu anda: $loadingItem',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              const SizedBox(height: 4),
              Text(
                'Geçen süre: ${elapsedTime.inSeconds} sn',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
