// 📜 <----- home_page.dart ----->
//
// Firestore tabanlı HomePage
// - Ana liste: pagination (fetchPage) ile sayfa sayfa çekilir (ilk sayfa + sonsuz kaydırma)
// - Arama: debounce (250ms) + sunucu tarafı prefix stream (searchSirpcaPrefix, limit=300)
// - İlk veri gelene kadar BottomWaitingOverlay gösterimi
// - Drawer üzerinden JSON import akışı korunur
//
// 🔧 Düzeltmeler:
// - AppBar sayacı: arama KAPALI iken Firestore toplam (countTotals) gösterilir,
//   arama AÇIK iken arama sonucunun sayısı (words.length) gösterilir.
// - Arama limitini 300'e çıkardık (sunucu tarafı). Böylece ilk sayfayla sınırlı hissettirmez.

// 📌 Dart paketleri
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// 📌 Flutter paketleri
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../models/word_model.dart';
import '../providers/word_count_provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../services/word_service.dart'; // fetchPage + search stream (sirpca)
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
  List<Word> words = []; // ekranda görünen liste
  List<Word> allWords = []; // ana liste (pagination ile büyür)

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

  /// ⏳  Basit bekleme katmanı (ilk sayfa / geçişler / arama stream başlangıcı)
  bool isUpdating = true; // ilk açılışta true

  /// 🔌 Arama stream aboneliği + debounce
  StreamSubscription<List<Word>>? _sub;
  Timer? _searchDebounce;
  bool _usingSearchStream = false;

  /// 📄 Sonsuz kaydırma (ana liste için)
  bool _isPaging = false;
  bool _hasMore = true;
  QueryDocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  final int _pageSize = 100; // sayfa boyutu (performansa göre ayarlayabilirsin)

  /// 🔢 Firestore toplam sayım (AppBar için; arama kapalı iken bunu gösteririz)
  int? _totalCount;

  @override
  void initState() {
    super.initState();
    _loadFirstPage(); // 🔴 İlk sayfa
    _refreshTotalCount(); // 🔴 Toplam sayım
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

  /// 📌 Firestore toplam sayıyı çek → AppBar sayacı güncellensin
  Future<void> _refreshTotalCount() async {
    try {
      final total = await WordService.instance
          .countTotals(); // aggregate/fallback
      if (!mounted) return;
      setState(() => _totalCount = total);
      Provider.of<WordCountProvider>(
        context,
        listen: false,
      ).setCount(total); // AppBar sayacı
    } catch (_) {
      // sessiz geç
    }
  }

  // ---------------------------------------------------------------------------
  // 📄 PAGINATION (ANA LİSTE)
  // ---------------------------------------------------------------------------

  /// İlk sayfayı yükle ve state’i sıfırla
  Future<void> _loadFirstPage() async {
    setState(() {
      isUpdating = true;
      _isPaging = true;
      _hasMore = true;
      _lastDoc = null;
      words = [];
      allWords = [];
    });

    try {
      final page = await WordService.instance.fetchPage(
        limit: _pageSize,
        orderByField: 'sirpca', // 🔎 Sırpça’ya göre sıralı sayfalama
        startAfter: null,
      );

      if (!mounted) return;
      setState(() {
        allWords = page.items;
        words = isSearching ? words : page.items; // arama kapalıysa göster
        _lastDoc = page.lastDoc;
        _hasMore = page.hasMore;
        _isPaging = false;
        isUpdating = false;
      });

      // AppBar sayacı: arama kapalı iken toplam sayıyı göster
      if (!isSearching) {
        await _refreshTotalCount();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isPaging = false;
        isUpdating = false;
      });
    }
  }

  /// Sonraki sayfayı yükle (sayfa sonuna yaklaşıldığında çağrılır)
  Future<void> _loadNextPage() async {
    if (_isPaging || !_hasMore || _usingSearchStream || isSearching) return;

    setState(() => _isPaging = true);

    try {
      final page = await WordService.instance.fetchPage(
        limit: _pageSize,
        orderByField: 'sirpca', // 🔎 Sırpça
        startAfter: _lastDoc,
      );

      if (!mounted) return;
      setState(() {
        allWords = [...allWords, ...page.items];
        if (!isSearching) {
          words = allWords;
        }
        _lastDoc = page.lastDoc;
        _hasMore = page.hasMore;
        _isPaging = false;
      });

      // AppBar sayacı: arama kapalı iken toplam sayıyı göster
      if (!isSearching) {
        await _refreshTotalCount();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isPaging = false);
    }
  }

  /// Scroll olaylarını dinle: sona yaklaşınca yeni sayfa iste
  bool _onScrollNotification(ScrollNotification sn) {
    // Arama aktifken pagination çalışmasın
    if (isSearching || _usingSearchStream) return false;

    // Liste dibine 300px kala yeni sayfa çek
    if (sn.metrics.extentAfter < 300) {
      _loadNextPage();
    }
    return false; // diğer dinleyicilere de geçsin
  }

  // ---------------------------------------------------------------------------
  // 🔎 ARAMA (DEBOUNCE + SUNUCU TARAFI STREAM / SIRPÇA)
  // ---------------------------------------------------------------------------

  /// Sunucu tarafı prefix arama stream’i (Sırpça / sirpca)
  void _subscribeSearchStream(String query) {
    _sub?.cancel();
    _usingSearchStream = true;

    setState(() => isUpdating = true);

    _sub = WordService.instance
        .searchSirpcaPrefix(query, limit: 300) // ⬅️ limit 300
        .listen(
          (items) {
            if (!mounted) return;
            setState(() {
              words = items;
              isUpdating = false;
            });
            // Arama AÇIK: AppBar sayacı arama sonuç sayısı olsun
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

  /// Arama input’u değiştikçe çağrılır (CustomAppBar → onSearchChanged)
  void _filterWords(String query) {
    final q = query.trim();

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;

      if (q.isEmpty) {
        // Arama temizlendi → ana listeye dön (eldeki sayfalı veriyi göster)
        setState(() {
          isSearching = false;
          words = allWords;
        });
        if (_usingSearchStream) {
          _sub?.cancel();
          _usingSearchStream = false;
        }
        // Arama KAPALI: AppBar sayacı toplamı göstersin
        _refreshTotalCount();
      } else {
        // Arama açık: sunucu tarafı prefix arama stream'i (Sırpça)
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
      _sub?.cancel();
      _usingSearchStream = false;
    }
    // Arama KAPALI: AppBar sayacı toplamı göstersin
    _refreshTotalCount();
  }

  // ---------------------------------------------------------------------------
  // 🔄 Manuel yenile (FAB veya Drawer’dan)
  // ---------------------------------------------------------------------------
  Future<void> _loadWords() async {
    // Tam tazele: baştan ilk sayfayı çek + toplamı güncelle
    await _loadFirstPage();
    await _refreshTotalCount();
  }

  // ---------------------------------------------------------------------------
  // 🧱 UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // AppBar’da gösterilecek sayaç:
    // - Arama AÇIK → söz konusu sonuç sayısı
    // - Arama KAPALI → Firestore toplam (yoksa eldeki liste sayısı fallback)
    final appBarCount = isSearching
        ? words.length
        : (_totalCount ?? allWords.length);

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
                itemCount: appBarCount, // ⬅️ düzeltildi
              ),
            ),

            /// 📌 Custom Drawer burada
            ///
            drawer: buildCustomDrawer(context),

            /// 📌 Body Burada (Scroll dinleyici ile sarıldı)
            ///
            body: NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: isFihristMode
                  ? AlphabetWordList(words: words, onUpdated: _loadWords)
                  : WordList(words: words, onUpdated: _loadWords),
            ),

            /// 📌 FAB Burada
            ///
            floatingActionButton: CustomFAB(
              refreshWords: _loadFirstPage, // tam yenile
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

        /// 📌 Basit bekleme katmanı (ilk sayfa / arama stream geçişi / manuel yenileme)
        ///
        if (isUpdating) const BottomWaitingOverlay(),

        /// 📌 Sayfa sonuna ek yükleme yaparken küçük bir gösterge (arama kapalıyken)
        if (_isPaging && !_usingSearchStream && !isSearching)
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  /// 📌 Custom Drawer burada
  ///
  CustomDrawer buildCustomDrawer(BuildContext context) {
    return CustomDrawer(
      onDatabaseUpdated: () async {
        await _loadFirstPage();
        await _refreshTotalCount(); // Drawer’daki “Yenile” sonrası sayaç güncellensin
      },
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
              onLoaded: (loadedWords) async {
                // 🔁 Firestore dolduruldu → ana listeyi baştan kur
                if (!mounted) return;

                // (İstersen geçici client-side Sırpça filtre yapabilirsin; gerek yoksa atla)
                setState(() {
                  allWords = loadedWords;
                  words = isSearching ? words : loadedWords;
                });

                await _loadFirstPage();
                await _refreshTotalCount();
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
