import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../views/home/home_view.dart';
import '../providers/locale_provider.dart';
import 'generated/l10n.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocaleProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, value, child) => MaterialApp(
        /// lokalizasyon burada belirtiliyor.
        /// S ile l10n.dark dosyasından,
        /// GlobalXXX ile flutter_localizations paketini kullanıyoruz.
        localizationsDelegates: const [
          S.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],

        /// desteklenen diller
        supportedLocales: S.delegate.supportedLocales,

        /// uygulama ilk açıldığında gelecek dil
        /// provider 'dan değiştirilecek
        locale: value.current,
        home: const HomeView(),
      ),
    );
  }
}
