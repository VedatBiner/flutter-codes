/// <----- home_page.dart ----->

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/words.dart';
import '../services/firestore.dart';
import '../screens/details_page.dart';

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
      appBar: AppBar(
        /// burada aram düğmesine basılıp basılmadığını
        /// kontrol edip sonuca göre işlem yapıyoruz
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
                  /// arama iptal düğmesi burada
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = false;
                      aramaKelimesi = "";
                    });
                  },
                )
              : IconButton(
                  /// arama düğmesi burada
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = true;
                    });
                  },
                ),
        ],
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
                          builder: (context) => DetailsPage(
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
                                      return deleteWord(
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

class deleteWord extends StatelessWidget {
  const deleteWord({
    super.key,
    required this.word,
    required this.firestoreService,
  });

  final Words word;
  final FirestoreService firestoreService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      title: const Text(
        "Dikkat !!!",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Row(
        children: [
          const Text("Bu kelime "),
          Text(
            "(${word.sirpca})",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontSize: 16,
            ),
          ),
          const Text(" silinsin mi ?"),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("İptal"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text(
            "Tamam",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            firestoreService.deleteWord(word.wordId);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Text(
                      "(${word.sirpca})",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      " kelimesi silinmiştir ...",
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
