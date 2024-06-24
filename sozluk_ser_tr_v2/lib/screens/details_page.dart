/// <----- details_page.dart ----->
/// Burada kelimeleri tek tek gösteriyoruz
library;

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sozluk_ser_tr_v2/screens/details_page_parts/flag_row.dart';

import '../constants/app_constants/color_constants.dart';
import '../constants/app_constants/constants.dart';
import '../constants/app_constants/drawer_constants.dart';
import '../models/fs_words.dart';
import '../screens/details_page_parts/button_helper.dart';
import '../services/providers/theme_provider.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import 'home_page_parts/drawer_items.dart';

class DetailsPage extends StatefulWidget {
  final String firstLanguageText;
  final String secondLanguageText;
  final String displayedLanguage;
  final String displayedTranslation;
  final List<FsWords> wordList;
  final FsWords initialWord;
  final bool language;

  const DetailsPage({
    super.key,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.displayedLanguage,
    required this.displayedTranslation,
    required this.wordList,
    required this.initialWord,
    required this.language,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final CollectionReference words =
      FirebaseFirestore.instance.collection("kelimeler");
  QuerySnapshot<Map<String, dynamic>>? _querySnapshot;
  late final List<FsWords> _wordList = []; // Kelimelerin listesi
  late int _currentIndex;
  late FsWords word;
  late ThemeProvider themeProvider;
  // /// Drawer 'ın oluşturulup oluşturulmadığını kontrol
  // /// etmek için bir değişken
  // late bool _drawerBuilt = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.wordList.indexOf(widget.initialWord);
    _wordList.addAll(widget.wordList);
    word = widget.initialWord;
    // _currentIndex = widget.wordList.indexOf(word);
    log("Seçilen kelime: ${word.sirpca} - ${word.turkce}");
    int selectedWordIndex = findIndex(word.sirpca);
    if (selectedWordIndex != -1) {
      log("Seçilen kelimenin indeksi: $selectedWordIndex");
    } else {
      log("Seçilen kelime listede bulunamadı.");
    }
    log("---------------------------------------");
    log("Seçilen kelime : ${word.sirpca} - ${word.turkce}");
    log("seçilen kelimenin indeksi: $selectedWordIndex");
    _currentIndex = selectedWordIndex;
    log("===> 15-details_page.dart dosyası çalıştı. >>>>>>>");
    log("------------------------------------------------------------");
    log("language : ${widget.language}");
  }

  /// index bulan metod
  int findIndex(String selectedWord) {
    int index = -1;
    for (int i = 0; i < widget.wordList.length; i++) {
      if (widget.wordList[i].sirpca == selectedWord) {
        index = i;
        break; // Kelime bulundu, döngüyü sonlandır
      }
    }
    return index;
  }

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
              if (_currentIndex > 0) {
                setState(() {
                  _currentIndex--;
                  word = _wordList[_currentIndex]; // Önceki kelimeyi yükle
                  log("Önceki kelime: ${word.sirpca} - ${word.turkce}");
                  log("index : $_currentIndex");
                });
              } else {
                log("Bu ilk kelime");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bu ilk kelime!"),
                  ),
                );
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
              if (_currentIndex < _wordList.length - 1) {
                setState(() {
                  _currentIndex++;
                  word = _wordList[_currentIndex]; // Sonraki kelimeyi yükle
                  log("Sonraki kelime: ${word.sirpca} - ${word.turkce}");
                  log("index : $_currentIndex");
                });
              } else {
                log("Bu son kelime");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bu son kelime!"),
                  ),
                );
              }
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
      body: buildCardShow(context),
    );
  }

  Center buildCardShow(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// burada tek kelime için detaylı
          /// Card görünümü oluşturuluyor
          Card(
            elevation: 10.0,
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shadowColor: Colors.blue[200],
            color: themeProvider.isDarkMode ? cardDarkMode : cardLightMode,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// burada dil seçimine göre kelimeler
                    /// yer değiştiriyorlar.
                    widget.language == true
                        ? buildFlagRow(
                            secondCountry,
                            _wordList[_currentIndex].sirpca,
                            detailTextRed,
                          )
                        : buildFlagRow(
                            firstCountry,
                            _wordList[_currentIndex].turkce,
                            detailTextRed,
                          ),
                    const Divider(),
                    widget.language == true
                        ? buildFlagRow(
                            firstCountry,
                            _wordList[_currentIndex].turkce,
                            detailTextBlue,
                          )
                        : buildFlagRow(
                            secondCountry,
                            _wordList[_currentIndex].sirpca,
                            detailTextBlue,
                          ),
                  ],
                ),
              ),
            ),
          ),
          buildDetailsButton(),
        ],
      ),
    );
  }
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
