// 📃 <----- home_page.dart ----->
//
//  Ana ekran.  Fihrist / klasik liste, arama, çekmece menü, FAB
//  ve JSON-dan veritabanı yenileme işlemlerini içerir.
//

// 📌 Dart hazır paketleri
import 'dart:async';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';

/// 📌 Flutter hazır paketleri
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../constants/file_info.dart';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../providers/active_word_card_provider.dart';
import '../providers/item_count_provider.dart';

/// 📌 iki ana ekran burada
import '../screens/alphabet_item_list.dart';
import '../utils/download_directory_helper.dart';
import '../utils/file_creator.dart';

/// 📌 AppBar, Drawer, FAB yüklemeleri burada
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 🔢  Veri listeleri
  List<Word> words = [];
  List<Word> allWords = [];

  // 🔎  Arama & görünüm durumları
  bool isSearching = false;
  bool isFihristMode = true;
  bool _suspendList = false;
  final TextEditingController searchController = TextEditingController();

  // 🔁 Arama için debounce (klavye takılmasını engeller)
  Timer? _searchDebounce;

  // ℹ️  Uygulama versiyonu
  String appVersion = '';

  // ⏳  Yükleme ekranı durumları
  bool isLoadingJson = false;
  double progress = 0.0;
  String? loadingWord;
  Duration elapsedTime = Duration.zero;
  static const tag = 'home_page';

  final FocusNode _searchFocusNode = FocusNode();

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

  @override
  void dispose() {
    // Debounce timer ’ı ve controller ’ı düzgün kapat
    _searchFocusNode.dispose();
    _searchDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
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

  /// 📌 Download dizinini kontrol eder ve gerekirse oluşturur.
  Future<void> _prepareDownloadDirectory() async {
    final dir = await prepareDownloadDirectory();

    log(logLine, name: tag);
    if (dir != null) {
      log("📂 Download klasörü hazır: ${dir.path}", name: tag);
    } else {
      log("⚠️ Download klasörü hazırlanamadı.", name: tag);
    }
    log(logLine, name: tag);
  }

  /// 📌 İlk açılışta ve menüden tetiklendiğinde veri akışını başlatır.
  Future<void> loadData() async {
    setState(() => isLoadingJson = true);
    await initializeAppDataFlow(context);
    await _loadWords(); // Veritabanından kelimeleri yükle
    if (!mounted) return;
    setState(() => isLoadingJson = false);
  }

  /// 🔄  Kelimeleri veritabanından yeniden oku
  Future<void> _loadWords() async {
    allWords = await DbHelper.instance.getRecords();
    final count = await DbHelper.instance.countRecords();

    if (!mounted) return;
    setState(() => words = allWords);

    // 🔥 Provider sayacı
    Provider.of<WordCountProvider>(context, listen: false).setCount(count);

    log('📦 Toplam kayıt sayısı: $count', name: tag);
    log(logLine, name: tag);
  }

  /// 🔍  Arama filtreleme (DEBOUNCE ’LU)
  ///
  /// Her tuşta hemen filtre yapmak yerine 250 ms bekler.
  /// Böylece klavye animasyonu akıcı olur, liste kasmaz.
  void _filterWords(String query) {
    // Boş arama → direkt tüm listeyi göster
    if (query.trim().isEmpty) {
      _searchDebounce?.cancel();
      if (!mounted) return;
      setState(() => words = allWords);
      return;
    }

    // Önceki timer ’ı iptal et
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce!.cancel();
    }

    // 250 ms sonra aramayı çalıştır
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      final q = query.toLowerCase();

      final filtered = allWords.where((word) {
        return word.word.toLowerCase().contains(q) ||
            word.meaning.toLowerCase().contains(q);
      }).toList();

      if (!mounted) return;
      setState(() => words = filtered);
    });
  }

  /// ❌  Aramayı temizle
  void _clearSearch() {
    searchController.clear();
    _searchDebounce?.cancel();
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
            key: _scaffoldKey,

            onDrawerChanged: (isOpen) {
              if (isOpen) {
                // 🔥 Drawer AÇILDI → açık kartları kapat
                Provider.of<ActiveWordCardProvider>(
                  context,
                  listen: false,
                ).close();

                // 🔍 Arama açıksa onu da kapat
                if (isSearching) {
                  _clearSearch();
                }
              }
            },

            // 📜 AppBar
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: CustomAppBar(
                isSearching: isSearching,
                searchController: searchController,
                searchFocusNode: _searchFocusNode,
                onSearchChanged: _filterWords,
                onClearSearch: _clearSearch,
                onStartSearch: () {
                  setState(() {
                    _suspendList = true;
                    isSearching = true;
                  });

                  // 🔥 klavye UI sakinleşince gelsin
                  Future.delayed(const Duration(milliseconds: 120), () {
                    if (!mounted) return;
                    _searchFocusNode.requestFocus();

                    // listeyi geri aç
                    setState(() {
                      _suspendList = false;
                    });
                  });
                },

                itemCount: words.length,
                onDrawerPressed: () {
                  if (isSearching) {
                    _clearSearch(); // 🔥 ARAMA KAPANIR
                  }
                  _scaffoldKey.currentState?.openDrawer(); // 🔥 DRAWER AÇILIR
                },
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
              onCloseSearch: _clearSearch,
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
                    onStatus(true, 0, 'Veriler hazırlanıyor...', Duration.zero);
                    await initializeAppDataFlow(context);
                    await _loadWords();
                    onStatus(false, 1, 'Tamamlandı', Duration.zero);
                  },
            ),

            /// 📄  Liste gövdesi
            /// Bir süre ikinci seçenek iptal
            // body: isFihristMode
            //     ? AlphabetWordList(words: words, onUpdated: _loadWords)
            //     : WordList(words: words, onUpdated: _loadWords),

            /// Geçici olarak sadece alfabetik liste olsun
            body: _suspendList
                ? const SizedBox.shrink() // 👈 klavye açılırken liste çizilmez
                : AlphabetItemList(words: words, onUpdated: _loadWords),

            // ➕  FAB
            floatingActionButton: CustomFAB(
              refreshWords: _loadWords,
              clearSearch: _clearSearch,
            ),
          ),
        ),
      ],
    );
  }
}
