/// <----- home_page.dart ----->
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../models/fs_words.dart';
import '../models/words.dart';
import '../services/firestore_services.dart';
import '../services/icon_provider.dart';
import '../services/word_service.dart';
import '../utils/generate_json.dart';
import '../utils/mesaj_helper.dart';
import '../widgets/test_entry.dart';
import 'home_page_parts/bottom_sheet.dart';
import 'home_page_parts/drawer_items.dart';
import 'home_page_parts/fab_helper.dart';
import 'home_page_parts/home_app_bar.dart';
import 'home_page_parts/laguage_selector.dart';
import 'home_page_parts/word_list_builder.dart';

late CollectionReference<FsWords> collection;
late Query<FsWords> query;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// JSON dosya oluşturup güncel tutalım
  late WordService _wordService = WordService();
  /// Firestore servisi için değişken oluşturalım
  final FirestoreService firestoreService = FirestoreService();

  bool isListView = false;
  bool aramaYapiliyorMu = false;

  String aramaKelimesi = "";

  /// başlangıç dili Sırpça olacak
  String firstLanguageCode = 'RS'; // İlk dil kodu
  String firstLanguageText = 'Sırpça'; // İlk dil metni
  String secondLanguageCode = 'TR'; // İkinci dil kodu
  String secondLanguageText = 'Türkçe'; // İkinci dil metni
  String appBarTitle = appBarMainTitleSecond;

  /// veri girişi için Controller
  final TextEditingController ikinciDilController = TextEditingController();
  final TextEditingController birinciDilController = TextEditingController();

  Future<void> initializeFirestore() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('kelimeler')
        .orderBy("sirpca")
        .withConverter<FsWords>(
          fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
          toFirestore: (word, _) => word.toJson(),
        );
    collection = collectionRef as CollectionReference<FsWords>;
  }

  /// her çalışmada JSON verisini güncel tutsun
  static Future<void> jsonInit() async {
    WordService wordService = WordService();
    await generateAndWriteJson(wordService);
  }

  /// Başlangıç düzenlemesi
  @override
  void initState() {
    super.initState();

    /// Firestore verisinden JSON dosya oluşturup yazıyoruz
    _wordService = WordService();
    jsonInit();
    initializeFirestore();
  }

  /// kelime listesi oluşturma
  Widget buildWordList() {
    final queryForSerbian = FirebaseFirestore.instance
        .collection('kelimeler')
        .orderBy("sirpca")
        .where("sirpca", isGreaterThanOrEqualTo: aramaKelimesi)
        .where("sirpca", isLessThanOrEqualTo: '$aramaKelimesi\uf8ff')
        .withConverter<FsWords>(
          fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
          toFirestore: (word, _) => word.toJson(),
        );

    final queryForTurkish = FirebaseFirestore.instance
        .collection('kelimeler')
        .orderBy("turkce")
        .where("turkce", isGreaterThanOrEqualTo: aramaKelimesi)
        .where("turkce", isLessThanOrEqualTo: '$aramaKelimesi\uf8ff')
        .withConverter<FsWords>(
          fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
          toFirestore: (word, _) => word.toJson(),
        );

    return FutureBuilder<List<QuerySnapshot<FsWords>>>(
      future: Future.wait([queryForSerbian.get(), queryForTurkish.get()]),
      builder: (context, AsyncSnapshot<List<QuerySnapshot<FsWords>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Transform.scale(
            alignment: Alignment.center,
            scale: 0.30,
            child: const CircularProgressIndicator(
              backgroundColor: Colors.red,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 6,
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(
              'Hata: ${snapshot.error}'); // Hata durumunda hata mesajı göster
        }
        return WordListBuilder(
            snapshot: snapshot.data!, isListView: isListView);
      },
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
        resizeToAvoidBottomInset: false,
        appBar: HomeCustomAppBar(
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
        ),
        body: showBody(context),
        drawer: buildDrawer(context),
        floatingActionButton: buildFloatingActionButton(
          onPressed: () => openWordBox(context: context),
        ),
        bottomSheet: const BottomSheetWidget(),
      ),
    );
  }

  /// Sayfa düzeni burada oluşuyor.
  Column showBody(BuildContext context) {
    final ScrollController controller;

    return Column(
      children: [
        /// burada sayfa başlığı ve
        /// dil değişimi, görünüm ayarı var
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: buildLanguageSelector(context: context),
        ),

        /// burada sıralı kelime listesi gelsin

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,
          child: buildWordList(),
        ),
      ],
    );
  }

  /// dil değişimi burada yapılıyor
  Widget buildLanguageSelector({
    required BuildContext context,
  }) {
    return LanguageSelector(
      firstLanguageCode: firstLanguageCode,
      firstLanguageText: firstLanguageText,
      secondLanguageCode: secondLanguageCode,
      secondLanguageText: secondLanguageText,
      isListView: isListView,
      onIconPressed: () {
        setState(() {
          Provider.of<IconProvider>(context, listen: false).changeIcon();
          isListView = !isListView;
        });
      },
      onLanguageChange: () {
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
    );
  }

  Future<void> openWordBox({
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
  }

}
