// 📜 <----- home_page.dart ----->
//
// Firestore stream tabanlı HomePage
// - Ana liste: WordService.streamAll(limit: 300)
// - Arama: debounce (250ms) + sunucu tarafı prefix stream (searchTurkcePrefix)
// - İlk veri gelene kadar BottomWaitingOverlay gösterimi
// - Drawer üzerinden JSON import akışı korunur

import 'dart:async';

/// 📌 Flutter paketleri
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../models/word_model.dart';
import '../providers/word_count_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../services/word_service.dart';
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

  /// ⏳  Yükleme ekranı durumları (progress kartı)
  bool isLoadingJson = false;
  double progress = 0.0;
  String? loadingWord;
  Duration elapsedTime = Duration.zero;

  /// ⏳  Basit bekleme katmanı (ilk stream paketi / geçişler)
  bool isUpdating = true; // ilk açılışta true

  /// 🔌 Stream aboneliği
  StreamSubscription<List<Word>>? _sub;

  /// ⌛ Arama debounce
  Timer? _searchDebounce;

  /// 🔁 Şu an arama stream ’i mi kullanılıyor?
  bool _usingSearchStream = false;

  @override
  void initState() {
    super.initState();
    _subscribeMainStream(); // 🔴 Firestore ana stream (limit 300)
    _getAppVersion();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _searchDebounce?.cancel();
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

  // ---------------------------------------------------------------------------
  // 🔌 STREAM YÖNETİMİ
  // ---------------------------------------------------------------------------

  /// Ana liste stream ’i (limit 300)
  void _subscribeMainStream() {
    _sub?.cancel();
    _usingSearchStream = false;

    setState(() => isUpdating = true);

    _sub = WordService.instance
        .streamAll(limit: 300)
        .listen(
          (items) {
            if (!mounted) return;

            // Arama kapalıysa doğrudan göster; arama açıksa sonuçlar arama stream 'inden gelir
            setState(() {
              allWords = items;
              if (!isSearching) {
                words = items;
              }
              isUpdating = false; // ilk paket gelince kapat
            });

            // Sayaç (listede gösterilen adet yerine toplam ana stream adedini sayıyoruz)
            Provider.of<WordCountProvider>(
              context,
              listen: false,
            ).setCount(items.length);
          },
          onError: (_) {
            if (!mounted) return;
            setState(() => isUpdating = false);
          },
        );
  }

  /// Sunucu tarafı prefix arama stream ’i
  void _subscribeSearchStream(String query) {
    _sub?.cancel();
    _usingSearchStream = true;

    setState(() => isUpdating = true);

    _sub = WordService.instance
        .searchTurkcePrefix(query, limit: 50)
        .listen(
          (items) {
            if (!mounted) return;
            setState(() {
              words = items;
              isUpdating = false;
            });

            // İstersen sayacı arama sonuç sayısına da set edebilirsin (UI tercihi)
            Provider.of<WordCountProvider>(
              context,
              listen: false,
            ).setCount(items.length);
          },
          onError: (_) {
            if (!mounted) return;
            setState(() => isUpdating = false);
          },
        );
  }

  // ---------------------------------------------------------------------------
  // 🔄 MANUEL YENİLEME (sayaç tazeleme)
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // 🔎 ARAMA
  // ---------------------------------------------------------------------------
  void _filterWords(String query) {
    final q = query.trim();

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;

      if (q.isEmpty) {
        // Arama temiz
        setState(() {
          isSearching = false;
          words = allWords; // eldeki ana listeyi göster
        });
        if (_usingSearchStream) {
          // Arama stream 'inden ana stream 'e dönüş
          _subscribeMainStream();
        }
      } else {
        // Arama açık: sunucu tarafı prefix arama stream 'i
        setState(() => isSearching = true);
        _subscribeSearchStream(q);
      }
    });
  }

  /// ❌  Aramayı temizle (AppBar X)
  void _clearSearch() {
    _searchDebounce?.cancel();
    searchController.clear();
    setState(() {
      isSearching = false;
      words = allWords;
    });
    if (_usingSearchStream) {
      _subscribeMainStream();
    }
  }

  // ---------------------------------------------------------------------------
  // 🧱 UI
  // ---------------------------------------------------------------------------
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

        /// 📌 JSON yükleme kartı (mevcut progress UI)
        ///
        if (isLoadingJson)
          SQLLoadingCard(
            progress: progress,
            loadingWord: loadingWord,
            elapsedTime: elapsedTime,
          ),

        /// 📌 Basit bekleme katmanı (ilk stream paketi / arama stream geçişi / manuel yenileme)
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
            // Firestore boşsa asset/devices JSON ’dan yüklemek için mevcut yardımcıyı kullanalım
            await loadDataFromDatabase(
              context: ctx,
              onLoaded: (loadedWords) {
                // Stream anında devralacak ama yine de UI ’u hemen güncelleyelim
                if (!mounted) return;
                setState(() {
                  allWords = loadedWords;
                  words = isSearching
                      ? words // arama açıksa anlık arama stream 'i gösterilmeye devam
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
