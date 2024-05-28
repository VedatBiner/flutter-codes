/// <----- home_page.dart ----->
/// --------------------------------------------------
/// Bu sayfa bütün kodun merkezini oluşturuyor.
/// çok sık güncelleme yapılıyor.
/// Burada kelimeler Firebase Firestore 'dan pagination
/// yöntemi ile çekiliyor. Liste ve Card görünümünde
/// gösteriliyor. Yeni kelime ekleme, silme ve düzeltme
/// işlemleri yapılıyor. Ayrıca kelimeler tek tek card
/// olarak da görüntülenebiliyor.
/// --------------------------------------------------
library;

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants/constants.dart';
import '../constants/app_constants/drawer_constants.dart';
import '../models/fs_words.dart';
import '../models/language_params.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';
import '../services/icon_provider.dart';
import '../services/word_service.dart';
import 'home_page_parts/bottom_sheet.dart';
import 'home_page_parts/drawer_items.dart';
import 'home_page_parts/home_app_bar.dart';
import 'home_page_parts/language_selector.dart';
import 'home_page_parts/add_word_box.dart';
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

  /// Başlangıç App Bar
  String appBarTitle = appBarMainTitleSecond;

  /// başlangıç dili Sırpça olacak
  String firstLanguageCode = secondCountry; // İlk dil kodu
  String firstLanguageText = ikinciDil; // İlk dil metni
  String secondLanguageCode = firstCountry; // İkinci dil kodu
  String secondLanguageText = birinciDil; // İkinci dil metni

  /// Burada başlangıç dili Sırpça geldiği için
  /// koleksiyon okunduğu zaman
  /// kelimeler sırpça 'ya göre sıralı olarak
  /// pagination ile listelenir.
  Future<void> _initializeFirestore() async {
    final collectionRef = FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy(fsIkinciDil)
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
          fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
          toFirestore: (word, _) => word.toJson(),
        );
  }

  /// kelime listesi oluşturma
  /// Burada hem sırpça hem de Türkçe iki liste oluşturuluyor
  Widget _buildWordList() {
    /// Sırpça sorgu listesi
    final queryForSerbian = _buildQuery(fsIkinciDil);

    /// Türkçe sorgu listesi
    final queryForTurkish = _buildQuery(fsBirinciDil);

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
        return WordListBuilder(
          snapshot: snapshot.data!,
          isListView: isListView,
          languageParams: languageParams,
        );
      },
    );
  }

  /// ekrana listelenecek yapı burada oluşturuluyor
  Future<List<QuerySnapshot<FsWords>>> _fetchWordList() async {
    final queryForSerbian = _buildQuery(fsIkinciDil);
    final queryForTurkish = _buildQuery(fsBirinciDil);

    const options = GetOptions(source: Source.cache);
    return await Future.wait(
      [queryForSerbian.get(options), queryForTurkish.get(options)],
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
    final ScrollController controller;

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
      onIconPressed: () {
        setState(() {
          Provider.of<IconProvider>(context, listen: false).changeIcon();
          isListView = !isListView;
        });
      },
      onLanguageChange: () {
        setState(() {
          final newParams = languageParams.copyWith(
            firstLanguageCode: languageParams.firstLanguageCode,
            firstLanguageText: languageParams.firstLanguageText,
            secondLanguageCode: languageParams.secondLanguageCode,
            secondLanguageText: languageParams.secondLanguageText,
          );
          Provider.of<LanguageParams>(context, listen: false).changeLanguage(
            firstLanguageCode: newParams.secondLanguageCode,
            firstLanguageText: newParams.secondLanguageText,
            secondLanguageCode: newParams.firstLanguageCode,
            secondLanguageText: newParams.firstLanguageText,
          );

          if (newParams.firstLanguageText == birinciDil &&
              newParams.secondLanguageText == ikinciDil) {
            appBarTitle = appBarMainTitleFirst;
          } else if (newParams.firstLanguageText == ikinciDil &&
              newParams.secondLanguageText == birinciDil) {
            appBarTitle = appBarMainTitleSecond;
          }

          firstLanguageText = newParams.secondLanguageText;
          secondLanguageText = newParams.firstLanguageText;
        });
      },
    );
  }

  /// FAB ile kelime ekleme işlemi burada yapılıyor
  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    final TextEditingController firstLanguageController =
        TextEditingController();
    final TextEditingController secondLanguageController =
        TextEditingController();

    // firstLanguageText == birinciDil
    //     ? firstLanguageText = birinciDil
    //     : firstLanguageText = ikinciDil;
    //
    // secondLanguageText == ikinciDil
    //     ? secondLanguageText = ikinciDil
    //     : secondLanguageText = birinciDil;

    return FloatingActionButton(
      onPressed: () {
        log("Kelime ekleme seçildi");
        log("home_page.dart >> firstLanguageText : $firstLanguageText");
        log("home_page.dart >> secondLanguageText : $secondLanguageText");
        showGeneralDialog(
            context: context,
            barrierDismissible:
                false, // Dialog dışına tıklayınca kapanmasını engeller
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black54,
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (BuildContext buildContext, Animation animation,
                Animation secondaryAnimation) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Material(
                    borderRadius: BorderRadius.circular(16.0),
                    child: AddWordBox(
                      firstLanguageController: firstLanguageController,
                      secondLanguageController: secondLanguageController,
                      firstLanguageText: firstLanguageText,
                      secondLanguageText: secondLanguageText,
                      currentUserEmail: MyAuthService.currentUserEmail,
                      onWordAdded: (String secondLang, String firstLang) async {
                        await _firestoreService.addWord(
                          context,
                          secondLang,
                          firstLang,
                          MyAuthService.currentUserEmail,
                        );
                        setState(() {
                          _wordListFuture = _fetchWordList();
                        });
                      },
                    ),
                  ),
                ),
              );
            });

        /*/// _wordBoxDialog nesnesi üzerinden openWordBox metodunu çağır
        // wordBoxDialog.openWordBox(
        //   context: context,
        //   languageParams: Provider.of<LanguageParams>(context, listen: false),

        /// kelime ekleme bilgisi buradan gidiyor
        // onWordAdded: (String secondLang, String firstLang) async {
        //   await _firestoreService.addWord(context, secondLang, firstLang);
        //   setState(() {
        //     _wordListFuture = _fetchWordList();
        //   });
        // },

        /// kelime düzeltme bilgisi buradan gidiyor.
        // onWordUpdated: (String docId) async {
        //
        //   log('Güncellenecek kelime ID: $docId');
        //   _wordListFuture = _fetchWordList();
        //   // Güncellenen kelimeyi Firestore 'da güncelleme gibi
        //   // işlemler burada gerçekleştirilebilir
        // },
        // );*/
      },
      child: const Icon(Icons.add),
    );
  }
}
