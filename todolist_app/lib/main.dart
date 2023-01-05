import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_data.dart';
import '../models/color_theme_data.dart';
import '../screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ColorThemeData().createPrefObject();
  await ItemData().createPrefObject();
  runApp(
    MultiProvider(
      providers: [
        // 1. Provider oluşturuldu.
        ChangeNotifierProvider<ItemData>(
          create: (BuildContext context) => ItemData(),
        ),
        // 2. Provider
        ChangeNotifierProvider<ColorThemeData>(
          create: (context) => ColorThemeData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer2<ItemData, ColorThemeData>(
        builder: (context, itemData, colorThemeData, child) {
          // iki provider yayınlıyoruz
          itemData.loadItemsFromSharedPref();
          colorThemeData.loadThemeFromSharedPref();

          return MaterialApp(
            theme: Provider
                .of<ColorThemeData>(context)
                .selectedThemeData,
            home: const HomePage(),
          );
        }
    );
  }
}
