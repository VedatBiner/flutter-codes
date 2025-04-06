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

  bool isLoadingJson = false;
  double progress = 0.0;
  String? loadingWord;

  @override
  void initState() {
    super.initState();
    loadDataFromDatabase();
    _getAppVersion();
  }

  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = 'Versiyon: ${info.version}';
    });
  }

  Future<void> _loadWords() async {
    allWords = await WordDatabase.instance.getWords();
    final count = await WordDatabase.instance.countWords();

    setState(() {
      words = allWords;
    });

    log('📦 Toplam kayıt sayısı: $count');
  }

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

          final loadedWords =
              jsonList.map((e) {
                final map = e as Map<String, dynamic>;
                return Word(word: map['word'], meaning: map['meaning']);
              }).toList();

          setState(() {
            isLoadingJson = true;
            progress = 0.0;
          });

          for (int i = 0; i < loadedWords.length; i++) {
            final word = loadedWords[i];
            setState(() {
              progress = (i + 1) / loadedWords.length;
              loadingWord = word.word;
            });
            log("📥 ${word.word} (${i + 1}/${loadedWords.length})");
            await WordDatabase.instance.insertWord(word);
            await Future.delayed(const Duration(milliseconds: 30));
          }

          setState(() {
            isLoadingJson = false;
            loadingWord = null;
            progress = 0.0;
          });

          log("✅ ${loadedWords.length} kelime JSON dosyasından yüklendi.");
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
            body:
                isFihristMode
                    ? AlphabetWordList(words: words, onUpdated: _loadWords)
                    : WordList(words: words, onUpdated: _loadWords),
            floatingActionButton: Transform.translate(
              offset: const Offset(-20, 0),
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                foregroundColor: buttonIconColor,
                onPressed:
                    () => showAddWordDialog(context, _loadWords, _clearSearch),
                child: Image.asset(
                  'assets/images/add.png',
                  width: 56,
                  height: 56,
                ),
              ),
            ),
          ),
        ),

        // 🔄 JSON'dan veri yükleniyor ekranı
        if (isLoadingJson)
          Center(
            child: Card(
              color: Colors.white,
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Veriler Yükleniyor...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(progress * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 12),
                    if (loadingWord != null)
                      Text(
                        loadingWord!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepOrange,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
