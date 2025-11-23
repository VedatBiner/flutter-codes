// 📃 <----- home_page.dart ----->
//
//  Ana ekran.  Fihrist / klasik liste, arama, çekmece menü, FAB
//  ve JSON-dan veritabanı yenileme işlemlerini içerir.
//

// 📌 Dart hazır paketleri
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';

/// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../providers/item_count_provider.dart';

/// 📌 iki ana ekran burada
import '../screens/alphabet_item_list.dart';
import '../screens/item_list.dart';
import '../utils/download_directory_helper.dart';
import '../utils/file_creator.dart';

/// 📌 AppBar, Drawer, FAB yüklemeleri burada
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';
import '../widgets/sql_loading_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🔢  Veri listeleri
  List<Word> words = [];
  List<Word> allWords = [];

  // 🔎  Arama & görünüm durumları
  bool isSearching = false;
  bool isFihristMode = true;
  final TextEditingController searchController = TextEditingController();

  // ℹ️  Uygulama versiyonu
  String appVersion = '';

  // ⏳  Yükleme ekranı durumları
  bool isLoadingJson = false;
  double progress = 0.0;
  String? loadingWord;
  Duration elapsedTime = Duration.zero;
  static const tag = 'home_page';

  @override
  void initState() {
    super.initState();

    /// 🔹 Download klasörü hazırlığı (1 kez)
    _prepareDownloadDirectory();

    /// 🔹 Cihaz bilgisi log
    _logDeviceInfo();

    /// 🔹 Uygulama versiyon bilgisi
    _getAppVersion();

    /// 🔹 İlk veri yüklemesi
    loadData();
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
    log("------------------------------------------", name: tag);
    log("📱 Cihaz: ${android.model}", name: tag);
    log("🧩 Android Sürüm: ${android.version.release}", name: tag);
    log("🛠 API: ${android.version.sdkInt}", name: tag);
    log("------------------------------------------", name: tag);
  }

  /// 📌 Download dizinini kontrol eder ve gerekirse oluşturur.
  Future<void> _prepareDownloadDirectory() async {
    // Hata düzeltildi: `prepareDownloadDirectory` metodu parametre almıyor.
    final dir = await prepareDownloadDirectory();

    if (dir != null) {
      log("📂 Download klasörü hazır: ${dir.path}", name: tag);
    } else {
      log("⚠️ Download klasörü hazırlanamadı.", name: tag);
    }
  }

  /// 📌 İlk açılışta ve menüden tetiklendiğinde veri akışını başlatır.
  Future<void> loadData() async {
    setState(() => isLoadingJson = true);
    await initializeAppDataFlow();
    await _loadWords(); // Veritabanından kelimeleri yükle
    setState(() => isLoadingJson = false);
  }

  /// 🔄  Kelimeleri veritabanından yeniden oku
  Future<void> _loadWords() async {
    allWords = await DbHelper.instance.getRecords();
    final count = await DbHelper.instance.countRecords();

    setState(() => words = allWords);

    // 🔥 Provider sayacı
    if (mounted) {
      Provider.of<WordCountProvider>(context, listen: false).setCount(count);
    }

    log('📦 Toplam kayıt sayısı: $count', name: tag);
  }

  /// 🔍  Arama filtreleme
  void _filterWords(String query) {
    final filtered = allWords.where((word) {
      final q = query.toLowerCase();
      return word.word.toLowerCase().contains(q) ||
          word.meaning.toLowerCase().contains(q);
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
                    // Bu bölüm artık doğrudan file_creator.dart'ı tetikliyor.
                    // Karmaşık geri bildirimler (progress, word vb.) şimdilik kaldırıldı.
                    onStatus(true, 0, 'Veriler hazırlanıyor...', Duration.zero);
                    await initializeAppDataFlow();
                    await _loadWords();
                    onStatus(false, 1, 'Tamamlandı', Duration.zero);
                  },
            ),

            /// 📄  Liste gövdesi
            body: isFihristMode
                ? AlphabetWordList(words: words, onUpdated: _loadWords)
                : WordList(words: words, onUpdated: _loadWords),

            // ➕  FAB
            floatingActionButton: CustomFAB(
              refreshWords: _loadWords,
              clearSearch: _clearSearch,
            ),
          ),
        ),

        // 🔄 Yükleme kartı
        if (isLoadingJson)
          SQLLoadingCard(
            progress: progress,
            loadingWord: loadingWord,
            elapsedTime: elapsedTime,
          ),
      ],
    );
  }
}
