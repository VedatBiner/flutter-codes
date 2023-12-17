/// <----- home_page.dart ----->

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/words.dart';
import '../services/firestore.dart';
import '../screens/details_page.dart';
import '../widgets/delete_word.dart';
import '../widgets/text_entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController sirpcaController = TextEditingController();
  final TextEditingController turkceController = TextEditingController();
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  void openWordBox({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// bu bölümde kelime giriş alanlarımızı tanımlıyoruz
            TextEntry(
              controller: sirpcaController,
              hintText: "Sırpça kelime giriniz ...",
            ),
            TextEntry(
              controller: turkceController,
              hintText: "Türkçe karşılığını giriniz ...",
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docId == null) {
                firestoreService.addWord(
                  sirpcaController.text,
                  turkceController.text,
                );
              } else {
                firestoreService.updateWord(
                  docId,
                  sirpcaController.text,
                  turkceController.text,
                );
              }

              sirpcaController.clear();
              turkceController.clear();

              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar oluşturalım
      appBar: buildAppBar(),

      /// body oluşturalım
      body: buildStreamBuilder(),

      /// FAB Basılınca uygulanacak metot
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  /// FAB burada oluşturuluyor
  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => openWordBox(),
      child: const Icon(Icons.add),
    );
  }

  /// Firestore verileri buradan okunuyor
  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getWordsStream(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.hasData) {
          List<Words> wordsList = [];

          /// burada for each döngüsü for loop 'a dönüştürüldü
          for (var document in snapshot.data!.docs) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            var gelenKelime = Words.fromJson(document.id, data);

            /// burada aradığımız kelimeler listeleniyor.
            if (!aramaYapiliyorMu ||
                gelenKelime.sirpca.contains(aramaKelimesi)) {
              wordsList.add(gelenKelime);
            }
          }

          return buildListView(wordsList);
        } else {
          return const Text("No words ...");
        }
      },
    );
  }

  /// Firebase verileri burada listeleniyor.
  ListView buildListView(List<Words> wordsList) {
    return ListView.builder(
      /// kelime sayımız kadar listeleme yapılıyor
      itemCount: wordsList.length,
      itemBuilder: (context, index) {
        Words word = wordsList[index];

        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),

          /// kelime tıklanınca detay sayfası açılıyor
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    word: word,
                  ),
                ),
              );
            },
            child: SizedBox(
              height: 100,
              child: buildCard(word, context),
            ),
          ),
        );
      },
    );
  }

  /// kelime kartlarının oluşturulması
  Card buildCard(Words word, BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExpandedWord(
              word: word.sirpca,
              color: Colors.red,
            ),
            const SizedBox(width: 10),
            ExpandedWord(
              word: word.turkce,
              color: Colors.blueAccent,
            ),
            const SizedBox(width: 20),
          ],
        ),
        trailing: buildRow(word, context),
      ),
    );
  }

  /// edit ve delete butonları
  Row buildRow(Words word, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => openWordBox(docId: word.wordId),
          icon: const Icon(Icons.edit),
          tooltip: "kelime düzelt",
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteWord(
                  word: word,
                  firestoreService: firestoreService,
                );
              },
            );
          },
          icon: const Icon(Icons.delete),
          tooltip: "kelime sil",
        ),
      ],
    );
  }

  /// AppBar oluşturulması
  AppBar buildAppBar() {
    return AppBar(
      title: aramaYapiliyorMu
          ? TextField(
              decoration: const InputDecoration(
                hintText: "Aradığınız kelimeyi yazınız ...",
              ),
              onChanged: (aramaSonucu) {
                setState(() {
                  aramaKelimesi = aramaSonucu;
                });
              },
            )
          : const Text("Sırpça-Türkçe Sözlük"),
      actions: [
        aramaYapiliyorMu
            ? IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    aramaYapiliyorMu = false;
                    aramaKelimesi = "";
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    aramaYapiliyorMu = true;
                  });
                },
              ),
      ],
    );
  }
}

/// kelime ve karşılığı
class ExpandedWord extends StatelessWidget {
  const ExpandedWord({
    super.key,
    required this.word,
    required this.color,
  });

  final color;
  final word;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          word,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
