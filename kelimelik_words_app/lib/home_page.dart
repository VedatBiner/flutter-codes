// 📃 <----- home_page.dart ----->

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'db/word_database.dart';
import 'models/word_model.dart';
import 'widgets/add_word_dialog_handler.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/word_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Word> words = [];
  List<Word> allWords = [];

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadWords();
    _getAppVersion();
  }

  /// ❓ Uygulamanın versiyonunu alır.
  ///
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

  /// 🔎 Aramayı filtreler.
  ///
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

  /// 🗑️ Aramayı temizler.
  ///
  void _clearSearch() {
    searchController.clear();
    setState(() {
      isSearching = false;
      words = allWords;
    });
  }

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
        ),

        /// 📄 Body burada
        body: WordList(words: words, onUpdated: _loadWords),

        /// ➕ FloatingActionButton burada
        floatingActionButton: FloatingActionButton(
          onPressed: () => showAddWordDialog(context, _loadWords, _clearSearch),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
