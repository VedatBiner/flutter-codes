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

import 'package:elegant_notification/resources/arrays.dart';
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
import '../services/notification_service.dart';
import '../services/providers/theme_provider.dart';
import '../services/word_service.dart';
import '../services/providers/icon_provider.dart';
import 'home_page_parts/bottom_sheet.dart';
import 'home_page_parts/drawer_items.dart';
import 'home_page_parts/home_app_bar.dart';
import 'home_page_parts/language_selector.dart';
import 'home_page_parts/add_word_box.dart';
import 'home_page_parts/home_page_views/word_list_builder.dart';

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
          /// Hata durumunda hata mesajı göster
          return Text(
            'Hata: ${snapshot.error}',
          );
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
                onRefresh: _refreshWordList,

                /// Callback ekledik
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
      /// listeyi çek
      _wordListFuture = _fetchWordList();
      if (mounted) {
        setState(() {});
      }
      // _refreshNotifier.value = !_refreshNotifier.value;
      // /// Bildirim gönder
      // _refreshNotifier.notifyListeners();
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
        body: showBody(context, languageParams),
        drawer: buildDrawer(context),
        floatingActionButton: buildFloatingActionButton(context),
        bottomSheet: const BottomSheetWidget(),
      ),
    );
  }

  /// arama kutusunu içeren Appbar burada
  AppBar buildHomeCustomAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: HomeCustomAppBar(
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
      ),
    );
  }

  /// Sayfa düzeni burada oluşuyor.
  Widget showBody(
    BuildContext context,
    LanguageParams languageParams,
  ) {
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
      backgroundColor:
          themeProvider.isDarkMode ? Colors.green.shade900 : drawerColor,
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
  Widget buildCenter(
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
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.black38,
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
                /// Kelime var mı kontrol et
                bool wordExists = await _firestoreService.checkWordExists(
                  language == true ? firstLang : secondLang,
                  language == true ? secondLang : firstLang,
                );

                if (wordExists) {
                  /// Kelime varsa "Kelime var" mesajını göster
                  NotificationService.showCustomNotification(
                    context: context,
                    title: 'Kelime var',
                    message: RichText(
                      text: const TextSpan(
                        text: 'Bu kelime zaten var',
                      ),
                    ),
                    icon: Icons.warning,
                    iconColor: Colors.amber,
                    progressIndicatorColor: Colors.amber[600],
                    progressIndicatorBackground: Colors.amber[100]!,
                  );
                } else {
                  /// Kelime yoksa ekleme işlemini yap
                  await _firestoreService.addWord(
                    context,
                    language == true ? firstLang : secondLang,
                    language == true ? secondLang : firstLang,
                    email,
                  );
                  setState(() {
                    _wordListFuture = _fetchWordList();

                    /// Kelimenin eklendiği mesajı burada veriliyor.
                    NotificationService.showCustomNotification(
                      context: context,
                      title: 'Kelime eklendi',
                      message: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: firstLang,
                              style: kelimeStil,
                            ),
                            const TextSpan(
                              text: ' kelimesi ',
                            ),
                            TextSpan(
                              text: MyAuthService.currentUserEmail,
                              style: userStil,
                            ),
                            TextSpan(
                              text: addMsg,
                            ),
                          ],
                        ),
                      ),
                      icon: Icons.check_circle_rounded,
                      iconColor: Colors.green,
                      position: Alignment.bottomLeft,
                      animation: AnimationType.fromLeft,
                      progressIndicatorColor: Colors.green[600],
                      progressIndicatorBackground: Colors.green[100]!,
                    );
                  });
                }

                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
