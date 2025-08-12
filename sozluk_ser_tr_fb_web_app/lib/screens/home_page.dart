// 📜 <----- home_page.dart ----->
//
// Firestore stream tabanlı HomePage
// - WordService.streamAll() ile canlı dinleme
// - İlk veri gelene kadar BottomWaitingOverlay gösterimi
// - Arama/fihrist görünümü, Drawer üzerinden JSON import akışı korunur

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../models/word_model.dart';
import '../providers/word_count_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../services/word_service.dart'; // 🔴 stream buradan
import '../utils/json_loader.dart'; // Drawer’dan import için
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

  /// ⏳  Basit bekleme katmanı (ilk stream paketi için)
  bool isUpdating = true; // ilk açılışta true

  /// 🔌 Stream aboneliği
  StreamSubscription<List<Word>>? _sub;

  @override
  void initState() {
    super.initState();
    _startWordsStream(); // 🔴 Firestore stream
    _getAppVersion();
  }

  @override
  void dispose() {
    _sub?.cancel();
    searchController.dispose();
    super.dispose();
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = 'Versiyon: ${info.version}';
    });
  }

  /// 📌 Firestore stream’i başlat
  void _startWordsStream() {
    setState(() => isUpdating = true);

    // İstersen limit'i 500/1000 yapabilirsin; web’de çok büyük veride performans için iyi olur.
    _sub = WordService.instance
        .streamAll(limit: 1000)
        .listen(
          (items) {
            // Arama açık ise filtre uygulayarak güncelle
            final currentQuery = searchController.text.trim();
            List<Word> view = items;
            if (isSearching && currentQuery.isNotEmpty) {
              final q = currentQuery.toLowerCase();
              view = items
                  .where(
                    (w) =>
                        w.sirpca.toLowerCase().contains(q) ||
                        w.turkce.toLowerCase().contains(q),
                  )
                  .toList();
            }

            if (!mounted) return;
            setState(() {
              allWords = items;
              words = view;
              isUpdating = false; // ilk paket gelince kapat
            });

            // Sayaç güncelle
            if (mounted) {
              Provider.of<WordCountProvider>(
                context,
                listen: false,
              ).setCount(items.length);
            }
          },
          onError: (_) {
            if (!mounted) return;
            setState(() => isUpdating = false);
          },
        );
  }

  /// 🔄  Manuel yenile: sayaç tazele (stream zaten anlık getiriyor)
  Future<void> _loadWords() async {
    setState(() => isUpdating = true);
    try {
      final count = await WordService.instance.count();
      if (!mounted) return;
      Provider.of<WordCountProvider>(context, listen: false).setCount(count);
    } finally {
      if (mounted) setState(() => isUpdating = false);
    }
  }

  /// 🔍  Arama filtreleme
  void _filterWords(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      isSearching = q.isNotEmpty;
      words = isSearching
          ? allWords
                .where(
                  (w) =>
                      w.sirpca.toLowerCase().contains(q) ||
                      w.turkce.toLowerCase().contains(q),
                )
                .toList()
          : allWords;
    });
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
              refreshWords:
                  _loadWords, // stream var ama sayaç için kullanıyoruz
              clearSearch: _clearSearch,
            ),
          ),
        ),

        /// 📌 SQL JSON yükleme kartı (mevcut progress UI)
        ///
        if (isLoadingJson)
          SQLLoadingCard(
            progress: progress,
            loadingWord: loadingWord,
            elapsedTime: elapsedTime,
          ),

        /// 📌 Basit bekleme katmanı (ilk stream paketi / manuel yenileme)
        ///
        if (isUpdating) const BottomWaitingOverlay(),
      ],
    );
  }

  /// 📌 Custom Drawer burada
  ///
  CustomDrawer buildCustomDrawer(BuildContext context) {
    return CustomDrawer(
      onDatabaseUpdated: _loadWords, // yenile butonu sonrası sayacı tazele
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
            // Firestore boşsa asset/devices JSON’dan yüklemek için mevcut yardımcıyı kullanalım
            await loadDataFromDatabase(
              context: ctx,
              onLoaded: (loadedWords) {
                // Stream anında devralacak ama yine de UI’u hemen güncelleyelim
                if (!mounted) return;
                setState(() {
                  allWords = loadedWords;
                  words = isSearching
                      ? loadedWords.where((w) {
                          final q = searchController.text.toLowerCase();
                          return w.sirpca.toLowerCase().contains(q) ||
                              w.turkce.toLowerCase().contains(q);
                        }).toList()
                      : loadedWords;
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
                    if (!mounted) return;
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
