/// <----- details_page.dart ----->
/// Burada kelimeleri tek tek gösteriyoruz
/// Bu kelimeler bir liste olarak geldiği için
/// Firestore veri tabanına erişim yapılmıyor.
library;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
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
  final List<FsWords> wordList;
  final FsWords initialWord;
  final bool language;

  const DetailsPage({
    super.key,
    required this.wordList,
    required this.initialWord,
    required this.language,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final List<FsWords> _wordList = []; // Kelimelerin listesi
  late int _currentIndex;
  late FsWords word;
  late ThemeProvider themeProvider;

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

    /// seçilip, aktarılan kelime
    word = widget.initialWord;

    /// seçilen kelimenin indeksi
    int selectedWordIndex = findIndex(word.sirpca);
    if (selectedWordIndex != -1) {
      log("Seçilen kelimenin indeksi: $selectedWordIndex");
    } else {
      log("Seçilen kelime listede bulunamadı.");
    }
    _currentIndex = selectedWordIndex;
  }

  /// ilk veya son kelimeye ulaşılınca çıkacak mesaj
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: dikkatText,
        ),
      ),
    );
  }

  /// index bulan metod
  int findIndex(String selectedWord) {
    int index = -1;
    for (int i = 0; i < widget.wordList.length; i++) {
      if (widget.wordList[i].sirpca == selectedWord) {
        index = i;

        /// Kelime bulundu, döngüyü sonlandır
        break;
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
            onPressed: _onPreviousWordPressed,
            icon: Icons.arrow_left,
            iconSize: 50,
          ),
          const Expanded(
            child: SizedBox(width: 100),
          ),
          buildElevatedButton(
            onPressed: _onNextWordPressed,
            icon: Icons.arrow_right,
            iconSize: 50,
          ),
        ],
      ),
    );
  }

  /// Bir önceki kelimeye gidelim
  void _onPreviousWordPressed() {
    if (_currentIndex > 0) {
      setState(
        () {
          _currentIndex--;
          word = _wordList[_currentIndex]; // Önceki kelimeyi yükle
        },
      );
    } else {
      log("Bu ilk kelime");
      _showMessage(ilkKelimeMsg);
    }
  }

  /// Bir sonraki kelimeye gidelim
  void _onNextWordPressed() {
    if (_currentIndex < _wordList.length - 1) {
      setState(
        () {
          _currentIndex++;

          /// Sonraki kelimeyi yükle
          word = _wordList[_currentIndex];
        },
      );
    } else {
      log("Bu son kelime");
      _showMessage(sonKelimeMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarDetailsTitle,
      ),
      drawer: buildDrawer(context),
      body: showCarousel(context),
    );
  }

  /// Carousel Slider burada oluşturuluyor
  Widget showCarousel(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              /// Kart yüksekliği
              height: MediaQuery.of(context).size.height * 0.7,
              enlargeCenterPage: true,

              /// sonsuz kaydırma devre dışı
              enableInfiniteScroll: false,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                setState(
                  () {
                    if (index < _currentIndex) {
                      /// sola kaydırma
                      _currentIndex =
                          _currentIndex - 1.clamp(0, _wordList.length - 1);
                    } else if (index > _currentIndex) {
                      /// sağa kaydırma
                      _currentIndex =
                          _currentIndex + 1.clamp(0, _wordList.length - 1);
                    } else {
                      _currentIndex = index;
                    }

                    /// İlk ve son kelimeye ulaşıldıysa mesaj ver
                    if (_currentIndex == 0) {
                      _showMessage(ilkKelimeMsg);
                    } else if (_currentIndex == _wordList.length - 1) {
                      _showMessage(sonKelimeMsg);
                    }

                    log("Index : $index");
                    log("Current Index : $_currentIndex");
                  },
                );
              },
            ),
            items: _wordList.map(
              (word) {
                return buildCardShow(context, word);
              },
            ).toList(),
          ),
        ),
        buildDetailsButton(),
      ],
    );
  }

  /// kelimeleri burada tek tek Card olarak gösteriyoruz.
  Widget buildCardShow(BuildContext context, FsWords word) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// burada tek kelime için detaylı
        /// Card görünümü oluşturuluyor
        Expanded(
          child: Center(
            child: Card(
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
                  height: MediaQuery.of(context).size.width * 0.80,
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
          ),
        ),
      ],
    );
  }
}
