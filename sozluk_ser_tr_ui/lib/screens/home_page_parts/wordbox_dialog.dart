/// <----- wordbox_dialog.dart ----->
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../models/language_params.dart';
import '../../services/auth_services.dart';
import '../../services/firestore_services.dart';
import '../../utils/mesaj_helper.dart';
import '../../widgets/test_entry.dart';

class WordBoxDialog extends ChangeNotifier {
  /// Firestore servisi için değişken oluşturalım
  final FirestoreService firestoreService = FirestoreService();

  /// başlangıç dili Sırpça olacak
  String firstLanguageCode = firstCountry; // İlk dil kodu
  String firstLanguageText = birinciDil; // İlk dil metni
  String secondLanguageCode = secondCountry; // İkinci dil kodu
  String secondLanguageText = ikinciDil; // İkinci dil metni

  /// veri girişi için Controller
  final TextEditingController ikinciDilController = TextEditingController();
  final TextEditingController birinciDilController = TextEditingController();

  void openWordBox({
    required BuildContext context,
    required Function(String, String) onWordAdded,
    required void Function(String) onWordUpdated,
    String? docId,
    required LanguageParams languageParams,
  }) async {
    String action = "create";
    String secondLang = "";
    String firstLang = "";
    String message = "";

    // String currentUserEmail =
    //     FirebaseAuth.instance.currentUser?.email ?? 'vbiner@gmail.com';

    if (docId != null) {
      action = "update";

      var snapshot = await firestoreService.getWordById(docId);
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        ikinciDilController.text = data[fsIkinciDil];
        birinciDilController.text = data[fsBirinciDil];
        notifyListeners();
      }
    }

    // ikinciDilController.text = secondLang;
    // birinciDilController.text = firstLang;

    firstLang == birinciDil
        ? firstLanguageText = languageParams.firstLanguageText
        : firstLanguageText = languageParams.secondLanguageText;

    secondLang == ikinciDil
        ? secondLanguageText = languageParams.secondLanguageText
        : secondLanguageText = languageParams.firstLanguageText;

    if (firstLang != null && secondLang != null) {
      ikinciDilController.text = secondLang;
      birinciDilController.text = firstLang;
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade300
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        content: _buildWordBox(),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
            ),
            onPressed: () async {
              if (docId == null &&
                  ikinciDilController.text.isEmpty &&
                  birinciDilController.text.isEmpty) {
                MessageHelper.showSnackBar(
                  context,
                  message: "İki kelime satırını da boş ekleyemezsiniz ...",
                );
              } else if (docId == null) {
                /// kelime ekleniyor
                await firestoreService.addWord(
                  context,
                  ikinciDil,
                  birinciDil,
                );
                onWordAdded(
                  ikinciDilController.text,
                  birinciDilController.text,
                );
                message = "${MyAuthService.currentUserEmail} addMsg";
              } else {
                /// kelime güncelleniyor
                await firestoreService.updateWord(
                  docId,
                  ikinciDilController.text,
                  birinciDilController.text,
                );
                onWordUpdated(docId);
                message = updateMsg;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            ikinciDilController.text ?? '',
                            style: kelimeStil,
                          ),
                          const Text(
                            ' = ',
                            style: kelimeStil,
                          ),
                          Text(
                            birinciDilController.text ?? '',
                            style: kelimeStil,
                          ),
                        ],
                      ),
                      Text(
                        message,
                        style: kelimeStil,
                      ),
                    ],
                  ),
                ),
              );

              ikinciDilController.clear();
              birinciDilController.clear();

              Navigator.pop(context);
            },
            child: Text(
              docId == null ? "Kelime ekle" : "Kelime düzelt",
              style: butonTextDialog,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWordBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextEntry(
          controller: ikinciDilController,
          hintText: "$firstLanguageText $wordEntryMsg",
        ),
        const SizedBox(height: 5),
        TextEntry(
          controller: birinciDilController,
          hintText: "$secondLanguageText $wordMeanInMsg",
        ),
      ],
    );
  }
}
