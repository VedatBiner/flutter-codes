/// <----- details_page.dart ----->
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../models/words.dart';
import '../screens/details_page_parts/button_helper.dart';
import '../screens/details_page_parts/flag_row.dart';
import '../services/theme_provider.dart';
import '../utils/mesaj_helper.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import 'home_page_parts/drawer_items.dart';

class DetailsPage extends StatefulWidget {
  Words word;

  DetailsPage({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final CollectionReference words =
      FirebaseFirestore.instance.collection("kelimeler");
  QuerySnapshot<Map<String, dynamic>>? _querySnapshot;
  late int _currentIndex;
  late ThemeProvider themeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _loadWordList();
  }

  /// Tüm kelimelerin listesi
  Future<void> _loadWordList() async {
    try {
      final querySnapshot = await words.orderBy("sirpca").get()
          as QuerySnapshot<Map<String, dynamic>>; // Değişiklik burada
      setState(() {
        _querySnapshot = querySnapshot;
        _currentIndex = _querySnapshot!.docs.indexWhere(
          (doc) => doc.id == widget.word.wordId,
        );
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _querySnapshot = null;
      });
    }
  }

  /// Önceki kelime
  Future<void> _loadPreviousWord() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _updateCurrentWord();
      });
    } else {
      MessageHelper.showSnackBar(
        context,
        message: "Bu ilk kelime, önceki kelime yok.",
      );
    }
  }

  /// Sonraki kelime
  Future<void> _loadNextWord() async {
    if (_currentIndex < _querySnapshot!.size - 1) {
      setState(() {
        _currentIndex++;
        _updateCurrentWord();
      });
    } else {
      MessageHelper.showSnackBar(
        context,
        message: "Bu son kelime, sonraki kelime yok.",
      );
    }
  }

  /// Kelimelerin güncellenmesi
  Future<void> _updateCurrentWord() async {
    setState(() {
      DocumentSnapshot<Map<String, dynamic>> currentDocumentSnapshot =
          _querySnapshot!.docs[_currentIndex];
      widget.word = Words.fromFirestore(currentDocumentSnapshot);
    });
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
            buildCarouselSlider(context),
            buildDetailsButton(),
          ],
        ),
      ),
    );
  }

  /// kelimelerin sağa-sola sürüklenmesi için slider
  CarouselSlider buildCarouselSlider(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.65,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        autoPlay: false, // Otomatik oynatma kapalı
        enableInfiniteScroll: false, // Sonsuz kaydırma kapalı
        onPageChanged: (index, reason) {
          if (_querySnapshot == null || _querySnapshot!.docs.isEmpty) {
            /// Hata işlemleri
            print("Hata: _querySnapshot başlatılmamış.");
          } else {
            /// Sayfa değişimini dinleyelim
            if (index > _currentIndex) {
              _loadNextWord();
            } else if (index < _currentIndex) {
              _loadPreviousWord();
            }
          }
        },
      ),
      items: _querySnapshot?.docs.map((doc) {
        return buildDetailsCard(context);
      }).toList(),
    );
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
            onPressed: () => _loadPreviousWord(),
            icon: Icons.arrow_left,
            iconSize: 50,
          ),
          const Expanded(
            child: SizedBox(width: 100),
          ),
          buildElevatedButton(
            onPressed: () => _loadNextWord(),
            icon: Icons.arrow_right,
            iconSize: 50,
          ),
        ],
      ),
    );
  }

  /// Kelime kartı
  Card buildDetailsCard(BuildContext context) {
    return Card(
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
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFlagRow(
                'RS',
                widget.word.sirpca,
                detailTextRed,
              ),
              const SizedBox(height: 40),
              buildFlagRow(
                'TR',
                widget.word.turkce,
                detailTextBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
