// 📃 <----- home_page.dart ----->
//
// Bu dosya, uygulamanın ana ekranını oluşturur.
// İçeriği:
//  • Klasik ve fihrist görünüm (alfabetik başlıklarla gruplama)
//  • Arama kutusu (AppBar içinde)
//  • Drawer menüsü ile:
//     ◦ Görünüm değiştirme
//     ◦ JSON yedeğinden veri yenileme
//     ◦ Veritabanını sıfırlama
//     ◦ Yedek alma işlemleri
//  • JSON verisi yüklendikten sonra ve yeni veri eklendiğinde
//    malzeme listesi Türkçeye göre sıralanır.
//  • Sayfa üstünde kelime sayacı `Provider` ile güncellenir.

// 📌 Dart hazır paketleri
import 'dart:developer';

/// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../providers/malzeme_count_provider.dart';
import '../utils/json_loader.dart';

/// 📌 AppBar, Drawer, FAB yüklemeleri burada
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';
import 'alphabet_malzeme_list.dart';
import 'malzeme_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🔢  Veri listeleri
  List<Malzeme> words = [];
  List<Malzeme> allWords = [];

  // 🔎  Arama & görünüm durumları
  bool isSearching = false;
  bool isFihristMode = true;
  final TextEditingController searchController = TextEditingController();

  // ℹ️  Uygulama versiyonu
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _getAppVersion();
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  /// 📌 İlk açılışta verileri (gerekirse) yükle
  void _loadInitialData() async {
    final provider = Provider.of<MalzemeCountProvider>(context, listen: false);
    await loadDataFromDatabase(
      context: context,
      provider: provider,
      onLoaded: (loadedWords) {
        _sortList(loadedWords); // 🔠 Türkçeye göre sırala
        setState(() {
          allWords = loadedWords;
          words = loadedWords;
        });
      },
      onLoadingStatusChange: (_, __, ___, ____) {},
    );
  }

  /// 🔄  Kelimeleri veritabanından yeniden oku
  Future<void> _loadWords() async {
    allWords = await DbHelper.instance.getRecords();
    final count = await DbHelper.instance.countRecords();

    _sortList(allWords); // 🔠 Türkçeye göre sırala

    setState(() => words = allWords);

    if (mounted) {
      Provider.of<MalzemeCountProvider>(context, listen: false).setCount(count);
    }

    log('📦 Toplam kayıt sayısı: $count', name: 'Home Page');
  }

  /// 🔍  Arama filtreleme
  void _filterWords(String query) {
    final filtered = allWords.where((word) {
      final q = query.toLowerCase();
      return word.malzeme.toLowerCase().contains(q);
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

  /// 🔠 Türkçeye göre karşılaştırma
  int _compareTurkish(String a, String b) {
    const alphabet =
        'AaBbCcÇçDdEeFfGgĞğHhIıİiJjKkLlMmNnOoÖöPpRrSsŞşTtUuÜüVvYyZz';
    int index(String char) => alphabet.indexOf(char);
    final aChars = a.split('');
    final bChars = b.split('');
    for (int i = 0; i < aChars.length && i < bChars.length; i++) {
      final ai = index(aChars[i]);
      final bi = index(bChars[i]);
      if (ai != bi) return ai.compareTo(bi);
    }
    return aChars.length.compareTo(bChars.length);
  }

  /// 🔁 Listeyi sıralı hale getir
  void _sortList(List<Malzeme> list) {
    list.sort((a, b) => _compareTurkish(a.malzeme, b.malzeme));
  }

  // 🖼️  UI
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: CustomAppBar(
            isSearching: isSearching,
            searchController: searchController,
            onSearchChanged: _filterWords,
            onClearSearch: _clearSearch,
            onStartSearch: () => setState(() => isSearching = true),
            itemCount: words.length,
          ),
        ),
        drawer: CustomDrawer(
          onDatabaseUpdated: _loadWords,
          appVersion: appVersion,
          isFihristMode: isFihristMode,
          onToggleViewMode: () {
            setState(() => isFihristMode = !isFihristMode);
          },
          onLoadJsonData:
              ({
                required BuildContext ctx,
                required void Function(bool, double, String?, Duration)
                onStatus,
              }) async {
                final provider = Provider.of<MalzemeCountProvider>(
                  ctx,
                  listen: false,
                );
                await loadDataFromDatabase(
                  context: ctx,
                  provider: provider,
                  onLoaded: (loadedWords) {
                    _sortList(loadedWords); // 🔠 Türkçeye göre sırala
                    setState(() {
                      allWords = loadedWords;
                      words = loadedWords;
                    });
                  },
                  onLoadingStatusChange:
                      (
                        bool loading,
                        double prog,
                        String? currentWord,
                        Duration elapsed,
                      ) {
                        onStatus(loading, prog, currentWord, elapsed);
                      },
                );
              },
        ),
        body: isFihristMode
            ? AlphabetMalzemeList(malzemeler: words, onUpdated: _loadWords)
            : MalzemeList(malzemeler: words, onUpdated: _loadWords),
        floatingActionButton: CustomFAB(
          refreshWords: _loadWords,
          clearSearch: _clearSearch,
        ),
      ),
    );
  }
}
