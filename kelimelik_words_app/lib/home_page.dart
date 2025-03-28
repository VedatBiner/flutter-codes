import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'db/word_database.dart';
import 'models/word_model.dart';
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

  void _showResetDatabaseDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Veritabanını Sıfırla'),
            content: const Text('Tüm kelimeler silinecek. Emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).maybePop();
                },
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final db = await WordDatabase.instance.database;
                  await db.delete('words');
                  Navigator.of(context).pop();
                  Navigator.of(context).maybePop();
                  _loadWords();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veritabanı sıfırlandı')),
                  );
                },
                child: const Text('Sil'),
              ),
            ],
          ),
    );
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
      appBar: _buildAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Menü',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('JSON Yedeği Oluştur'),
              onTap: () async {
                final path = await WordDatabase.instance.exportWordsToJson();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Yedek oluşturuldu:\n$path')),
                );
                Navigator.of(context).maybePop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Yedekten Geri Yükle'),
              onTap: () async {
                await WordDatabase.instance.importWordsFromJson();
                await _loadWords();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Yedek geri yüklendi')),
                );
                Navigator.of(context).maybePop();
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Veritabanını Sıfırla'),
              onTap: _showResetDatabaseDialog,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                appVersion,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: WordList(words: words, onUpdated: _loadWords),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWordDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
