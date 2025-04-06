// 📃 <----- home_page.dart ----->

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';
import 'package:kelimelik_words_app/widgets/alphabet_word_list.dart';
import 'package:kelimelik_words_app/widgets/word_list.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'db/word_database.dart';
import 'models/word_model.dart';
import 'widgets/add_word_dialog_handler.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Word> words = [];
  List<Word> allWords = [];

  bool isSearching = false;
  bool isFihristMode = true;
  final TextEditingController searchController = TextEditingController();
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    loadDataFromDatabase(); // 👈 JSON'dan yükleme yapılabilir
    _getAppVersion();
  }

  /// Uygulamanın versiyonunu alır.
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = 'Versiyon: ${info.version}';
    });
  }

  /// Veritabanından kelimeleri yükler.
  Future<void> _loadWords() async {
    allWords = await WordDatabase.instance.getWords();
    final count = await WordDatabase.instance.countWords();

    setState(() {
      words = allWords;
    });

    log('📦 Toplam kayıt sayısı: $count');
  }

  /// Eğer veritabanı boşsa cihazdaki JSON dosyasından yükleme yapar.
  Future<void> loadDataFromDatabase() async {
    log("🔄 Veritabanından veri okunuyor...");

    final count = await WordDatabase.instance.countWords();
    log("🧮 Veritabanındaki kelime sayısı: $count");

    if (count == 0) {
      log("📭 Veritabanı boş. Cihazdaki JSON yedeğinden veri yükleniyor...");

      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/kelimelik_backup.json';
        final file = File(filePath);

        if (await file.exists()) {
          final jsonStr = await file.readAsString();
          final List<dynamic> jsonList = json.decode(jsonStr);

          final words = jsonList.map((e) => Word.fromJson(e)).toList();

          for (var word in words) {
            await WordDatabase.instance.insertWord(word);
            log("✅ Yüklenen kelime: ${word.word} - ${word.meaning}");
          }

          log("✅ ${words.length} kelime JSON dosyasından yüklendi.");
        } else {
          log("⚠️ kelimelik_backup.json dosyası bulunamadı: $filePath");
        }
      } catch (e) {
        log("❌ JSON dosyasından veri yüklenirken hata oluştu: $e");
      }
    } else {
      log("📦 Veritabanında zaten veri var. JSON yüklemesi yapılmadı.");
    }

    await _loadWords();
  }

  /// Aramayı filtreler.
  void _filterWords(String query) {
    final filtered =
        allWords.where((word) {
          final q = query.toLowerCase();
          return word.word.toLowerCase().contains(q) ||
              word.meaning.toLowerCase().contains(q);
        }).toList();

    setState(() {
      words = filtered;
    });
  }

  /// Arama kutusunu temizler.
  void _clearSearch() {
    searchController.clear();
    setState(() {
      isSearching = false;
      words = allWords;
    });
  }

  /// 📌 Ara yüz burada oluşturuluyor
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /// 📜 AppBar burada
        appBar: CustomAppBar(
          isSearching: isSearching,
          searchController: searchController,
          onSearchChanged: _filterWords,
          onClearSearch: _clearSearch,
          onStartSearch: () {
            setState(() {
              isSearching = true;
            });
          },
          itemCount: words.length,
        ),

        /// 📁 Drawer burada
        drawer: CustomDrawer(
          onDatabaseUpdated: _loadWords,
          appVersion: appVersion,
          isFihristMode: isFihristMode,
          onToggleViewMode: () {
            setState(() {
              isFihristMode = !isFihristMode;
            });
          },
        ),

        /// 📄 Body burada
        body:
            isFihristMode
                ? AlphabetWordList(words: words, onUpdated: _loadWords)
                : WordList(words: words, onUpdated: _loadWords),

        /// ➕ FloatingActionButton burada
        floatingActionButton: Transform.translate(
          offset: const Offset(-20, 0),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            foregroundColor: buttonIconColor,
            onPressed:
                () => showAddWordDialog(context, _loadWords, _clearSearch),
            child: Image.asset('assets/images/add.png', width: 56, height: 56),
          ),
        ),
      ),
    );
  }
}
