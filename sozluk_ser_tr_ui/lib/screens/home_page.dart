/// <----- home_page.dart ----->
library;

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../models/fs_words.dart';
import '../services/firestore_services.dart';
import '../services/icon_provider.dart';
import '../services/word_service.dart';
import 'home_page_parts/bottom_sheet.dart';
import 'home_page_parts/drawer_items.dart';
import 'home_page_parts/home_app_bar.dart';
import 'home_page_parts/language_selector.dart';
import 'home_page_parts/word_list_builder.dart';
import 'home_page_parts/wordbox_dialog.dart';

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

  /// Firestore servisi için değişken oluşturalım
  final FirestoreService _firestoreService = FirestoreService();
  final WordBoxDialog _wordBoxDialog = WordBoxDialog();

  bool isListView = false;
  bool aramaYapiliyorMu = false;

  String aramaKelimesi = "";

  /// başlangıç dili Sırpça olacak
  String appBarTitle = appBarMainTitleSecond;
  String firstLanguageCode = 'RS'; // İlk dil kodu
  String firstLanguageText = 'Sırpça'; // İlk dil metni
  String secondLanguageCode = 'TR'; // İkinci dil kodu
  String secondLanguageText = 'Türkçe'; // İkinci dil metni

  Future<void> _initializeFirestore() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('kelimeler')
        .orderBy("sirpca")
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
    _initializeFirestore();
    _wordListFuture = _fetchWordList();
  }

  /// kelime listesi oluşturma
  Widget _buildWordList() {
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

  Future<List<QuerySnapshot<FsWords>>> _fetchWordList() async {
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

    return await Future.wait([queryForSerbian.get(), queryForTurkish.get()]);
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            log("Kelime ekleme seçildi");
            // _wordBoxDialog nesnesi üzerinden openWordBox metodunu çağırın
            _wordBoxDialog.openWordBox(
              context: context,
              onWordAdded: (String secondLang, String firstLang,) {
                // Eklenecek kelimenin işlemleri
                log('Eklenecek kelime: $secondLang - $firstLang');
                _wordListFuture = _fetchWordList();
                // Eklenen kelimeyi Firestore 'a ekleme gibi işlemler burada gerçekleştirilebilir
              },
              onWordUpdated:(String docId ) {
                // Güncellenecek kelimenin işlemleri
                log('Güncellenecek kelime ID: $docId');
                _wordListFuture = _fetchWordList();
                // Güncellenen kelimeyi Firestore 'da güncelleme gibi işlemler burada gerçekleştirilebilir
              },
            );
          },
          child: const Icon(Icons.add),
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
          child: _buildWordList(),
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

}