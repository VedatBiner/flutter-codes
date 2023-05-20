import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Welcome to Flutter',
      home:Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to Flutter"),
        ),
        body: const Center(child: RandomWords()),
      ),

    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomwordsState();
}

class _RandomwordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i){
        if (i.isOdd){
          return const Divider();
        }
        // çıkan sonucun tam sayı kısmını elde ediyoruz
        final int index = i ~/ 2;
        if (index >= _suggestions.length){
          // rasgele on kelime alıyor, listeye ekliyor
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair){
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}






















