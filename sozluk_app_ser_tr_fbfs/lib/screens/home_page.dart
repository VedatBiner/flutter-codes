/// <----- home_page.dart ----->

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/words.dart';
import '../services/firestore.dart';
import '../screens/details_page.dart';
import '../widgets/app_bar.dart';
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
      builder: (context) =>
          AlertDialog(
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
      appBar: CustomAppBar(
        aramaYapiliyorMu: aramaYapiliyorMu,
        aramaKelimesi: aramaKelimesi,
        onSearchChanged: (aramaSonucu) {
          setState(() {
            aramaKelimesi = aramaSonucu;
          });
        },
        onSearchCancelled: () {
          setState(() {
            aramaYapiliyorMu = false;
            aramaKelimesi = "";
          });
        },
      ),

      /// FAB Basılınca uygulanacak metot
      floatingActionButton: FloatingActionButton(
        onPressed: () => openWordBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getWordsStream(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasData) {
            List<Words> wordsList = [];

            /// burada for each döngüsü for loop 'a dönüştürüldü
            for (var document in snapshot.data!.docs) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              var gelenKelime = Words.fromJson(document.id, data);

              /// burada aradığımız kelimeler listeleniyor.
              if (!aramaYapiliyorMu ||
                  gelenKelime.sirpca.contains(aramaKelimesi)) {
                wordsList.add(gelenKelime);
              }
            }

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
                          builder: (context) =>
                              DetailsPage(
                                word: word,
                              ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    word.sirpca,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    word.turkce,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    openWordBox(docId: word.wordId),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text("No words ...");
          }
        },
      ),
    );
  }
}