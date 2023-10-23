// home_view.dart
import 'package:flutter/material.dart';

import '../../core/app_const.dart';
import '../../core/extension/context_extension.dart';
import '../../core/language_model/language_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = AppConst.themeNotifier;
    final LanguageModel themeText = LanguageModel(
      tr: "Tema Modu",
      en: "Theme Mode",
    );
    final LanguageModel welcome = LanguageModel(
      tr: "Hoşgeldiniz",
      en: "Welcome",
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${context.language ? themeText.tr : themeText.en}",
        ),
        actions: [
          IconButton(
            onPressed: () {
              AppConst.language.changeLang();
            },
            icon: const Icon(Icons.language),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => themeNotifier.changeTheme(),
            icon: Icon(
              themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.brightness_3,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Icon(
              Icons.home,
              size: 256,
            ),
            Container(
              color: context.theme.cardColor,
              height: 200,
              width: 200,
            ),
            Text("${context.language ? welcome.tr : welcome.en}"),
          ],
        ),
      ),
    );
  }
}
