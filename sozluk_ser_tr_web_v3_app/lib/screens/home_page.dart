// <📜 ----- home_page.dart ----->
/*
  🖥️ Ana Ekran (HomePage) — AppBar + Drawer + Canlı Arama Listelemesi

  BU EKRAN NE YAPAR?
  - Açılışta Firestore’dan kelimeleri sayfalı şekilde okuyup belleğe alır
    (WordService.fetchAllWords). Ayrıca readWordsOnce() ile kısa özet loglar.
  - AppBar’daki arama kutusuna yazdıkça, Sırpça alanında **içeren** (substring)
    eşleşmeye göre yerel filtre uygular ve sonuçları aşağıdaki listede gösterir.
  - Drawer’daki “Verileri tekrar oku” öğesi veya FAB ile kelime eklendikten sonra
    bellekteki listeyi baştan yükler.

  KULLANILAN SERVİSLER / HELPER’LAR
  - WordService.readWordsOnce()   : Firestore’dan kısa özet/log
  - WordService.fetchAllWords()   : Tüm kelimeleri sayfalı okuyup döndürür
  - WordService (CRUD)            : (Ekle/sil/güncelle için)
  - CustomAppBar                  : Arama kutusu & “Ana Sayfa” ikonu
  - CustomDrawer(onReload)        : Drawer’dan “Yeniden Oku”
  - CustomFAB(onWordAdded)        : Kelime ekleme diyaloğu sonrası listeyi tazele

  NOTLAR
  - “İçeren” arama Firestore tarafında yerel olarak yapılır (contains).
  - fetchAllWords ‘ta `orderBy('sirpca') + orderBy(docId)` composite index isteyebilir (bir kez oluşturun).
  - Büyük koleksiyonlarda liste render’ı için görünür sonuç sayısı başlangıçta 200 ile sınırlandı (take(200)).

  HATA YÖNETİMİ
  - Yükleme sırasında progress, hata olursa kısa mesaj gösterilir.
  - Ayrıntılı loglar console’a düşer.
*/

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/info_constants.dart';
import '../models/word_model.dart';
import '../services/word_service.dart';
import '../widgets/custom_app_bar.dart';
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

  // 🔎 Arama durumu (CustomAppBar parametreleri)
  // İstersen isSearching ’i true/false yönetebilirsin. Şimdilik her zaman açık kalsın.
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  // 📚 Bellekteki veri ve filtrelenmiş görünüm
  List<Word> _allWords = [];
  List<Word> _filteredWords = [];

  // ⏳ Yükleme / hata durumu
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

  /// 🔁 Drawer ’dan çağrılacak “yeniden oku” eylemi
  Future<void> _handleReload() async {
    final messenger = ScaffoldMessenger.maybeOf(
      context,
    ); // await öncesi güvenli
    messenger?.showSnackBar(
      const SnackBar(content: Text('Koleksiyon okunuyor...')),
    );

    await _loadAllWords(); // listeyi baştan oku & filtreyi uygula
    if (!mounted) return;
    messenger?.showSnackBar(const SnackBar(content: Text('Okuma tamam.')));
  }

  /// 🧭 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  /// 🧪 Kısa özet/log (isteğe bağlı)
  Future<void> _runInitialRead() async {
    await WordService.readWordsOnce();
    if (!mounted) return;
  }

  /// ☁️ Tüm kelimeleri sayfalı olarak çek → belleğe al → ilk görünümü hazırla
  Future<void> _loadAllWords() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await WordService.fetchAllWords(pageSize: 2000);
      if (!mounted) return;

      // İlk görünüm: başta ilk 200 kaydı göster
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

  /// 🔎 Arama kutusu değiştikçe yerelde filtre uygula (içeren)
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // 📜 AppBar
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: CustomAppBar(
            appBarName: appBarName,
            isSearching: isSearching,
            searchController: searchController,
            onSearchChanged: _applyFilter,
            onTapHome: () {
              // Home ’a dön: tüm stack ’i temizle
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),

        /// 📁 Drawer
        drawer: CustomDrawer(appVersion: appVersion, onReload: _handleReload),

        /// 📌 Body: liste / progress / hata
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text('Hata: $_error'))
                  : _filteredWords.isEmpty
                  ? const Center(child: Text('Sonuç bulunamadı.'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sonuç: ${_filteredWords.length} / ${_allWords.length}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _filteredWords.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, i) {
                              final w = _filteredWords[i];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  w.sirpca,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(w.turkce),
                                trailing: Text(
                                  w.userEmail,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),

        /// ➕ FAB: kelime ekle → eklendikten sonra listeleri tazele
        floatingActionButton: CustomFAB(onWordAdded: _handleReload),
      ),
    );
  }
}
