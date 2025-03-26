import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final allWords = await WordDatabase.instance.getWords();
    setState(() {
      words = allWords;
    });
  }

  void _showAddWordDialog() async {
    final result = await showDialog<Word>(
      context: context,
      builder: (_) => WordDialog(),
    );

    if (result != null) {
      final existing = await WordDatabase.instance.getWord(result.word);
      if (existing != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu kelime zaten var')),
        );
        return;
      }

      await WordDatabase.instance.insertWord(result);
      _loadWords();
    }
  }

  void _showResetDatabaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelimelik'),
      ),
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
              leading: const Icon(Icons.delete),
              title: const Text('Veritabanını Sıfırla'),
              onTap: _showResetDatabaseDialog,
            ),
          ],
        ),
      ),
      body: WordList(words: words),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWordDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
