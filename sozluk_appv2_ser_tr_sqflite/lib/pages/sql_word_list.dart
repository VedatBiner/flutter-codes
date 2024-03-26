import 'package:flutter/material.dart';

import '../models/sql_word_model.dart';
import '../services/word_dao.dart';

class WordList extends StatefulWidget {
  const WordList({super.key});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  /// tüm Ürün listesine erişelim
  Future<List<SqlWords>> showAllWords() async {
    var liste = await Worddao().getWords();
    return liste;
  }

  // silme metodu
  Future<void> sil(int id) async {
    await Worddao().deleteRecord(id);
  }

  @override
  void initState() {
    super.initState();
    showAllWords().then((value){
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelime Listesi"),
      ),
      body: buildAllProducts(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  // Tüm ürünlerin listelendiği ilk sayfa
  FutureBuilder<List<SqlWords>> buildAllProducts() {
    return FutureBuilder<List<SqlWords>>(
      future: showAllWords(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var kelimelerListesi = snapshot.data;
          return ListView.builder(
            itemCount: kelimelerListesi!.length,
            itemBuilder: (context, index) {
              var words = kelimelerListesi[index];
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ProductDetail(product: product),
                  //   ),
                  // );
                },
                child: Card(
                  color: Colors.cyan,
                  elevation: 2.0,
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          words.sirpca,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(words.turkce),
                        Text(words.userEmail),
                        buildIconButton(words),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          // veri gelmediyse boş bir tasarım göstersin
          return const Center(
            child: Text("*** HATA ***"),
          );
        }
      },
    );
  }

  /// Ekleme düğmesi
  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ProductRecord(),
        //   ),
        // );
      },
      tooltip: 'Kelime Ekle',
      child: const Icon(Icons.add),
    );
  }

  /// Silme düğmesi
  IconButton buildIconButton(SqlWords sqlWord) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.redAccent,
      ),
      onPressed: () async {
        await sil(sqlWord.wordId as int);
        setState(() {});
      },
    );
  }
}
