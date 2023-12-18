/// <----- home_page.dart ----->

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/words.dart';
import '../services/firestore.dart';
import '../screens/details_page.dart';
import '../widgets/delete_word.dart';
import 'home_page_parts/expanded_word.dart';
import '../widgets/flags_widget.dart';
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
      appBar: buildAppBar(),
      body: Column(
        children: [
          Container(
            color: Colors.blueAccent,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FlagWidget(
                          countryCode: 'RS',
                          radius: 8,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Sırpça',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        FlagWidget(
                          countryCode: 'TR',
                          radius: 8,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Türkçe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(width: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getWordsStream(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              List<Words> wordsList = [];
              for (var document in snapshot.data!.docs) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                var gelenKelime = Words.fromJson(document.id, data);
                if (!aramaYapiliyorMu ||
                    gelenKelime.sirpca.contains(aramaKelimesi)) {
                  wordsList.add(gelenKelime);
                }
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: wordsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                word: wordsList[index],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 100,
                          child: buildCard(wordsList[index], context),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 5),
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getWordsStream(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              int wordCount = snapshot.data?.size ?? 0;
              return Container(
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text('Girilen kelime sayısı: '),
                        Text(
                          "$wordCount",
                          style: const TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => openWordBox(),
      child: const Icon(Icons.add),
    );
  }

  ListView buildListView(List<Words> wordsList) {
    return ListView.builder(
      itemCount: wordsList.length,
      itemBuilder: (context, index) {
        Words word = wordsList[index];
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
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

  Card buildCard(Words word, BuildContext context) {
    return Card(
      color: Colors.grey[200],
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

  Row buildRow(Words word, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        kelimeDuzelt(word),
        kelimeSil(context, word),
      ],
    );
  }

  IconButton kelimeSil(BuildContext context, Words word) {
    return IconButton(
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
      );
  }

  IconButton kelimeDuzelt(Words word) {
    return IconButton(
        onPressed: () => openWordBox(docId: word.wordId),
        icon: const Icon(Icons.edit),
        tooltip: "kelime düzelt",
      );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: aramaYapiliyorMu
          ? TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Aradığınız kelimeyi yazınız ...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
              onChanged: (aramaSonucu) {
                setState(() {
                  aramaKelimesi = aramaSonucu;
                });
              },
            )
          : const Text(
              "Sırpça-Türkçe Sözlük",
              style: TextStyle(color: Colors.white),
            ),
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


