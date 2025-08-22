// <📜 ----- lib/screens/home_page.dart ----->
/*
  🖥️ Ana Ekran (HomePage) — AppBar + Drawer + Canlı Arama Listelemesi

  - “Arama modunu aç/kapat” davranışı CustomAppBar.onStartSearch / onClearSearch
    callback’leri ile HomePage içinden yönetilir (isSearching state).
  - Açılışta WordService.fetchAllWords() ile tüm kelimeler belleğe alınır.
  - Arama kutusuna yazdıkça Sırpça alanında “içeren” eşleşmeye göre yerelde filtrelenir.
*/

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/info_constants.dart';
import '../models/word_model.dart';
import '../services/word_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_body.dart'; // ⬅️ YENİ: gövde ayrı dosyada
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ℹ️ Versiyon
  String appVersion = '';

  // 🔎 Arama state’i
  bool isSearching = false; // ilk başta kapalı
  final TextEditingController searchController = TextEditingController();

  // 📚 Bellekteki veri ve filtrelenmiş görünüm
  List<Word> _allWords = [];
  List<Word> _filteredWords = [];

  // ⏳ Yükleme / hata
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _runInitialRead(); // kısa özet+log
    _getAppVersion(); // versiyon
    _loadAllWords(); // asıl veriyi çek
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // 🔁 Drawer ’dan çağrılacak “yeniden oku”
  Future<void> _handleReload() async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      const SnackBar(content: Text('Koleksiyon okunuyor...')),
    );

    await _loadAllWords();
    if (!mounted) return;
    messenger?.showSnackBar(const SnackBar(content: Text('Okuma tamam.')));
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
    }
  }

  // 🔎 Yerel filtre (içeren)
  void _applyFilter(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      _filteredWords = _allWords.take(200).toList();
    } else {
      _filteredWords = _allWords
          .where((w) => w.sirpca.toLowerCase().contains(q))
          .take(200)
          .toList();
    }
    setState(() {}); // görünümü güncelle
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
          isLoading: _loading,
          error: _error,
          filtered: _filteredWords,
          totalCount: _allWords.length,
          // maxWidth: 720, // istersen özelleştir
        ),

        /// ➕ FAB: kelime ekle → eklendikten sonra listeyi tazele
        floatingActionButton: CustomFAB(onWordAdded: _handleReload),
      ),
    );
  }
}
