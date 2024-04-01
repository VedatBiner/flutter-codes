import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../models/fs_words.dart';
import '../services/app_routes.dart';
import '../services/icon_provider.dart';
import '../services/theme_provider.dart';
import '../services/word_service.dart';
import '../utils/generate_json.dart';
import 'home_page_parts/drawer_items_new.dart';
import 'home_page_parts/fab_helper.dart';
import 'home_page_parts/home_app_bar.dart';
import 'home_page_parts/showflag_widget.dart';

late CollectionReference<FsWords> collection;
late Query<FsWords> query;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// JSON dosya oluşturup güncel tutalım
  late WordService _wordService;

  bool isListView = false;
  bool aramaYapiliyorMu = false;

  String aramaKelimesi = "";

  /// başlangıç dili Sırpça olacak
  String firstLanguageCode = 'RS'; // İlk dil kodu
  String firstLanguageText = 'Sırpça'; // İlk dil metni
  String secondLanguageCode = 'TR'; // İkinci dil kodu
  String secondLanguageText = 'Türkçe'; // İkinci dil metni
  String appBarTitle = appBarMainTitleSecond;

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
    query = FirebaseFirestore.instance
        .collection('kelimeler')
        .orderBy("sirpca")
        .withConverter<FsWords>(
          fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
          toFirestore: (word, _) => word.toJson(),
        );

    return FirestoreListView<FsWords>(
      query: query ?? collection,
      pageSize: 50,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, snapshot) {
        final word = snapshot.data();
        return buildWordTile(word: word);
      },
    );
  }

  /// kelime listesi Card Görünümü
  Widget buildWordTile({required FsWords word}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Widget wordWidget;
    if (isListView) {
      /// Liste görünümü
      wordWidget = ListTile(
        contentPadding: EdgeInsets.zero,
        title: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    firstLanguageCode == 'RS'
                        ? word.sirpca ?? ""
                        : word.turkce ?? "",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? cardDarkModeText1
                          : cardLightModeText1,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    secondLanguageCode == 'TR'
                        ? word.turkce ?? ""
                        : word.sirpca ?? "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? cardDarkModeText2
                          : cardLightModeText2,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: themeProvider.isDarkMode ? Colors.white60 : Colors.black45,
            ),
          ],
        ),
      );
    } else {
      /// Card Görünümü
      wordWidget = Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          shadowColor: Colors.green[200],
          color: themeProvider.isDarkMode ? cardDarkMode : cardLightMode,
          child: InkWell(
            onTap: () async {
              await Navigator.pushNamed(
                context,
                AppRoute.details,
                arguments: word,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstLanguageCode == 'RS'
                              ? word.sirpca ?? ""
                              : word.turkce ?? "",
                          style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? cardDarkModeText1
                                : cardLightModeText1,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: themeProvider.isDarkMode
                              ? Colors.white60
                              : Colors.black45,
                        ),
                        Text(
                          secondLanguageCode == 'TR'
                              ? word.turkce ?? ""
                              : word.sirpca ?? "",
                          style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? cardDarkModeText2
                                : cardLightModeText2,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        tooltip: "kelime düzelt",
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                        tooltip: "kelime sil",
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return wordWidget;
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
        // appBar: buildHomeCustomAppBar(),
        appBar: AppBar(),
        body: showBody(context),

        drawer: buildDrawer(context),
        floatingActionButton: buildFloatingActionButton(onPressed: () {}

            /// onPressed: () => openWordBox(context: context),
            ),
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

        /// Burada kelimeler listeleniyor
        // Expanded(
        //   child: SizedBox(
        //     /// Card / Liste görünümü için boyutlar
        //     height: MediaQuery.of(context).size.height * 0.89,
        //     child: buildStreamBuilderList(),
        //   ),
        // ),

        /// Burada toplam kelime sayısı veriliyor
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.05,
        //   child: buildStreamBuilderFooter(context),
        // ),

        /// burada sıralı kelime listesi gelsin
        ///
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          child: buildWordList(),
        ),
      ],
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

  /// dil değişimi burada yapılıyor
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
  }
}
