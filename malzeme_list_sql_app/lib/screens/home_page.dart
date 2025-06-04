// 📃 <----- home_page.dart ----->
//
//  Ana ekran.  Fihrist / klasik liste, arama, çekmece menü, FAB
//  ve JSON-dan veritabanı yenileme işlemlerini içerir.
//

// 📌 Flutter hazır paketleri
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';
import '../models/malzeme_model.dart';
import '../providers/malzeme_count_provider.dart';
import '../utils/json_loader.dart';

/// 📌 AppBar, Drawer, FAB yüklemeleri burada
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';
import 'alphabet_malzeme_list.dart';
import 'malzeme_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🔢  Veri listeleri
  List<Malzeme> words = [];
  List<Malzeme> allWords = [];

  // 🔎  Arama & görünüm durumları
  bool isSearching = false;
  bool isFihristMode = true;
  final TextEditingController searchController = TextEditingController();

  // ℹ️  Uygulama versiyonu
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _getAppVersion();
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  /// 📌 İlk açılışta verileri (gerekirse) yükle
  void _loadInitialData() async {
    await loadDataFromDatabase(
      context: context,
      onLoaded: (loadedWords) {
        setState(() {
          allWords = loadedWords;
          words = loadedWords;
        });

        /// 🔥 Provider ile kelime sayısını güncelle
        Provider.of<MalzemeCountProvider>(
          context,
          listen: false,
        ).setCount(loadedWords.length);
      },

      /// 🔄 İlk açılışta yükleme kartı gösterilmiyor
      onLoadingStatusChange: (_, __, ___, ____) {},
    );
  }

  /// 🔄  Kelimeleri veritabanından yeniden oku
  Future<void> _loadWords() async {
    allWords = await MalzemeDatabase.instance.getWords();
    final count = await MalzemeDatabase.instance.countWords();

    setState(() => words = allWords);

    // 🔥 Provider sayacı
    if (mounted) {
      Provider.of<MalzemeCountProvider>(context, listen: false).setCount(count);
    }

    log('📦 Toplam kayıt sayısı: $count');
  }

  /// 🔍  Arama filtreleme
  void _filterWords(String query) {
    final filtered = allWords.where((word) {
      final q = query.toLowerCase();
      return word.malzeme.toLowerCase().contains(q);
    }).toList();

    setState(() => words = filtered);
  }

  /// ❌  Aramayı temizle
  void _clearSearch() {
    searchController.clear();
    setState(() {
      isSearching = false;
      words = allWords;
    });
  }

  // 🖼️  UI
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // 📜 AppBar
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: CustomAppBar(
            isSearching: isSearching,
            searchController: searchController,
            onSearchChanged: _filterWords,
            onClearSearch: _clearSearch,
            onStartSearch: () => setState(() => isSearching = true),
            itemCount: words.length,
          ),
        ),

        /// 📁 Drawer
        drawer: CustomDrawer(
          onDatabaseUpdated: _loadWords,
          appVersion: appVersion,
          isFihristMode: isFihristMode,
          onToggleViewMode: () {
            setState(() => isFihristMode = !isFihristMode);
          },

          //  ⬇️  Drawer ’dan gelen geri-çağrı (SQL yüklemesi)
          onLoadJsonData:
              ({
                required BuildContext ctx,
                required void Function(
                  bool loading,
                  double prog,
                  String? currentWord,
                  Duration elapsedTime,
                )
                onStatus,
              }) async {
                await loadDataFromDatabase(
                  context: context, // ⚠️ HomePage context ’i
                  onLoaded: (loadedWords) {
                    setState(() {
                      allWords = loadedWords;
                      words = loadedWords;
                    });

                    if (mounted) {
                      Provider.of<MalzemeCountProvider>(
                        context,
                        listen: false,
                      ).setCount(loadedWords.length);
                    }
                  },

                  // 🔄 SQLLoadingCardOverlay’a durumu ilet
                  onLoadingStatusChange:
                      (
                        bool loading,
                        double prog,
                        String? currentWord,
                        Duration elapsed,
                      ) {
                        onStatus(loading, prog, currentWord, elapsed);
                      },
                );
              },
        ),

        /// 📄  Liste gövdesi
        body: isFihristMode
            ? AlphabetMalzemeList(malzemeler: words, onUpdated: _loadWords)
            : MalzemeList(malzemeler: words, onUpdated: _loadWords),

        // ➕  FAB
        floatingActionButton: CustomFAB(
          refreshWords: _loadWords,
          clearSearch: _clearSearch,
        ),
      ),
    );
  }
}
