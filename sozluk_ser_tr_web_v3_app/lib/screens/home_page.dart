// <📜 ----- lib/screens/home_page.dart ----->
/*
  🖥️ Ana Ekran (HomePage) — AppBar + Drawer + Canlı Arama Listelemesi

  - “Arama modunu aç/kapat” davranışı CustomAppBar.onStartSearch / onClearSearch
    callback’leri ile HomePage içinden yönetilir (isSearching state).
  - Açılışta WordService.fetchAllWords() ile tüm kelimeler belleğe alınır.
  - Arama kutusuna yazdıkça Sırpça ve Türkçe alanlarında “içeren” eşleşmeye göre yerelde filtrelenir.
  - Yükleme süresinde altta bir bilgilendirme bandı (sayaçla) gösterilir.
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/info_constants.dart';
import '../models/word_model.dart';
import '../services/word_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_body.dart'; // ⬅️ Gövde ayrı dosyada
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';
import '../widgets/loading_bottom_banner.dart'; // ⬅️ Alt bilgilendirme bandı

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ℹ️ Versiyon
  String appVersion = '';

  // 🔎 Arama state ’i
  bool isSearching = false; // ilk başta kapalı
  final TextEditingController searchController = TextEditingController();

  // 📚 Bellekteki veri ve filtrelenmiş görünüm
  List<Word> _allWords = [];
  List<Word> _filteredWords = [];

  // ⏳ Yükleme / hata
  bool _loading = true;
  String? _error;

  // ⏱️ ALT BANT sayaç
  final ValueNotifier<int> _elapsedSec = ValueNotifier<int>(0);
  Timer? _loadTimer;

  @override
  void initState() {
    super.initState();
    _runInitialRead(); // kısa özet+log
    _getAppVersion(); // versiyon
    _loadAllWords(); // asıl veriyi çek
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    _elapsedSec.dispose();
    searchController.dispose();
    super.dispose();
  }

  // ⏱️ Sayaç başlat/durdur
  void _startLoadingBanner() {
    _loadTimer?.cancel();
    _elapsedSec.value = 0; // reset
    _loadTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSec.value = _elapsedSec.value + 1;
    });
  }

  void _stopLoadingBanner() {
    _loadTimer?.cancel();
    _loadTimer = null;
  }

  // 🔁 Drawer ’dan çağrılacak “yeniden oku”
  Future<void> _handleReload() async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      const SnackBar(content: Text('Veriler tekrar okunuyor...')),
    );

    await _loadAllWords();

    if (!mounted) return;
    messenger?.showSnackBar(
      const SnackBar(content: Text('Verilerin okunması tamamlandı.')),
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

  // ☁️ Tüm kelimeleri çek → belleğe al → filtreyi uygula
  Future<void> _loadAllWords() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    _startLoadingBanner(); // ⬅️ sayaç burada başlar

    try {
      final items = await WordService.fetchAllWords(pageSize: 2000);
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
      _stopLoadingBanner(); // ⬅️ işlem bitince mutlaka durdur
    }
  }

  // 🔎 Yerel filtre (Sırpça + Türkçe, içeren)
  void _applyFilter(String query) {
    final q = _fold(query); // dil-dostu lowercase + aksan sadeleştirme

    if (q.isEmpty) {
      setState(() => _filteredWords = _allWords.take(200).toList());
      return;
    }

    // 1) Sırpça ’da geçenler
    final serbianMatches = _allWords
        .where((w) => _fold(w.sirpca).contains(q))
        .toList();

    // 2) Türkçe ’de geçenler (Sırpça ’da eşleşenleri tekrar ekleme)
    final seen = serbianMatches
        .toSet(); // (Word Equatable ise set düzgün çalışır)
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

  /// Küçük yardımcı: harfleri küçült ve bazı aksanlı karakterleri sadeleştir.
  String _fold(String s) {
    var x = s.toLowerCase();

    // Türkçe
    x = x
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('i̇', 'i') // noktalı I normalize
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u');

    // Sırpça (Latin)
    x = x
        .replaceAll('č', 'c')
        .replaceAll('ć', 'c')
        .replaceAll('đ', 'dj') // istersen 'd' yapabilirsin
        .replaceAll('š', 's')
        .replaceAll('ž', 'z');

    return x;
  }

  // 🔁 Aramayı AÇ
  void _handleStartSearch() {
    setState(() => isSearching = true);
  }

  // 🔁 Aramayı KAPAT (metni de temizle)
  void _handleClearSearch() {
    searchController.clear();
    _applyFilter('');
    setState(() => isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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

        /// 📦 Body: liste / progress / hata (artık ayrı widget)
        body: CustomBody(
          loading: _loading,
          error: _error,
          allWords: _allWords,
          filteredWords: _filteredWords,
          onRefetch: _handleReload, // sil/düzenle sonrasında tazeleme
          // maxWidth: 720, // istersen özelleştir
        ),

        /// ➕ FAB: kelime ekle → eklendikten sonra listeyi tazele
        floatingActionButton: CustomFAB(onWordAdded: _handleReload),

        /// ⬇️ ALT BANT: “Lütfen bekleyiniz, veriler okunuyor… (Xs)”
        bottomNavigationBar: LoadingBottomBanner(
          loading: _loading,
          elapsedSec: _elapsedSec,
          message: 'Lütfen bekleyiniz, veriler okunuyor…',
        ),
      ),
    );
  }
}
