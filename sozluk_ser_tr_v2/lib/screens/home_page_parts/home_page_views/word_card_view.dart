/// <----- word_card_view.dart ----->
/// Kelime listesini CardView olarak göstermek için
/// bu kod kullanılıyor.
/// kelime bilgileri word_list_builder.dart dosyasından geliyor.
library;

import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../../constants/app_constants/constants.dart';
import '../../../constants/app_constants/color_constants.dart';
import '../../../models/fs_words.dart';
import '../../../models/language_params.dart';
import '../../../services/firebase_services/auth_services.dart';
import '../../../services/firebase_services/firestore_services.dart';
import '../../../services/notification_service.dart';
import '../../../services/providers/theme_provider.dart';
import '../../details_page.dart';
import '../edit_word_box.dart';

class WordCardView extends StatefulWidget {
  final FsWords word;
  final bool isDarkMode;
  final String displayedLanguage;
  final String displayedTranslation;
  final String firstLanguageText;
  final String secondLanguageText;
  final VoidCallback onDelete;
  final List<FsWords> mergedResults;
  final bool language;
  final ValueNotifier<bool> refreshNotifier;

  const WordCardView({
    super.key,
    required this.word,
    required this.isDarkMode,
    required this.displayedLanguage,
    required this.displayedTranslation,
    required this.firstLanguageText,
    required this.secondLanguageText,
    required this.onDelete,
    required this.mergedResults,
    required this.language,
    required this.refreshNotifier,
  });

  @override
  State<WordCardView> createState() => _WordCardViewState();
}

class _WordCardViewState extends State<WordCardView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageParams = Provider.of<LanguageParams>(context);
    final email = MyAuthService.currentUserEmail;

    /// dil seçimine göre değişim için
    /// burası gerekli bir kontrol sağlıyor
    bool language = widget.displayedLanguage == yardimciDil;

    /// Firestore servislerine erişiyoruz
    final FirestoreService firestoreService = FirestoreService();

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        shadowColor: Colors.green[200],
        color: themeProvider.isDarkMode ? cardDarkMode : cardLightMode,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  wordList: widget.mergedResults,
                  initialWord: widget.word,
                  language: language,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.displayedLanguage == anaDil
                            ? widget.firstLanguageText ?? ""
                            : widget.secondLanguageText ?? "",
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? cardDarkModeText1
                              : cardLightModeText1,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: themeProvider.isDarkMode
                            ? Colors.white60
                            : Colors.black45,
                      ),
                      Text(
                        widget.displayedTranslation == yardimciDil
                            ? widget.secondLanguageText ?? ""
                            : widget.firstLanguageText ?? "",
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? cardDarkModeText2
                              : cardLightModeText2,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    /// kelime düzeltme işlemi için buton
                    /// ve düzeltme metodu burada
                    IconButton(
                      onPressed: () {
                        log("Kelime düzeltme seçildi");
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black54,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    side: const BorderSide(
                                      color: Colors.green, // Çerçeve rengi
                                      width: 2.0, // Çerçeve kalınlığı
                                    ),
                                  ),
                                  color: themeProvider.isDarkMode
                                      ? Colors.black38
                                      : menuColor,
                                  child: EditWordBox(
                                    firstLanguageController:
                                    TextEditingController(
                                      text: widget.firstLanguageText,
                                    ),
                                    secondLanguageController:
                                    TextEditingController(
                                      text: widget.secondLanguageText,
                                    ),
                                    firstLanguageText: widget.firstLanguageText,
                                    secondLanguageText:
                                    widget.secondLanguageText,
                                    currentUserEmail: email,
                                    language: language,
                                    wordId: widget.word.wordId,
                                    onWordUpdated: (
                                        String wordId,
                                        String secondLang,
                                        String firstLang,
                                        ) async {
                                      String updateKelime = language
                                          ? widget.word.sirpca ?? ""
                                          : widget.word.turkce ?? "";

                                      /// Firestore 'da güncelleme
                                      /// burada yapılıyor.
                                      await firestoreService.updateWord(
                                        wordId,
                                        firstLang,
                                        secondLang,
                                      );
                                      Navigator.pop(buildContext);
                                      log("Kelime düzeltildi");

                                      if (mounted) {
                                        /// Value Notifier güncelleniyor
                                        widget.refreshNotifier.value =
                                        !widget.refreshNotifier.value;
                                        setState(
                                              () {
                                            /// kelime düzeltildi mesajı burada veriliyor
                                            NotificationService
                                                .showCustomNotification(
                                              context: context,
                                              title: 'Kelime düzeltildi',
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
                                                      text: MyAuthService
                                                          .currentUserEmail,
                                                      style: userStil,
                                                    ),
                                                    TextSpan(
                                                      text: updateMsg,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              icon: Icons.check_circle_rounded,
                                              iconColor: Colors.blueAccent,
                                              position: Alignment.bottomLeft,
                                              animation: AnimationType.fromLeft,
                                              progressIndicatorColor:
                                              Colors.blue[600],
                                              progressIndicatorBackground:
                                              Colors.blue[100]!,
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: "kelime düzelt",
                      color: Colors.green,
                    ),

                    /// kelime silme için buton ve silme metodu
                    IconButton(
                      onPressed: () {
                        log("Kelime silme seçildi");
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return buildAlertDialog(
                              context,
                              language,
                              firestoreService,
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                      tooltip: "kelime sil",
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Burada kelime silme işlemi için
  /// dialog kutusu oluşturuyoruz.
  AlertDialog buildAlertDialog(
      BuildContext context,
      bool language,
      FirestoreService firestoreService,
      ) {
    String silinecekKelime =
    language ? widget.word.sirpca ?? "" : widget.word.turkce ?? "";
    return AlertDialog(
      backgroundColor:
      Theme.of(context).brightness == Brightness.dark ? Colors.white : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      title: const Text(
        dikkatMsg,
        style: dikkatText,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            silinecekKelime,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
          const Divider(),
          const Text(
            silMsg,
            style: silText,
            textAlign: TextAlign.left,
          ),
          const Text(
            eminMsg,
            style: eminText,
          ),
          const Divider(),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'İptal',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: drawerColor,
          ),
          onPressed: () async {
            /// Burada silme işlemi gerçekleştirilir.
            await firestoreService.deleteWord(widget.word.wordId);
            widget.onDelete();
            if (mounted) {
              widget.refreshNotifier.value = !widget.refreshNotifier.value;
              setState(() {
                /// Kelimenin silindiği mesajı burada veriliyor.
                NotificationService.showCustomNotification(
                  context: context,
                  title: 'Kelime silindi',
                  message: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: silinecekKelime,
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
                          text: deleteMsg,
                        ),
                      ],
                    ),
                  ),
                  icon: Icons.delete,
                  iconColor: Colors.red,
                  position: Alignment.bottomLeft,
                  animation: AnimationType.fromLeft,
                  progressIndicatorColor: Colors.red[600],
                  progressIndicatorBackground: Colors.red[100]!,
                );
              });
            }
            Navigator.pop(context);
            log("Kelime silindi");
          },
          child: Text(
            'Sil',
            style: TextStyle(
              color: menuColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}