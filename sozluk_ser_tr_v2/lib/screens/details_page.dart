/// <----- details_page.dart ----->
/// Burada kelimeleri tek tek gösteriyoruz
library;

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../constants/app_constants/drawer_constants.dart';
import '../models/fs_words.dart';
import '../screens/details_page_parts/button_helper.dart';
import '../services/providers/theme_provider.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import 'details_page_parts/details_card.dart';
import 'home_page_parts/drawer_items.dart';

class DetailsPage extends StatefulWidget {
  final String firstLanguageText;
  final String secondLanguageText;
  final String displayedLanguage;
  final String displayedTranslation;

  const DetailsPage({
    super.key,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.displayedLanguage,
    required this.displayedTranslation,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final CollectionReference words =
      FirebaseFirestore.instance.collection("kelimeler");
  QuerySnapshot<Map<String, dynamic>>? _querySnapshot;
  late List<FsWords> _wordList = []; // Kelimelerin listesi
  late int _currentIndex = 0; // Başlangıçta _currentIndex 0 olacak
  late FsWords word;
  late ThemeProvider themeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
    //   var route = ModalRoute.of(context);
    //   if(route != null && route.settings.arguments != null) {
    //     word = route.settings.arguments as FsWords;
    _loadWordList();
    //   }
  }

  @override
  void initState() {
    super.initState();
    word = FsWords(
      wordId: 'initialId',
      sirpca: 'initialSirpca',
      turkce: 'initialTurkce',
      userEmail: 'initialEmail',
    );
  }

  /// Tüm kelimelerin listesi
  Future<void> _loadWordList() async {
    try {
      /// Firestore 'dan verileri alırken offline veri kullanımını etkinleştirin
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("kelimeler")

              /// Kelimeleri alfabetik sıraya göre sırala
              .orderBy(
                  widget.firstLanguageText == anaDil ? 'turkce' : 'sirpca')
              .get(
                /// Firestore 'dan alınan verilerin daha önce indirilmiş verilere
                /// karşı güncellenip güncellenmediğini kontrol et
                const GetOptions(source: Source.cache),
              );

      setState(() {
        _wordList = querySnapshot.docs
            .map((doc) => FsWords.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList();
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _wordList = [];
      });
    }
  }

  /// önceki kelime
  void _loadPreviousWord() {
    log("_wordList : $_wordList");
    // if (_currentIndex > 0) {
    //   setState(() {
    //     _currentIndex--;
    //   });
    //   log("Önceki kelime: ${_wordList[_currentIndex - 1].turkce} - ${_wordList[_currentIndex - 1].sirpca}");
    // } else {
    //   log("Bu ilk kelime, önceki kelime yok.");
    // }
  }

  /// Geçici liste yazdırma
  /// daha sonra silinebilir.
  // void printWordList() {
  //   if (_wordList.isEmpty) {
  //     print("Liste boş");
  //   } else {
  //     _wordList.forEach((word) {
  //       widget.firstLanguageText == ikinciDil
  //           ? print(
  //               "Word ID: ${word.wordId}, Turkce: ${word.turkce}, Sirpca: ${word.sirpca}, User Email: ${word.userEmail}")
  //           : print(
  //               "Word ID: ${word.wordId}, Sirpca: ${word.sirpca}, Turkce: ${word.turkce}, User Email: ${word.userEmail}");
  //     });
  //   }
  // }

  /// önceki-sonraki kelimelere butonlar
  /// aracılığı ile gidilmesi içindir
  Padding buildDetailsButton() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildElevatedButton(
            onPressed: () {
              log("Önceki kelime");
              log("index : $_currentIndex");
              log("Önceki kelime: ${_wordList[_currentIndex].turkce} - ${_wordList[_currentIndex].sirpca}");
              // log("Word List : ${_wordList.toString()}");
              // log("Word List (5) : ${_wordList[5].toString()}");
              //  _loadPreviousWord();
              if (_currentIndex > 0) {
                _currentIndex--;
                _loadPreviousWord();
              } else {
                log("Bu ilk kelime, önceki kelime yok.");
              }
            },
            icon: Icons.arrow_left,
            iconSize: 50,
          ),
          const Expanded(
            child: SizedBox(width: 100),
          ),
          buildElevatedButton(
            onPressed: () {
              log("sonraki kelime");
            },
            icon: Icons.arrow_right,
            iconSize: 50,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarDetailsTitle,
      ),
      drawer: buildDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // buildCarouselSlider(context),
            DetailsCard(
              firstLanguageText: widget.firstLanguageText,
              secondLanguageText: widget.secondLanguageText,
              displayedLanguage: widget.displayedLanguage,
              displayedTranslation: widget.displayedTranslation,
              themeProvider: themeProvider,
            ),
            buildDetailsButton(),
          ],
        ),
      ),
    );
  }

  /// kelimelerin sağa-sola sürüklenmesi için slider
  // CarouselSlider buildCarouselSlider(BuildContext context) {
  //   if (_querySnapshot == null || _querySnapshot!.docs.isEmpty) {
  //     return CarouselSlider(
  //       /// hata varsa burası uygulanacaktır
  //       items: const [Text("Veri bulunamadı")],
  //       options: CarouselOptions(),
  //     );
  //   } else {
  //     return CarouselSlider(
  //       options: CarouselOptions(
  //         height: MediaQuery.of(context).size.height * 0.65,
  //         aspectRatio: 16 / 9,
  //         enlargeCenterPage: true,
  //         autoPlay: false,
  //
  //         /// Otomatik oynatma kapalı
  //         enableInfiniteScroll: false,
  //
  //         /// Sonsuz kaydırma kapalı
  //         onPageChanged: (index, reason) {
  //           if (_querySnapshot == null || _querySnapshot!.docs.isEmpty) {
  //             /// Hata işlemleri
  //             print("Hata: _querySnapshot başlatılmamış.");
  //           } else {
  //             /// Sayfa değişimini dinleyelim
  //             if (index > _currentIndex) {
  //               _loadNextWord();
  //             } else if (index < _currentIndex) {
  //               _loadPreviousWord();
  //             }
  //           }
  //         },
  //       ),
  //       items: _querySnapshot?.docs.map((doc) {
  //         return DetailsCard(
  //           word: word,
  //           themeProvider: themeProvider,
  //         );
  //       }).toList(),
  //     );
  //   }
  // }
}