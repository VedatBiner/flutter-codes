/// <----- home_page.dart ----->

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/base_constants/app_const.dart';
import '../constants/app_constants/constants.dart';
import '../help_pages/sayfa_kiril.dart';
import '../help_pages/sayfa_latin.dart';
import '../models/words.dart';
import '../services/firestore.dart';
import '../screens/details_page.dart';
import '../utils/mesaj_helper.dart';
import '../widgets/delete_word.dart';
import '../widgets/text_entry.dart';
import '../screens/home_page_parts/expanded_word.dart';
import '../screens/home_page_parts/ana_baslik.dart';
import '../screens/home_page_parts/app_bar.dart';
import '../screens/home_page_parts/fab_helper.dart';
import '../screens/home_page_parts/stream_builder_footer.dart';
import 'home_page_parts/drawer_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController sirpcaController = TextEditingController();
  final TextEditingController turkceController = TextEditingController();
  final themeNotifier = AppConst.listener.themeNotifier;
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
                MessageHelper.showSnackBar(
                  context,
                  message: "İki kelime satırını da boş ekleyemezsiniz ...",
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
  }

  /// ana kodumuz bu şekilde
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        aramaYapiliyorMu: aramaYapiliyorMu,
        aramaKelimesi: aramaKelimesi,
        onAramaKelimesiChanged: (aramaSonucu) {
          setState(() {
            aramaKelimesi = aramaSonucu;
          });
        },
        onCancelPressed: () {
          setState(() {
            aramaYapiliyorMu = false;
            aramaKelimesi = "";
          });
        },
        onSearchPressed: () {
          setState(() {
            aramaYapiliyorMu = true;
          });
        },
      ),
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
      floatingActionButton: buildFloatingActionButton(
        onPressed: () => openWordBox(context: context),
      ),
    );
  }

  /// girilen kelime sayısını gösterme
  StreamBuilderFooter buildStreamBuilderFooter() {
    return StreamBuilderFooter(firestoreService: firestoreService);
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
      shadowColor: Colors.lightBlue,
      backgroundColor: drawerColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: drawerColor,
            ),
            child: const Text(
              "Yardımcı Bilgiler",
              style: baslikTextWhite,
            ),
          ),
          for (var item in drawerItems) // Değişen satır
            buildListTile(context, item["title"], item["page"]),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                color: menuColor,
                onPressed: () {
                  setState(() {
                    AppConst.listener.themeNotifier.changeTheme();
                  });
                },
                icon: Icon(
                  themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.brightness_3,
                ),
              ),
            ),
          ),
        ],
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: Colors.blue[200],
      color: Colors.grey[200],
      child: ListTile(
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandedWord(
              word: word.sirpca,
              color: Colors.red,
              align: TextAlign.start,
            ),
            const Divider(color: Colors.black26),
            ExpandedWord(
              word: word.turkce,
              color: Colors.blueAccent,
              align: TextAlign.end,
            ),
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
}