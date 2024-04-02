/// <----- home_page.dart ----->
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../models/____fs_words.dart_iptal';
import '../models/words.dart';
import '../services/app_routes.dart';
import '../services/icon_provider.dart';
import '../services/theme_provider.dart';
import '../services/firestore.dart';
import '../services/word_service.dart';
import '../utils/generate_json.dart';
import '../utils/mesaj_helper.dart';
import '../widgets/delete_word.dart';
import '../widgets/text_entry.dart';
import '../screens/home_page_parts/expanded_word.dart';
import '../screens/home_page_parts/fab_helper.dart';
import '../screens/home_page_parts/stream_builder_footer.dart';
import 'home_page_parts/home_app_bar.dart';
import 'home_page_parts/drawer_items_new.dart';
import 'home_page_parts/showflag_widget.dart';
import 'home_page_parts/word_list_test.dart';

/// bu bölüm test içindir
late CollectionReference<FsWords> collection;
late Query<FsWords> query;
/// test sonu

class HomePage_iptal extends StatefulWidget {
  const HomePage_iptal({super.key});

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage_iptal> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController ikinciDilController = TextEditingController();
  final TextEditingController birinciDilController = TextEditingController();


  int secilenIndex = 0;


  /// Scrollbar için controller
  ScrollController listViewController = ScrollController();
  final _itemExtent = 100.0;



  // @override
  // void initState() {
  //   super.initState();
  //   packageInfoInit();
  //   listViewController = ScrollController();
  //   /// Firestore verisinden JSON dosya oluşturup yazıyoruz
  //   _wordService = WordService();
  //   jsonInit();
  //
  //   /// test
  //   initializeFirestore();
  // }



 /* Future<void> openWordBox({
    String? docId,
    required BuildContext context,
    Words? word,
  }) async {
    String action = "create";
    String secondLang = "";
    String firstLang = "";
    String message = "";

    /// eğer currentUserMail null ise sabit değer alsın
    String currentUserEmail =
        FirebaseAuth.instance.currentUser?.email ?? 'vbiner@gmail.com';

    if (docId != null) {
      action = "update";

      /// Firestore 'dan belge verilerini al
      var snapshot = await firestoreService.getWordById(docId);
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        secondLang = data[fsIkinciDil];
        firstLang = data[fsBirinciDil];
      }
    }

    ikinciDilController.text = secondLang;
    birinciDilController.text = firstLang;

    /// showDialog içinde kullanılıyor
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
              /// iki dil satırı da kelime boş ise eklenmesin
              if (docId == null &&
                  ikinciDilController.text == "" &&
                  birinciDilController.text == "") {
                MessageHelper.showSnackBar(
                  context,
                  message: "İki kelime satırını da boş ekleyemezsiniz ...",
                );
              } else if (docId == null) {
                /// kelime ekleniyor
                firestoreService.addWord(
                  context,
                  ikinciDilController.text,
                  birinciDilController.text,
                );
                message = addMsg;
              } else {
                /// kelime güncelleniyor
                firestoreService.updateWord(
                  docId,
                  ikinciDilController.text,
                  birinciDilController.text,
                );
                message = updateMsg;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            ikinciDilController.text ?? '',
                            style: kelimeStil,
                          ),
                          const Text(" kelimesi "),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            currentUserEmail,
                            style: userStil,
                          ),
                          Text(
                            message,
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              );

              /// Controller içeriklerini temizliyoruz
              ikinciDilController.clear();
              birinciDilController.clear();

              Navigator.pop(context);
            },
            child: Text(
              docId == null ? "Kelime ekle" : "Kelime düzelt",
              style: butonTextDialog,
            ),
          )
        ],
      ),
    );
  }*/

  /*Widget buildLanguageSelector({
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
            Consumer<IconProvider>(
              builder: (context, iconProvider, _) {
                return IconButton(
                  tooltip: "Görünümü değiştir",
                  icon: Icon(
                    iconProvider.isIconChanged ? Icons.credit_card : Icons.list,
                    size: 40,
                    color: menuColor,
                  ),
                  onPressed: () {
                    setState(() {
                      iconProvider.changeIcon();
                      isListView = !isListView;
                    });
                  },
                );
              },
            ),
            IconButton(
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
  }*/

  /*/// ana kodumuz bu şekilde
  @override
  Widget build(BuildContext context) {
    /// burada Splash_page.dart sayfasına
    /// geri dönüşü engelledik.
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildHomeCustomAppBar(),
        body: showBody(context),

        /// bu bölüm tüm koleksiyon ögelerine mail adresi eklemek
        /// için kullanıldı.
        // body: Center(
        //   child: ElevatedButton(
        //     onPressed: () async {
        //       // FirestoreService sınıfından bir örnek oluştur
        //       FirestoreService firestoreService = FirestoreService();
        //       // Yeni alanı ve değeri ekleyen metodu çağır
        //       await firestoreService.addFieldToAllDocuments('userEmail', 'vbiner@gmail.com');
        //     },
        //     child: const Text('Tüm Belgelere Alan Ekle'),
        //   ),
        // ),

        drawer: buildDrawer(context),
        floatingActionButton: buildFloatingActionButton(onPressed: () {  }

          /// onPressed: () => openWordBox(context: context),
        ),
      ),
    );
  }*/

  ,

      ],
    );
  }*/



  /// girilen kelime sayısını gösterme
  Widget buildStreamBuilderFooter(BuildContext context) {
    return StreamBuilderFooter(
      firestoreService: firestoreService,
      firstLanguageText: firstLanguageText,
    );
  }

  /// burada kelime listesi için streamBuilder oluşturuyoruz
  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilderList() {
    final ScrollController controller = ScrollController();
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getWordsStream(firstLanguageText),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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

        /// Liste görünümü veya Card Görünümü
        /// Burada seçiliyor
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return DraggableScrollbar.arrows(
              alwaysVisibleScrollThumb: true,
              padding: const EdgeInsets.only(right: 2.0),
              backgroundColor: themeProvider.isDarkMode
                  ? Colors.white
                  : Colors.grey.shade800,
              controller: listViewController,
              labelTextBuilder: (double offset) => Text(
                firstLanguageText,
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.red : Colors.blue,
                ),
              ),
              child: isListView

              /// true ise Card görünümü olacak
              /// default olarak false geliyor
                  ? buildListView(wordsList)

              /// false ise List görünümü gelecek
                  : ListView.builder(
                itemCount: wordsList.length,
                itemExtent: _itemExtent,
                controller: listViewController,
                itemBuilder: (context, index) {
                  return buildCard(wordsList[index], context);
                },
              ),
            );
          },
        );
      },
    );
  }

  /// Kelime listesi görünümü burada oluşturuluyor
  ListView buildListView(List<Words> wordsList) {
    return ListView.separated(
      controller: listViewController,
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
        height: 1,
      ),
      itemCount: wordsList.length,
      itemBuilder: (context, index) {
        Words word = wordsList[index];
        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  firstLanguageText == birinciDil ? word.turkce : word.sirpca,
                  style: listTextRed,
                ),
              ),
              Expanded(
                child: Text(
                  firstLanguageText == birinciDil ? word.sirpca : word.turkce,
                  style: listTextBlue,
                ),
              ),
            ],
          ),
          onTap: () async {
            await Navigator.pushNamed(
              context,
              AppRoute.details,
              arguments: word,
            );
          },
        );
      },
    );
  }

  /// Kelime kart görünümü burada oluşturuluyor
  Padding buildCard(Words word, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        shadowColor: Colors.green[200],
        color: themeProvider.isDarkMode ? cardDarkMode : cardLightMode,
        child: SizedBox(
          height: 100,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpandedWord(
                    word: firstLanguageText == birinciDil
                        ? word.turkce
                        : word.sirpca,
                    color: themeProvider.isDarkMode
                        ? cardDarkModeText1
                        : cardLightModeText1,
                    align: TextAlign.start,
                  ),
                  const Divider(color: Colors.black26),
                  ExpandedWord(
                    word: secondLanguageText == ikinciDil
                        ? word.sirpca
                        : word.turkce,
                    color: themeProvider.isDarkMode
                        ? cardDarkModeText2
                        : cardLightModeText2,
                    align: TextAlign.end,
                  ),
                ],
              ),
            ),
            trailing: buildRow(word, context),
            onTap: () async {
              await Navigator.pushNamed(
                context,
                AppRoute.details,
                arguments: word,
              );
            },
          ),
        ),
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
        kelimeDuzelt(context, word),
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
  IconButton kelimeDuzelt(
      BuildContext context,
      Words word,
      ) {
    return IconButton(

      // onPressed: () => openWordBox(
      //   docId: word.wordId,
      //   context: context,
      // ),
      icon: const Icon(Icons.edit),
      tooltip: "kelime düzelt",
  onPressed: () {  },
    );
  }
}