/// <----- main.dart ----->
/// --------------------------------------------------
/// Burada kodumuzun çalışmasını başlatıyoruz.
/// provider paketi ile kullanılacak işlemler ve
/// firebase tanımlarımız var
/// --------------------------------------------------
library;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';
import 'models/language_params.dart';
import 'services/providers/icon_provider.dart';
import 'services/providers/theme_provider.dart';
import 'services/app_routes.dart';
import 'constants/base_constants/app_const.dart';
import 'constants/app_constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Kullanıcı dil parametreleri buradan sağlanıyor
  String firstLanguageCode = firstCountry;
  String firstLanguageText = anaDil;
  String secondLanguageCode = secondCountry;
  String secondLanguageText = yardimciDil;

  runApp(
    MultiProvider(
      providers: [
        /// theme Provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),

        /// icon provider
        ChangeNotifierProvider(
          create: (context) => IconProvider(),
        ),

        /// word count provider
        // ChangeNotifierProvider(
        //   create: (context) => WordCountProvider(),
        // ),

        /// LanguageParam için provider
        ChangeNotifierProvider<LanguageParams>(
          create: (_) => LanguageParams(
            firstLanguageCode: firstLanguageCode,
            firstLanguageText: firstLanguageText,
            secondLanguageCode: secondLanguageCode,
            secondLanguageText: secondLanguageText,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          log("===> 01-main.dart çalıştı. >>>>>");
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConst.main.title,
            routes: AppRoute.routes,
            initialRoute: AppRoute.splash,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
          );
        },
      );
}
