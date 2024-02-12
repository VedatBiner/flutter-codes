import 'package:flutter/material.dart';
import '../../models/words.dart';

class WordListPage extends StatelessWidget {
  final List<Words> wordsList;

  const WordListPage({super.key, required this.wordsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word List'),
      ),
      body: ListView.builder(
        itemCount: wordsList.length,
        itemBuilder: (context, index) {
          Words word = wordsList[index];
          return ListTile(
            title: Text(word.sirpca),
            subtitle: Text(word.turkce),
            onTap: () {
              // Burada kelimenin detay sayfasına gitmek için gerekli işlemleri yapabilirsiniz
              // Örneğin:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => WordDetailPage(word: word),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
