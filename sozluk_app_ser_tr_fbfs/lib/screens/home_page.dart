/// <----- home_page.dart ----->
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../models/words.dart';
import '../services/theme_provider.dart';
import '../services/firestore.dart';
import '../utils/mesaj_helper.dart';
import '../widgets/delete_word.dart';
import '../widgets/text_entry.dart';
import '../screens/home_page_parts/expanded_word.dart';
import '../screens/home_page_parts/fab_helper.dart';
import '../screens/home_page_parts/stream_builder_footer.dart';
import 'details_page.dart';
import 'home_page_parts/home_app_bar.dart';
import 'home_page_parts/drawer_items.dart';
import 'home_page_parts/showflag_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();

  static String getVersion() {
    return _HomePageState.version;
  }
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController ikinciDilController = TextEditingController();
  final TextEditingController birinciDilController = TextEditingController();
  PackageInfo? packageInfo;
  static String version = "";
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";
  int secilenIndex = 0;

  /// başlangıç dili Sırpça olacak
  String firstLanguageCode = 'RS'; // İlk dil kodu
  String firstLanguageText = 'Sırpça'; // İlk dil metni
  String secondLanguageCode = 'TR'; // İkinci dil kodu
  String secondLanguageText = 'Türkçe'; // İkinci dil metni
  String appBarTitle = appBarMainTitleSecond;

  @override
  void initState() {
    super.initState();
    packageInfoInit();
  }

  /// versiyon bilgisini alıyoruz
  /// Sınıf dışından erişilir olsun
  static Future<void> packageInfoInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  static Future<String?> getVersion() async {
    if (version.isEmpty) {
      await packageInfoInit();
    }
    return version;
  }

  Future<void> openWordBox({
    String? docId,
    required BuildContext context,
  }) async {
    String action = "create";
    String secondLang = "";
    String firstLang = "";

    if (docId != null) {
      action = "update";

      /// Fetch the document data from Firestore
      var snapshot = await firestoreService.getWordById(docId);
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        secondLang = data[fsIkinciDil];
        firstLang = data[fsBirinciDil];
      }
    }

    ikinciDilController.text = secondLang;
    birinciDilController.text = firstLang;

    // showDialog içinde kullanılıyor
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade300 // Dark mode için mavi renk
            : null, // null olması default rengi kullanır
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
            /// Seçilen dil birinci dil ise
            /// seçilen dil üstte yazılır
            if (firstLanguageText == birinciDil)
              TextEntry(
                controller: birinciDilController,
                hintText: "$birinciDil kelime giriniz ...",
              ),
            if (secondLanguageText == ikinciDil)
              TextEntry(
                controller: ikinciDilController,
                hintText: "$ikinciDil karşılığını giriniz ...",
              ),

            /// Seçilen dil ikinci dil ise
            /// seçilen dil üstte yazılır.
            if (firstLanguageText == ikinciDil)
              TextEntry(
                controller: ikinciDilController,
                hintText: "$ikinciDil kelime giriniz ...",
              ),
            if (secondLanguageText == birinciDil)
              TextEntry(
                controller: birinciDilController,
                hintText: "$birinciDil karşılığını giriniz ...",
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
            ),
            onPressed: () async {
              /// iki dil satırıda kelime boş ise eklenmesin
              if (docId == null &&
                  ikinciDilController.text == "" &&
                  birinciDilController.text == "") {
                MessageHelper.showSnackBar(
                  context,
                  message: "İki kelime satırını da boş ekleyemezsiniz ...",
                );
              } else if (docId == null) {
                firestoreService.addWord(
                  context,
                  ikinciDilController.text,
                  birinciDilController.text,
                );
              } else {
                firestoreService.updateWord(
                  docId,
                  ikinciDilController.text,
                  birinciDilController.text,
                );
              }

              ikinciDilController.clear();
              birinciDilController.clear();

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

  Widget buildLanguageSelector({
    required BuildContext context,
  }) {
    return Container(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShowFlagWidget(
              code: firstLanguageCode,
              text: firstLanguageText,
              radius: 8,
            ),
            ShowFlagWidget(
              code: secondLanguageCode,
              text: secondLanguageText,
              radius: 8,
            ),
            IconButton(
              tooltip: "Liste görünümü",
              onPressed: () {},
              icon: Icon(
                Icons.list,
                size: 40,
                color: menuColor,
              ),
            ),
            IconButton(
              /// Dil değişimlerini burada yapıyoruz.
              tooltip: "Dil değiştir",
              onPressed: () {
                setState(() {
                  String tempLanguageCode = firstLanguageCode;
                  String tempLanguageText = firstLanguageText;
                  firstLanguageCode = secondLanguageCode;
                  firstLanguageText = secondLanguageText;
                  secondLanguageCode = tempLanguageCode;
                  secondLanguageText = tempLanguageText;

                  if (firstLanguageText == birinciDil &&
                      secondLanguageText == ikinciDil) {
                    appBarTitle = appBarMainTitleFirst;
                  } else if (firstLanguageText == ikinciDil &&
                      secondLanguageText == birinciDil) {
                    appBarTitle = appBarMainTitleSecond;
                  }
                });
              },
              icon: Icon(
                Icons.swap_horizontal_circle_rounded,
                color: menuColor,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ana kodumuz bu şekilde
  @override
  Widget build(BuildContext context) {
    /// burada Splash_page.dart sayfasına
    /// geri dönüşü engelledik.
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: buildHomeCustomAppBar(),
        body: Column(
          children: [
            buildLanguageSelector(
              context: context,
            ),
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
      ),
    );
  }

  /// AppBar burada değişiyor
  HomeCustomAppBar buildHomeCustomAppBar() {
    return HomeCustomAppBar(
      aramaYapiliyorMu: aramaYapiliyorMu,
      aramaKelimesi: aramaKelimesi,
      onAramaKelimesiChanged: (aramaSonucu) {
        setState(() {
          aramaKelimesi = aramaSonucu;
          if (aramaKelimesi.isNotEmpty) {
            aramaKelimesi =
                aramaKelimesi[0].toUpperCase() + aramaKelimesi.substring(1);
          }
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
      appBarTitle: appBarTitle,
    );
  }

  /// girilen kelime sayısını gösterme
  StreamBuilderFooter buildStreamBuilderFooter() {
    return StreamBuilderFooter(
      firestoreService: firestoreService,
      firstLanguageText: firstLanguageText,
    );
  }

  /// burada kelime listesi için streamBuilder oluşturuyoruz
  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getWordsStream(firstLanguageText),
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

          /// Burada arama kutusuna yazılan kelimenin diline
          /// göre listelenme yapılması sağlanıyor.
          if (!aramaYapiliyorMu ||
              gelenKelime.turkce.contains(aramaKelimesi) ||
              gelenKelime.sirpca.contains(aramaKelimesi)) {
            wordsList.add(gelenKelime);
          }
        }

        /// Dil seçimine göre kelimeleri sırala
        wordsList.sort((a, b) {
          if (firstLanguageText == birinciDil) {
            return a.turkce.compareTo(b.turkce);
          } else {
            return a.sirpca.compareTo(b.sirpca);
          }
        });
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: Colors.blue[200],
      color: themeProvider.isDarkMode ? cardDarkMode : cardLightMode,
      // Colors.grey[200],
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandedWord(
              word: firstLanguageText == birinciDil ? word.turkce : word.sirpca,
              color: themeProvider.isDarkMode
                  ? cardDarkModeText1
                  : cardLightModeText1,
              align: TextAlign.start,
            ),
            const Divider(color: Colors.black26),
            ExpandedWord(
              word: secondLanguageText == ikinciDil ? word.sirpca : word.turkce,
              color: themeProvider.isDarkMode
                  ? cardDarkModeText2
                  : cardLightModeText2,
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
  IconButton kelimeSil(
    BuildContext context,
    Words word,
  ) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeleteWord(
              word: word,
              firestoreService: firestoreService,

              /// Burada dil seçimine göre
              /// silinecek kelime bilgisini oluşturuyoruz
              firstLanguageText:
                  firstLanguageText == birinciDil ? ikinciDil : birinciDil,
              secondLanguageText:
                  secondLanguageText == ikinciDil ? birinciDil : ikinciDil,
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
