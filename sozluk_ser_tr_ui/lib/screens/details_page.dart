/// <----- details_page_ser_tr.dart ----->
/// Burada kelimeleri tek tek gösteriyoruz
library;

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../models/fs_words.dart';
import '../screens/details_page_parts/button_helper.dart';
import '../services/theme_provider.dart';
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
  late int _currentIndex;
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
    // word = widget.initialWord;
    // initState içinde word değişkenini başlatıyoruz
    word = FsWords(
      wordId: 'initialId',
      sirpca: 'initialSirpca',
      turkce: 'initialTurkce',
      userEmail: 'initialEmail',
    );
    _loadWordList();
  }

  /// Tüm kelimelerin listesi
  Future<void> _loadWordList() async {
    try {
      final querySnapshot = await FsWords.orderBy(
              widget.firstLanguageText == birinciDil ? 'turkce' : 'sirpca')
          as QuerySnapshot<Map<String, dynamic>>;
      setState(() {
        _querySnapshot = querySnapshot;
        _currentIndex = _querySnapshot!.docs.indexWhere(
          (doc) => doc.id == word.wordId,
        );
      });
      printWordList();
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _querySnapshot = null;
      });
    }
  }

  /// Geçici liste yazdırma
  void printWordList() {
    if (_querySnapshot == null || _querySnapshot!.docs.isEmpty) {
      print("Liste boş");
    } else {
      for (var doc in _querySnapshot!.docs) {
        var word = FsWords.fromFirestore(doc);
        print(
            "Word ID: ${word.wordId}, Sirpca: ${word.sirpca}, Turkce: ${word.turkce}, User Email: ${word.userEmail}");
      }
    }
  }

  /// Önceki kelime
  // Future<void> _loadPreviousWord() async {
  //   if (_currentIndex > 0) {
  //     setState(() {
  //       _currentIndex--;
  //       _updateCurrentWord();
  //     });
  //   } else {
  //     MessageHelper.showSnackBar(
  //       context,
  //       message: "Bu ilk kelime, önceki kelime yok.",
  //     );
  //   }
  // }

  /// Sonraki kelime
  // Future<void> _loadNextWord() async {
  //   if (_currentIndex < _querySnapshot!.size - 1) {
  //     setState(() {
  //       _currentIndex++;
  //       _updateCurrentWord();
  //     });
  //   } else {
  //     MessageHelper.showSnackBar(
  //       context,
  //       message: "Bu son kelime, sonraki kelime yok.",
  //     );
  //   }
  // }

  /// Kelimelerin güncellenmesi
  // Future<void> _updateCurrentWord() async {
  //   setState(() {
  //     DocumentSnapshot<Map<String, dynamic>> currentDocumentSnapshot =
  //     _querySnapshot!.docs[_currentIndex];
  //     word = FsWords.fromFirestore(currentDocumentSnapshot);
  //   });
  // }

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
            }, //_loadPreviousWord(),
            icon: Icons.arrow_left,
            iconSize: 50,
          ),
          const Expanded(
            child: SizedBox(width: 100),
          ),
          buildElevatedButton(
            onPressed: () {
              log("sonraki kelime");
            }, // _loadNextWord(),
            icon: Icons.arrow_right,
            iconSize: 50,
          ),
        ],
      ),
    );
  }
}
