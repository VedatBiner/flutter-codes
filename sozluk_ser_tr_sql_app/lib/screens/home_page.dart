// 📜 <----- home_page.dart ----->
//

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../db/db_helper.dart';
import '../models/word_model.dart';
import '../providers/word_count_provider.dart';
import '../utils/json_loader.dart';
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

  @override
  void initState() {
    super.initState();
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
    await WordDatabase.instance.syncFirestoreIfDatabaseEmpty(context);

    final finalWords = await WordDatabase.instance.getWords();

    setState(() {
      allWords = finalWords;
      words = finalWords;
    });

    if (mounted) {
      Provider.of<WordCountProvider>(
        context,
        listen: false,
      ).setCount(finalWords.length);
    }

    // await loadDataFromDatabase(
    //   context: context,
    //   onLoaded: (loadedWords) {
    //     setState(() {
    //       allWords = loadedWords;
    //       words = loadedWords;
    //     });
    //
    //     /// 🔥 Provider ile kelime sayısını güncelle
    //     Provider.of<WordCountProvider>(
    //       context,
    //       listen: false,
    //     ).setCount(loadedWords.length);
    //   },
    //
    //   /// 🔄 Yükleme ekranı değiştikçe tetiklenir
    //   onLoadingStatusChange: (
    //     bool loading,
    //     double prog,
    //     String? currentWord,
    //     Duration elapsed,
    //   ) {
    //     setState(() {
    //       isLoadingJson = loading;
    //       progress = prog;
    //       loadingWord = currentWord;
    //       elapsedTime = elapsed;
    //     });
    //   },
    // );
  }

  /// 🔄  Kelimeleri veritabanından yeniden oku
  Future<void> _loadWords() async {
    allWords = await WordDatabase.instance.getWords();
    final count = await WordDatabase.instance.countWords();

    setState(() => words = allWords);

    /// 🔥 Provider ile sayacı güncelle
    if (mounted) {
      Provider.of<WordCountProvider>(context, listen: false).setCount(count);
    }

    log('📦 Toplam kayıt sayısı: $count');
  }

  /// 🔍  Arama filtreleme
  void _filterWords(String query) {
    final filtered =
        allWords.where((word) {
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

  // 🖼️  UI
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            /// 📌 AppBar burada oluşturuluyor
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(76),
              child: CustomAppBar(
                isSearching: isSearching,
                searchController: searchController,
                onSearchChanged: _filterWords,
                onClearSearch: _clearSearch,
                onStartSearch: () => setState(() => isSearching = true),
                itemCount: words.length,
              ),
            ),

            /// 📌 Drawer menü burada oluşturuluyor
            drawer: CustomDrawer(
              onDatabaseUpdated: _loadWords,
              appVersion: appVersion,
              isFihristMode: isFihristMode,
              onToggleViewMode: () {
                setState(() => isFihristMode = !isFihristMode);
              },
              //  ⬇️  Yeni imzalı geri-çağrı
              onLoadJsonData: ({
                required BuildContext ctx, // Drawer ’dan gelir, kullanmıyoruz
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

                  //  ⬇️  Drawer ’a da aynı geri-bildirimi ilet
                  onLoadingStatusChange: (
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
                    onStatus(loading, prog, currentWord, elapsed); // ↩︎ ilet
                  },
                );
              },
            ),

            /// 📌 body burada oluşturuluyor
            body:
                isFihristMode
                    ? AlphabetWordList(words: words, onUpdated: _loadWords)
                    : WordList(words: words, onUpdated: _loadWords),

            /// 📌 FAB burada
            floatingActionButton: CustomFAB(
              refreshWords: _loadWords,
              clearSearch: _clearSearch,
            ),
          ),
        ),

        /// 🔄 JSON 'dan veri yükleniyor ekranı
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
