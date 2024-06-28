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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../constants/app_constants/drawer_constants.dart';
import '../models/fs_words.dart';
import '../models/language_params.dart';
import '../services/firebase_services/auth_services.dart';
import '../services/firebase_services/firestore_services.dart';
import '../services/word_service.dart';
import 'home_page_parts/bottom_sheet.dart';
import 'home_page_parts/build_fab_button.dart';
import 'home_page_parts/build_show_body.dart';
import 'home_page_parts/drawer_items.dart';
import 'home_page_parts/home_app_bar.dart';
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

  final ValueNotifier<bool> _refreshNotifier = ValueNotifier(false);

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
    collection = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<FsWords>(
          fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
          toFirestore: (word, _) => word.toJson(),
        );
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
        .where(
          orderByField,
          isGreaterThanOrEqualTo: aramaKelimesi,
        )
        .where(
          orderByField,
          isLessThanOrEqualTo: '$aramaKelimesi\uf8ff',
        )
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
          return ValueListenableBuilder(
            valueListenable: _refreshNotifier,
            builder: (
              context,
              refresh,
              child,
            ) {
              return WordListBuilder(
                snapshot: snapshot.data!,
                isListView: isListView,
                languageParams: languageParams,
                language: language,
                mergedResults: allWords,
                refreshNotifier: _refreshNotifier,

                /// Callback ekledik
                onRefresh: _refreshWordList,
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  /// Kelime listesi güncelleme
  void _refreshWordList() {
    setState(() {
      _wordListFuture = _fetchWordList();
      _refreshNotifier.value = !_refreshNotifier.value;
    });
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
        drawer: buildDrawer(context),
        bottomSheet: const BottomSheetWidget(),
        body: showBody(
          context,
          languageParams,
          isListView,
          language,
          firstLanguageCode,
          firstLanguageText,
          secondLanguageCode,
          secondLanguageText,
          appBarTitle,
          _buildWordList,
          _refreshWordList,
          setState,
        ),
        floatingActionButton: buildFloatingActionButton(
          context,
          email,
          language,
          firstLanguageText,
          secondLanguageText,
          _firestoreService,
          _refreshWordList,
          _fetchWordList,
          (Future<List<QuerySnapshot<FsWords>>> newWordListFuture) {
            setState(
              () {
                _wordListFuture = newWordListFuture;
              },
            );
          },
        ),
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
}
