/// <----- home_page.dart ----->

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../help_pages/sayfa_kiril.dart';
import '../help_pages/sayfa_latin.dart';
import '../models/words.dart';
import '../services/firestore.dart';
import '../screens/details_page.dart';
import '../widgets/delete_word.dart';
import '../screens/home_page_parts/expanded_word.dart';
import '../screens/home_page_parts/ana_baslik.dart';
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
  int secilenIndex = 0;
  var sayfaListe = [
    const SayfaLatin(),
    const SayfaKiril(),
  ];

  Future<void> openWordBox({
    String? docId,
    required BuildContext context,
  }) async {
    String action = "create";
    String sirpca = "";
    String turkce = "";

    if (docId != null) {
      action = "update";
      // Fetch the document data from Firestore
      var snapshot = await firestoreService.getWordById(docId);
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        sirpca = data["sirpca"];
        turkce = data["turkce"];
      }
    }

    sirpcaController.text = sirpca;
    turkceController.text = turkce;

    // showDialog içinde kullanılıyor
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
            ),
            onPressed: () async {
              // Sırpça ve Türkçe kelime boş ise eklenmesin
              if (docId == null &&
                  sirpcaController.text == "" &&
                  turkceController.text == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "İki kelime satırını da boş ekleyemezsiniz ...",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else if (docId == null) {
                firestoreService.addWord(
                  context,
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
            child: Text(
              docId == null ? "Kelime ekle" : "Kelime düzelt",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          )
        ],
      ),
    );

    // Geri kalan fonksiyon...
  }

  /// ana kodumuz bu şekilde
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          const AnaBaslik(),
          const SizedBox(height: 5),
          buildStreamBuilderList(),
          const SizedBox(height: 5),
          buildStreamBuilderFooter(),
        ],
      ),
      drawer: buildDrawer(context),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  /// Burada kelime sayısı için stream builder oluşturduk
  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilderFooter() {
    return StreamBuilder<QuerySnapshot>(
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
    );
  }

  /// burada kelime listesi için streamBuilder oluşturuyoruz
  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilderList() {
    return StreamBuilder<QuerySnapshot>(
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
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          var gelenKelime = Words.fromJson(document.id, data);
          if (!aramaYapiliyorMu || gelenKelime.sirpca.contains(aramaKelimesi)) {
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
    );
  }

  /// Burada drawer menü oluşturuyoruz
  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              "Yardımcı Bilgiler",
              style: baslikTextWhite,
            ),
          ),
          ListTile(
            title: const Text("Alfabe (Latin)"),
            onTap: () {
              setState(() {
                secilenIndex = 0;
              });
              Navigator.pop(context); // drawer kapat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SayfaLatin(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Alfabe (Kril)"),
            onTap: () {
              setState(() {
                secilenIndex = 1;
              });
              Navigator.pop(context); // drawer kapat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SayfaKiril(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Burada FAB buton var
  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => openWordBox(context: context),
      backgroundColor: Colors.blueAccent,
      child: const Icon(
        Icons.add,
        color: Colors.amberAccent,
      ),
    );
  }

  /// Burada kelimeleri listeliyoruz
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
            child: buildCard(word, context),
          ),
        );
      },
    );
  }

  /// Sözlük kartları burada oluşturuluyor
  Card buildCard(Words word, BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandedWord(
              word: word.sirpca,
              color: Colors.red,
              align: TextAlign.left,
            ),
            const SizedBox(height: 4),
            const Divider(color: Colors.black26),
            ExpandedWord(
              word: word.turkce,
              color: Colors.blueAccent,
              align: TextAlign.right,
            ),
            const SizedBox(height: 4),
          ],
        ),
        trailing: buildRow(word, context),
      ),
    );
  }

  /// Burada silme ve düzeltme butonlarını gösteriyoruz
  Row buildRow(
    Words word,
    BuildContext context,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        kelimeDuzelt(word),
        kelimeSil(context, word),
      ],
    );
  }

  /// Burada silme butonu için metot oluşturduk
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

  /// Burada düzeltme butonu için metodumuz var
  IconButton kelimeDuzelt(Words word) {
    return IconButton(
      onPressed: () => openWordBox(
        docId: word.wordId,
        context: context,
      ),
      icon: const Icon(Icons.edit),
      tooltip: "kelime düzelt",
    );
  }

  /// Burada ana sayfamız için appbar oluşturuyoruz
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
      iconTheme: const IconThemeData(color: Colors.amberAccent),
      actions: [
        aramaYapiliyorMu
            ? IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    aramaYapiliyorMu = false;
                    aramaKelimesi = "";
                  });
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.amberAccent,
                ),
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
