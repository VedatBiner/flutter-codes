// 📜 <----- home_page.dart ----->

// 📌 Flutter paketleri
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../models/word_model.dart';
import '../providers/word_count_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../services/db_helper.dart';
import '../utils/json_loader.dart';
import '../widgets/bottom_waiting_overlay.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';
import '../widgets/sql_loading.dart';
import 'alphabet_word_list.dart';
import 'word_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 🔢  Veri listeleri
  List<Word> words = [];
  List<Word> allWords = [];

  /// 🔎  Arama & görünüm durumları
  bool isSearching = false;
  bool isFihristMode = true;
  final TextEditingController searchController = TextEditingController();

  /// ℹ️  Uygulama versiyonu
  String appVersion = '';

  /// ⏳  Yükleme ekranı durumları
  bool isLoadingJson = false;
  double progress = 0.0;
  String? loadingWord;
  Duration elapsedTime = Duration.zero;

  /// ⏳  Basit bekleme katmanı (🆕)
  bool isUpdating = false; // 🆕

  @override
  void initState() {
    super.initState();
    setState(() => isUpdating = true); // 🆕 katmanı aç
    _loadInitialData();
    _getAppVersion();
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = 'Versiyon: ${info.version}';
    });
  }

  /// 📌 İlk açılışta verileri (gerekirse) yükle
  void _loadInitialData() async {
    await loadDataFromDatabase(
      context: context,
      onLoaded: (loadedWords) {
        setState(() {
          allWords = loadedWords;
          words = loadedWords;
          isUpdating = false; // 🆕 katmanı kapat
        });

        if (mounted) {
          Provider.of<WordCountProvider>(
            context,
            listen: false,
          ).setCount(loadedWords.length);
        }
      },

      onLoadingStatusChange:
          (bool loading, double prog, String? currentWord, Duration elapsed) {
            setState(() {
              isLoadingJson = loading;
              progress = prog;
              loadingWord = currentWord;
              elapsedTime = elapsed;
            });
          },
    );
  }

  /// 🔄  Kelimeleri veritabanından yeniden oku
  Future<void> _loadWords() async {
    setState(() => isUpdating = true);
    allWords = await DbHelper.instance
        .fetchAllWords(); // opsiyonel: userEmail: '...'
    final count = await DbHelper.instance
        .countRecords(); // opsiyonel: userEmail: '...'

    setState(() {
      words = allWords;
      isUpdating = false; // 🆕 katman KAPAT
    });

    if (mounted) {
      Provider.of<WordCountProvider>(context, listen: false).setCount(count!);
    }
  }

  /// 🔍  Arama filtreleme
  void _filterWords(String query) {
    final filtered = allWords.where((word) {
      final q = query.toLowerCase();
      return word.sirpca.toLowerCase().contains(q) ||
          word.turkce.toLowerCase().contains(q);
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(76),

              /// 📌 Custom Appbar burada
              ///
              child: CustomAppBar(
                isSearching: isSearching,
                searchController: searchController,
                onSearchChanged: _filterWords,
                onClearSearch: _clearSearch,
                onStartSearch: () => setState(() => isSearching = true),
                itemCount: words.length,
              ),
            ),

            /// 📌 Custom Drawer burada
            ///
            drawer: buildCustomDrawer(context),

            /// 📌 Body Burada
            ///
            body: isFihristMode
                ? AlphabetWordList(words: words, onUpdated: _loadWords)
                : WordList(words: words, onUpdated: _loadWords),

            /// 📌 FAB Burada
            ///
            floatingActionButton: CustomFAB(
              refreshWords: _loadWords,
              clearSearch: _clearSearch,
            ),
          ),
        ),

        /// 📌 SQL JSON yükleme kartı (mevcut)
        ///
        if (isLoadingJson)
          SQLLoadingCard(
            progress: progress,
            loadingWord: loadingWord,
            elapsedTime: elapsedTime,
          ),

        /// 📌Basit bekleme katmanı (🆕)
        ///
        if (isUpdating) const BottomWaitingOverlay(),
      ],
    );
  }

  /// 📌 Custom Drawer burada
  ///
  CustomDrawer buildCustomDrawer(BuildContext context) {
    return CustomDrawer(
      onDatabaseUpdated: _loadWords,
      appVersion: appVersion,
      isFihristMode: isFihristMode,
      onToggleViewMode: () {
        setState(() => isFihristMode = !isFihristMode);
      },
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
              context: context,
              onLoaded: (loadedWords) {
                setState(() {
                  allWords = loadedWords;
                  words = loadedWords;
                });

                if (mounted) {
                  Provider.of<WordCountProvider>(
                    context,
                    listen: false,
                  ).setCount(loadedWords.length);
                }
              },
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
                    onStatus(loading, prog, currentWord, elapsed);
                  },
            );
          },
    );
  }
}
