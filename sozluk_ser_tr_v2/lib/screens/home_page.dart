/// <----- home_page.dart ----->
/// --------------------------------------------------
/// 03-c home_page.dart
/// Bu sayfa bütün kodun merkezini oluşturuyor.
/// çok sık güncelleme yapılıyor.
/// Burada kelimeler Firebase Firestore 'dan pagination
/// yöntemi ile çekiliyor. Liste ve Card görünümünde
/// gösteriliyor. Yeni kelime ekleme, silme ve düzeltme
/// işlemleri yapılıyor. Ayrıca kelimeler tek tek card
/// olarak da görüntülenebiliyor.
/// --------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/color_constants.dart';
import '../constants/app_constants/constants.dart';
import '../constants/app_constants/drawer_constants.dart';
import '../models/fs_words.dart';
import '../models/language_params.dart';
import '../services/firebase_services/auth_services.dart';
import '../services/firebase_services/firestore_services.dart';
import '../services/providers/theme_provider.dart';
import '../services/word_service.dart';
import '../services/providers/icon_provider.dart';
import '../utils/snackbar_helper.dart';
import 'home_page_parts/bottom_sheet.dart';
import 'home_page_parts/drawer_items.dart';
import 'home_page_parts/home_app_bar.dart';
import 'home_page_parts/language_selector.dart';
import 'home_page_parts/add_word_box.dart';
import 'home_page_parts/word_list_builder.dart';

late CollectionReference<FsWords> collection;
late Query<FsWords> query;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<QuerySnapshot<FsWords>>> _wordListFuture;
  late final WordService _wordService = WordService();
  final email = MyAuthService.currentUserEmail;

  /// Firestore servisi için değişken oluşturalım
  final FirestoreService _firestoreService = FirestoreService();

  bool isListView = false;
  bool aramaYapiliyorMu = false;

  String aramaKelimesi = "";

  /// Başlangıç App Bar
  String appBarTitle = appBarMainTitleSecond;

  /// başlangıç dili Sırpça olacak
  String firstLanguageCode = secondCountry; // İlk dil kodu
  String firstLanguageText = yardimciDil; // İlk dil metni
  String secondLanguageCode = firstCountry; // İkinci dil kodu
  String secondLanguageText = anaDil; // İkinci dil metni

  /// ilk başta Sırpça - Türkçe
  bool language = true;

  /// Burada başlangıç dili Sırpça geldiği için
  /// koleksiyon okunduğu zaman
  /// kelimeler sırpça 'ya göre sıralı olarak
  /// pagination ile listelenir.
  Future<void> _initializeFirestore() async {
    final collectionRef = FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy(fsYardimciDil)
        .withConverter<FsWords>(
          fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
          toFirestore: (word, _) => word.toJson(),
        );
    collection = collectionRef as CollectionReference<FsWords>;
  }

  /// Başlangıç düzenlemesi
  @override
  void initState() {
    super.initState();

    /// Firestore verisinden JSON dosya oluşturup yazıyoruz
    _wordService.jsonInit();

    /// Firestore veri yapısı listelenir
    _initializeFirestore();
    _wordListFuture = _fetchWordList();
  }

  /// kelime listesi sorgulama
  Query<FsWords> _buildQuery(String orderByField) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy(orderByField)
        .where(orderByField, isGreaterThanOrEqualTo: aramaKelimesi)
        .where(orderByField, isLessThanOrEqualTo: '$aramaKelimesi\uf8ff')
        .withConverter<FsWords>(
          fromFirestore: (snapshot, _) => FsWords.fromDocument(snapshot),
          toFirestore: (word, _) => word.toJson(),
        );
  }

  /// kelime listesi oluşturma
  /// Burada hem sırpça hem de Türkçe iki liste oluşturuluyor
  Widget _buildWordList() {
    /// Sırpça sorgu listesi
    final queryForSerbian = _buildQuery(fsYardimciDil);

    /// Türkçe sorgu listesi
    final queryForTurkish = _buildQuery(fsAnaDil);

    return FutureBuilder<List<QuerySnapshot<FsWords>>>(
      future: Future.wait([queryForSerbian.get(), queryForTurkish.get()]),
      builder: (context, AsyncSnapshot<List<QuerySnapshot<FsWords>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Transform.scale(
            alignment: Alignment.center,
            scale: 0.90,
            child: const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 6,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(
            'Hata: ${snapshot.error}',
          ); // Hata durumunda hata mesajı göster
        }

        /// languageParams nesnesini oluşturun
        final languageParams = Provider.of<LanguageParams>(context);

        if (snapshot.hasData) {
          List<FsWords> allWords = [];
          for (var querySnapshot in snapshot.data!) {
            allWords
                .addAll(querySnapshot.docs.map((doc) => doc.data()).toList());
          }
          return WordListBuilder(
            snapshot: snapshot.data!,
            isListView: isListView,
            languageParams: languageParams,
            language: language,
            mergedResults: allWords,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  /// ekrana listelenecek yapı burada oluşturuluyor
  Future<List<QuerySnapshot<FsWords>>> _fetchWordList() async {
    final queryForSerbian = _buildQuery(fsYardimciDil);
    final queryForTurkish = _buildQuery(fsAnaDil);

    const options = GetOptions(source: Source.cache);
    return language == true
        ? await Future.wait(
            [
              queryForSerbian.get(options),
              queryForTurkish.get(options),
            ],
          )
        : await Future.wait(
            [
              queryForTurkish.get(options),
              queryForSerbian.get(options),
            ],
          );
  }

  /// ana kodumuz bu şekilde
  @override
  Widget build(BuildContext context) {
    /// burada Splash_page.dart sayfasına
    /// geri dönüşü engelledik.
    final languageParams = Provider.of<LanguageParams>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildHomeCustomAppBar(),
        body: showBody(context, languageParams),
        drawer: buildDrawer(context),
        floatingActionButton: buildFloatingActionButton(context),
        bottomSheet: const BottomSheetWidget(),
      ),
    );
  }

  /// arama kutusunu içeren Appbar burada
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

  /// Sayfa düzeni burada oluşuyor.
  Column showBody(BuildContext context, LanguageParams languageParams) {
    return Column(
      children: [
        /// burada sayfa başlığı ve
        /// dil değişimi, görünüm ayarı var
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: buildLanguageSelector(
            context: context,
            languageParams: languageParams,
          ),
        ),

        /// burada sıralı kelime listesi gelsin
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,

          /// kelimeleri listeleyen metod
          child: _buildWordList(),
        ),
      ],
    );
  }

  /// dil değişimi burada yapılıyor
  Widget buildLanguageSelector({
    required BuildContext context,
    required LanguageParams languageParams,
  }) {
    return LanguageSelector(
      firstLanguageCode: languageParams.secondLanguageCode,
      firstLanguageText: languageParams.secondLanguageText,
      secondLanguageCode: languageParams.firstLanguageCode,
      secondLanguageText: languageParams.firstLanguageText,
      isListView: isListView,
      language: language,
      onIconPressed: () {
        setState(() {
          Provider.of<IconProvider>(context, listen: false).changeIcon();
          isListView = !isListView;
        });
      },
      onLanguageChange: (bool newLanguage) {
        setState(
          () {
            language = newLanguage;
            if (language) {
              firstLanguageCode = secondCountry;
              firstLanguageText = yardimciDil;
              secondLanguageCode = firstCountry;
              secondLanguageText = anaDil;
              appBarTitle = appBarMainTitleSecond;
            } else {
              firstLanguageCode = firstCountry;
              firstLanguageText = anaDil;
              secondLanguageCode = secondCountry;
              secondLanguageText = yardimciDil;
              appBarTitle = appBarMainTitleFirst;
            }
          },
        );
      },
    );
  }

  /// FAB ile kelime ekleme işlemi burada yapılıyor
  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    final TextEditingController firstLanguageController =
        TextEditingController();
    final TextEditingController secondLanguageController =
        TextEditingController();

    /// theme kontrolü
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FloatingActionButton(
      backgroundColor: themeProvider.isDarkMode ? Colors.green.shade900 : drawerColor,
      foregroundColor: menuColor,
      onPressed: () {
        log("Kelime ekleme seçildi");

        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return buildCenter(
              firstLanguageController,
              secondLanguageController,
              email,
              language,
              context,
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }

  /// Yeni kelime ekleme kutusu buradan çıkıyor
  Center buildCenter(
    TextEditingController firstLanguageController,
    TextEditingController secondLanguageController,
    email,
    language,
    BuildContext context,
  ) {
    TextEditingController tempLanguageController;
    String tempLanguageText;

    if (language) {
      tempLanguageController = secondLanguageController;
      firstLanguageController = secondLanguageController;
      firstLanguageText = secondLanguageText;
      secondLanguageController = firstLanguageController;
      secondLanguageText = firstLanguageText;
    } else {
      tempLanguageController = firstLanguageController;
      tempLanguageText = firstLanguageText;
      firstLanguageController = secondLanguageController;
      firstLanguageText = secondLanguageText;
      secondLanguageController = tempLanguageController;
      secondLanguageText = tempLanguageText;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          borderRadius: BorderRadius.circular(16.0),
          child: AddWordBox(
            firstLanguageText: yardimciDil,
            secondLanguageText: anaDil,
            currentUserEmail: email,
            language: language,
            onWordAdded: (
              String firstLang,
              String secondLang,
              String email,
            ) async {
              await _firestoreService.addWord(
                context,
                language == true ? firstLang : secondLang,
                language == true ? secondLang : firstLang,
                email,
              );
              setState(
                () {
                  _wordListFuture = _fetchWordList();
                  var message = addMsg;
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildSnackBar(
                      firstLang,
                      message,
                      MyAuthService.currentUserEmail,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
