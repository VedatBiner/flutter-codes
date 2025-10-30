// 📦 main.dart

// 📌 Flutter hazır paketleri
import 'dart:developer';

import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../utils/json_loader.dart';
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
  String? loadingWord;
  Duration elapsedTime = Duration.zero;

  // ℹ️  Uygulama versiyonu
  String appVersion = '';

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

  /// 🔄  Kelimeleri veritabanından yeniden oku
  Future<void> _loadItems() async {
    allNetflixItems = await DbHelper.instance.getRecords();
    final count = await DbHelper.instance.countRecords();

    setState(() => netflixItems = allNetflixItems);

    // // 🔥 Provider sayacı
    // if (mounted) {
    //   Provider.of<WordCountProvider>(context, listen: false).setCount(count);
    // }

    log('📦 Toplam kayıt sayısı: $count', name: "Home Page");
  }

  /// 🖼️  UI
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            // 📜 AppBar
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: CustomAppBar(
                isSearching: isSearching,
                searchController: searchController,
                onSearchChanged: _filterItems,
                onClearSearch: _clearSearch,
                onStartSearch: () => setState(() => isSearching = true),
                // itemCount: words.length,
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

              //  ⬇️  Yeni imzalı geri-çağrı
              onLoadJsonData:
                  ({
                    required BuildContext
                    ctx, // Drawer ’dan gelir, kullanmıyoruz
                    required void Function(
                      bool loading,
                      double prog,
                      String? currentWord,
                      Duration elapsedTime,
                    )
                    onStatus,
                  }) async {
                    await loadDataFromDatabase(
                      context: context, //  ⚠️  HomePage’in context ’i
                      onLoaded: (loadedWords) {
                        setState(() {
                          allNetflixItems = loadedWords;
                          netflixItems = loadedWords;
                        });

                        // if (mounted) {
                        //   Provider.of<WordCountProvider>(
                        //     context,
                        //     listen: false,
                        //   ).setCount(loadedWords.length);
                        // }
                      },

                      //  ⬇️  Drawer ’a da aynı geri-bildirimi ilet
                      onLoadingStatusChange:
                          (
                            bool loading,
                            double prog,
                            String? currentWord,
                            Duration elapsed,
                          ) {
                            setState(() {
                              isLoadingJson = loading;
                              progress = prog;
                              loadingWord = currentWord;
                              elapsedTime = elapsed;
                            });
                            onStatus(
                              loading,
                              prog,
                              currentWord,
                              elapsed,
                            ); // ↩︎ ilet
                          },
                    );
                  },
            ),
          ),
        ),
      ],
    );
  }
}
