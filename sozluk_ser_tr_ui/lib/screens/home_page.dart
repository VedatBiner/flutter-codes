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
  // final WordBoxDialog _wordBoxDialog = WordBoxDialog();

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
          fromFirestore: (snapshot, _) => FsWords.fromJson(snapshot.data()!),
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
    final queryForSerbian = _buildQuery(fsYardimciDil);
    final queryForTurkish = _buildQuery(fsAnaDil);

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

          if (newParams.firstLanguageText == anaDil &&
              newParams.secondLanguageText == yardimciDil) {
            appBarTitle = appBarMainTitleFirst;
          } else if (newParams.firstLanguageText == yardimciDil &&
              newParams.secondLanguageText == anaDil) {
            appBarTitle = appBarMainTitleSecond;
          }

          firstLanguageText = newParams.firstLanguageText;
          secondLanguageText = newParams.secondLanguageText;

          log("home_page.dart => Lang Selector - firstLanguageText : $firstLanguageText");
          log("home_page.dart => Lang Selector - secondLanguageText : $secondLanguageText");
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

    return FloatingActionButton(
      onPressed: () {
        log("Kelime ekleme seçildi");

        log("home_page.dart => (FAB) - firstLanguageText : $firstLanguageText");
        log("home_page.dart => (FAB) - secondLanguageText : $secondLanguageText");

        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
           // log("Home_page.dart (FAB) => email : $email");
            return buildCenter(
              firstLanguageController,
              secondLanguageController,
              email,
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
    BuildContext context,
  ) {
    log("home_page.dart => (buildCenter) - firstLanguageText : $firstLanguageText");
    log("home_page.dart => (buildCenter) - secondLanguageText : $secondLanguageText");
   // log("Home_page.dart => (Center) - email : $email");
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          borderRadius: BorderRadius.circular(16.0),
          child: AddWordBox(
            firstLanguageController: secondLanguageController,
            secondLanguageController: firstLanguageController,
            firstLanguageText: anaDil,
            secondLanguageText: yardimciDil,
            currentUserEmail: email,
            onWordAdded: (
              String firstLang,
              String secondLang,
              String email,
            ) async {
          //    log("Home_page.dart => (AddWordBox) - email : $email");
              await _firestoreService.addWord(
                context,
                firstLang,
                secondLang,
                email,
              );
              setState(
                () {
                  _wordListFuture = _fetchWordList();
                  var message = addMsg;
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildSnackBar(message),
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

  /// Yeni kelime eklendi mesajı burada yazılıyor
  SnackBar buildSnackBar(String message) {
    return SnackBar(
      content: Column(
        children: [
          Row(
            children: [
              Text(
                secondLanguageText ?? '',
                style: kelimeStil,
              ),
              const Text(" kelimesi "),
            ],
          ),
          Row(
            children: [
              Text(
                email,
                style: userStil,
              ),
              Text(
                message,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
