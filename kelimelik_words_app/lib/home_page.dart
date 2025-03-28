import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'db/word_database.dart';
import 'models/word_model.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/word_dialog.dart';
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

  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = 'Versiyon: ${info.version} (${info.buildNumber})';
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

  void _showAddWordDialog() async {
    final result = await showDialog<Word>(
      context: context,
      builder: (_) => const WordDialog(),
    );

    if (result != null) {
      final existing = await WordDatabase.instance.getWord(result.word);
      if (existing != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bu kelime zaten var')));
        return;
      }

      await WordDatabase.instance.insertWord(result);
      _loadWords();
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title:
          isSearching
              ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Ara...',
                  border: InputBorder.none,
                ),
                onChanged: _filterWords,
              )
              : Text('Kelimelik (${words.length})'), // ← burada
      actions: [
        isSearching
            ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch)
            : IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 📜 AppBar burada
      appBar: _buildAppBar(),

      /// 📁 Drawer burada
      drawer: CustomDrawer(
        onDatabaseUpdated: _loadWords,
        appVersion: appVersion,
      ),

      /// 📄 Body burada
      body: WordList(words: words, onUpdated: _loadWords),

      /// ➕ FloatingActionButton burada
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWordDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
