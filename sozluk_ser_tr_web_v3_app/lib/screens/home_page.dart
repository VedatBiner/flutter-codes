// <📜 ----- lib/screens/home_page.dart ----->
/*
  🖥️ Ana Ekran (HomePage) — AppBar + Drawer + Canlı Arama Listelemesi

  - “Arama modunu aç/kapat” davranışı CustomAppBar.onStartSearch / onClearSearch
    callback’leri ile HomePage içinden yönetilir (isSearching state).
  - Açılışta WordService.fetchAllWords() ile tüm kelimeler belleğe alınır.
  - Arama kutusuna yazdıkça Sırpça ve Türkçe alanlarında “içeren” eşleşmeye göre
    yerelde filtrelenir.
  - Alt bant (LoadingBottomBanner) yükleme sırasında gösterilir ve saniye sayar.
*/

// 📌 Dart paketleri burada
import 'dart:async';

/// 📌 Flutter paketleri burada
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/info_constants.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_body.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';
import '../widgets/loading_bottom_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ℹ️ Versiyon
  String appVersion = '';

  // 🔎 Arama state ’i
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  // 📚 Bellekteki veri ve filtrelenmiş görünüm
  List<Word> _allWords = [];
  List<Word> _filteredWords = [];

  // ⏳ Yükleme / hata
  bool _loading = true;
  String? _error;

  // ⏱️ Alt bant: sayaç ve mesaj
  final ValueNotifier<int> _elapsedSec = ValueNotifier<int>(0);
  Timer? _loadTimer;
  String _loadingMessage = 'Lütfen bekleyiniz, \nveriler okunuyor…';

  @override
  void initState() {
    super.initState();
    _runInitialRead(); // kısa özet + log
    _getAppVersion(); // versiyon
    _loadAllWords(bannerMessage: _loadingMessage); // asıl veriyi çek
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    _elapsedSec.dispose();
    searchController.dispose();
    super.dispose();
  }

  // ⏱️ Banner sayaç kontrolü
  void _startLoadingBanner() {
    _loadTimer?.cancel();
    _elapsedSec.value = 0;
    _loadTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSec.value = _elapsedSec.value + 1;
    });
  }

  void _stopLoadingBanner() {
    _loadTimer?.cancel();
    _loadTimer = null;
  }

  // 🔁 Drawer ’dan “verileri tekrar oku”
  Future<void> _handleReload() async {
    await _loadAllWords(
      bannerMessage: 'Lütfen bekleyiniz, \nveriler tekrar okunuyor...',
    );
  }

  // 🧭 Versiyon
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  // 🧪 Kısa özet/log
  Future<void> _runInitialRead() async {
    await WordService.readWordsOnce();
    if (!mounted) return;
  }

  // ☁️ Tüm kelimeleri çek → belleğe al → filtreyi uygula (+ banner kontrolü)
  Future<void> _loadAllWords({required String bannerMessage}) async {
    setState(() {
      _loading = true;
      _error = null;
      _loadingMessage = bannerMessage;
    });
    _startLoadingBanner();

    try {
      final items = await WordService.fetchAllWords(pageSize: 500); // 2000
      if (!mounted) return;

      setState(() {
        _allWords = items;
        _applyFilter(searchController.text);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    } finally {
      _stopLoadingBanner();
    }
  }

  // 🔎 Yerel filtre (Sırpça + Türkçe, içeren)
  void _applyFilter(String query) {
    final q = _fold(query);
    if (q.isEmpty) {
      setState(() => _filteredWords = _allWords.take(200).toList());
      return;
    }

    final serbianMatches = _allWords
        .where((w) => _fold(w.sirpca).contains(q))
        .toList();
    final seen = serbianMatches.toSet(); // (Word Equatable ise set çalışır)
    final turkishMatches = _allWords
        .where((w) => !seen.contains(w) && _fold(w.turkce).contains(q))
        .toList();

    setState(() {
      _filteredWords = [
        ...serbianMatches,
        ...turkishMatches,
      ].take(200).toList();
    });
  }

  /// Küçük yardımcı: lower + aksan sadeleştirme
  String _fold(String s) {
    var x = s.toLowerCase();

    // Türkçe
    x = x
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('i̇', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u');

    // Sırpça (Latin)
    x = x
        .replaceAll('č', 'c')
        .replaceAll('ć', 'c')
        .replaceAll('đ', 'dj')
        .replaceAll('š', 's')
        .replaceAll('ž', 'z');

    return x;
  }

  // 🔁 Aramayı AÇ/KAPAT
  void _handleStartSearch() => setState(() => isSearching = true);

  void _handleClearSearch() {
    searchController.clear();
    _applyFilter('');
    setState(() => isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 📜 AppBar
      appBar: CustomAppBar(
        appBarName: appBarName,
        isSearching: isSearching,
        searchController: searchController,
        onSearchChanged: _applyFilter,
        onStartSearch: _handleStartSearch,
        onClearSearch: _handleClearSearch,
        onTapHome: () {
          // Home ’a dön: tüm stack ’i temizle
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),

      /// 📁 Drawer
      drawer: CustomDrawer(appVersion: appVersion, onReload: _handleReload),

      /// 📦 Body: liste / progress / hata
      body: SafeArea(
        top: false,
        child: CustomBody(
          loading: _loading,
          error: _error,
          allWords: _allWords,
          filteredWords: _filteredWords,
          onRefetch: _handleReload,
        ),
      ),

      /// ➕ FAB: kelime ekle → eklendikten sonra listeyi tazele
      floatingActionButton: CustomFAB(onWordAdded: _handleReload),

      /// ⬇️ ALT BANT: “Lütfen bekleyiniz … (Xs)”
      bottomNavigationBar: LoadingBottomBanner(
        loading: _loading,
        elapsedSec: _elapsedSec,
        message: _loadingMessage,
      ),
    );
  }
}
