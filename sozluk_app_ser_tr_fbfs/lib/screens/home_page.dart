/// <----- home_page.dart ----->
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController sirpcaController = TextEditingController();
  final TextEditingController turkceController = TextEditingController();
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";


  // /// arama yapalım
  // Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async {
  //   var kelimelerListesi = await Kelimelerdao().kelimeAra(aramaKelimesi);
  //   return kelimelerListesi;
  // }

  /// Open dialog box to ad a note
  void openWordBox({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: sirpcaController,
              decoration: const InputDecoration(
                hintText: "Sırpça kelime giriniz ...",
              ),
            ),
            TextField(
              controller: turkceController,
              decoration: const InputDecoration(
                hintText: "Türkçe karşılığını giriniz ...",
              ),
            ),
          ],
        ),
        actions: [
          /// button to save
          ElevatedButton(
            onPressed: () {
              /// add a new note
              if (docId == null) {
                firestoreService.addWord(
                  sirpcaController.text,
                  turkceController.text,
                );
              } else {
                /// update an existing note
                firestoreService.updateWord(
                  docId,
                  sirpcaController.text,
                  turkceController.text,
                );
              }

              /// clear text controller
              sirpcaController.clear();
              turkceController.clear();

              /// close the box
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
      appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
                decoration: const InputDecoration(
                  hintText: "Arama için bir şey yazın",
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openWordBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getWordsStream(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          /// if we have data, get all the docs
          if (snapshot.hasData) {
            List wordsList = snapshot.data!.docs;

            /// display as a list
            return ListView.builder(
              itemCount: wordsList.length,
              itemBuilder: (context, index) {
                /// get each individual doc
                DocumentSnapshot document = wordsList[index];
                String docId = document.id;

                /// get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String sirpcaText = data["sirpca"];
                String turkceText = data["turkce"] ?? "---";

                /// display as a list tile
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
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
                                    sirpcaText,
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
                                    turkceText,
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
                              /// update
                              IconButton(
                                onPressed: () => openWordBox(docId: docId),
                                icon: const Icon(Icons.edit),
                                tooltip: "kelime düzelt",
                              ),

                              /// delete
                              IconButton(
                                onPressed: () {
                                  firestoreService.deleteWord(docId);
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
            return const Text("No notes ...");
          }
        },
      ),
    );
  }
}
