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
// - Fihrist modunda (alfabetik) TÜM veriyi tek seferde çekeriz → tüm harfler dolar.
// - Klasik listede pagination devam eder.
// - Başlangıçta mod’a göre yükleme: initState() artık _loadWords() çağırıyor.
// - LocalCacheService import’u köprü dosyadan (conditional export).

// 📌 Dart paketleri
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// 📌 Flutter paketleri
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../models/word_model.dart';
import '../providers/word_count_provider.dart';
import '../services/local_cache_service.dart'; // ⬅️ köprü import (web/io)
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
  List<Word> allWords = []; // ana liste (pagination veya fihrist full)

  /// 🔎  Arama & görünüm durumları
  bool isSearching = false;
  bool isFihristMode = true; // <-- fihrist varsayılan
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

  /// 📄 Sonsuz kaydırma (Klasik liste için)
  bool _isPaging = false;
  bool _hasMore = true;
  QueryDocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  final int _pageSize = 100; // sayfa boyutu (performansa göre ayarlayabilirsin)

  /// 🔢 Firestore toplam sayım (AppBar için; arama kapalı iken bunu gösteririz)
  int? _totalCount;

  @override
  void initState() {
    super.initState();
    // ✅ Başlangıçta mod’a göre uygun yüklemeyi yap
    Future.microtask(() async {
      await _loadWords();
      await _refreshTotalCount();
    });
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
    if (!mounted) return;
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
      _totalCount = total;
      Provider.of<WordCountProvider>(
        context,
        listen: false,
      ).setCount(total ?? words.length); // Fallback: eldeki görünüm
    } catch (_) {
      // sessiz geç
    }
  }

  // ---------------------------------------------------------------------------
  // 📄 PAGINATION (KLASİK LİSTE)
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
      debugPrint(
        '[_loadFirstPage] items=${page.items.length} hasMore=${page.hasMore}',
      );

      if (page.items.isEmpty) {
        // Emniyet kemeri: akışı deneyelim ki ekranda mutlaka veri olsun
        WordService.instance
            .streamAll(limit: _pageSize, orderByField: 'sirpca')
            .first
            .then((items) {
              if (!mounted) return;
              setState(() {
                allWords = items;
                words = items;
                _lastDoc = null;
                _hasMore = items.length == _pageSize;
              });
            });
      }

      if (!mounted) return;
      setState(() {
        allWords = page.items;
        // Arama kapalıysa doğrudan ilk paketi göster.
        words = page.items;

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
    if (_isPaging ||
        !_hasMore ||
        _usingSearchStream ||
        isSearching ||
        isFihristMode)
      return;

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

      if (!isSearching) await _refreshTotalCount();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isPaging = false);
    }
  }

  /// Scroll olaylarını dinle: sona yaklaşınca yeni sayfa iste (klasik listede)
  bool _onScrollNotification(ScrollNotification sn) {
    // Arama aktifken veya fihrist modunda pagination çalışmasın
    if (isSearching || _usingSearchStream || isFihristMode) return false;

    // Liste dibine ~300px kala yeni sayfa çek
    if (!_isPaging && _hasMore && sn.metrics.extentAfter < 300) {
      _loadNextPage();
    }
    return false; // diğer dinleyicilere de geçsin
  }

  // ---------------------------------------------------------------------------
  // 🔤 FİHRİST: TÜM VERİYİ TEK SEFERDE ÇEK
  // ---------------------------------------------------------------------------

  /// Fihrist görünümü için TÜM kelimeleri Sırpça sıralı çek.
  /// ÖNCE yerel cache’i dene; yoksa Firestore’dan indir ve cache’e yaz.
  Future<void> _loadAllForFihrist() async {
    _sub?.cancel();
    _usingSearchStream = false;

    setState(() {
      isUpdating = true;
      words = [];
      allWords = [];
      _isPaging = false; // fihristte pagination yok
      _hasMore = false;
      _lastDoc = null;
    });

    try {
      // 1) Cache varsa anında göster
      final cached = await LocalCacheService.readAll();
      if (cached.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          allWords = cached;
          words = cached;
          isUpdating = false;
        });
        await _refreshTotalCount();
        return;
      }

      // 2) Cache yoksa Firestore’dan çek
      final snap = await FirebaseFirestore.instance
          .collection('kelimeler')
          .orderBy('sirpca')
          .get();

      final items = snap.docs
          .map((d) => Word.fromMap(d.data(), id: d.id))
          .toList();

      // 3) Cache’e yaz
      await LocalCacheService.writeAll(items);

      if (!mounted) return;
      setState(() {
        allWords = items;
        words = items;
        isUpdating = false;
      });

      await _refreshTotalCount();
    } catch (_) {
      if (!mounted) return;
      setState(() => isUpdating = false);
    }
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
        .searchSirpcaPrefix(query, limit: 300)
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
        // Arama temizlendi → mevcut moda dön
        setState(() {
          isSearching = false;
          words = allWords;
        });
        if (_usingSearchStream) {
          _sub?.cancel();
          _usingSearchStream = false;
        }
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
    _refreshTotalCount();
  }

  // ---------------------------------------------------------------------------
  // 🔄 Manuel yenile (FAB veya Drawer’dan)
  // ---------------------------------------------------------------------------
  Future<void> _loadWords() async {
    // Mod’a göre uygun yükleme:
    if (isFihristMode) {
      await _loadAllForFihrist();
    } else {
      await _loadFirstPage();
    }
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

            /// 📌 Body Burada (Fihristte scroll dinleyici pasif)
            ///
            body: isFihristMode
                ? (isUpdating
                      ? const SizedBox.shrink()
                      : AlphabetWordList(words: words, onUpdated: _loadWords))
                : NotificationListener<ScrollNotification>(
                    onNotification: _onScrollNotification,
                    child: WordList(words: words, onUpdated: _loadWords),
                  ),

            /// 📌 FAB Burada
            ///
            floatingActionButton: CustomFAB(
              refreshWords: _loadWords, // mod’a göre uygun yenile
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

        /// 📌 Basit bekleme katmanı (ilk yükleme / arama stream geçişi / manuel yenileme)
        ///
        if (isUpdating) const BottomWaitingOverlay(),

        /// 📌 Klasik listede sayfa sonuna ek yükleme göstergesi
        if (_isPaging && !_usingSearchStream && !isSearching && !isFihristMode)
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
        await _loadWords(); // mod’a göre
        await _refreshTotalCount(); // sayaç güncel
      },
      appVersion: appVersion,
      isFihristMode: isFihristMode,
      onToggleViewMode: () async {
        // Mod değişince uygun yüklemeyi yap
        setState(() {
          isFihristMode = !isFihristMode;
          // Mod değişince aramayı da temizlemek UX’i iyileştirir
          isSearching = false;
          searchController.clear();
        });
        await _loadWords();
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
                if (!mounted) return;
                // JSON sonrası: Mod’a göre doğru yükleme
                await _loadWords();
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
