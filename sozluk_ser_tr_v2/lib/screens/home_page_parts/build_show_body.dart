import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants/constants.dart';
import '../../constants/app_constants/drawer_constants.dart';
import '../../models/language_params.dart';
import '../../services/providers/icon_provider.dart';
import 'build_language_selector.dart';

/// Sayfa düzeni burada oluşuyor.
Widget showBody(
  BuildContext context,
  LanguageParams languageParams,
  bool isListView,
  bool language,
  String firstLanguageCode,
  String firstLanguageText,
  String secondLanguageCode,
  String secondLanguageText,
  String appBarTitle,
  Widget Function() buildWordList,
  VoidCallback refreshWordList,
  void Function(VoidCallback fn) setState,
) {
  return Column(
    children: [
      /// burada sayfa başlığı ve
      /// dil değişimi, görünüm ayarı var
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: buildLanguageSelector(
          context: context,
          isListView: isListView,
          language: language,
          firstLanguageCode: firstLanguageCode,
          firstLanguageText: firstLanguageText,
          secondLanguageCode: secondLanguageCode,
          secondLanguageText: secondLanguageText,
          appBarTitle: appBarTitle,
          setState: setState,
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
        ),
      ),

      /// burada sıralı kelime listesi gelsin
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.78,

        /// kelimeleri listeleyen metod
        child: buildWordList(),
      ),
    ],
  );
}
