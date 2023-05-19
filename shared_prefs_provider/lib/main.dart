import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeColorData().createSharedPrefObject();
  runApp(
    // provider ile yayını yapıyoruz.
    ChangeNotifierProvider<ThemeColorData>(
      create: (BuildContext context) => ThemeColorData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeColorData>(context, listen: false)
        .loadThemeFromSharedPref();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // yayını okuyoruz
      theme: Provider.of<ThemeColorData>(context).themeColor,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Tema Seçimi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile(
              title: Provider.of<ThemeColorData>(context).isGreen
                  ? const Text("Yeşil Tema")
                  : const Text("Kırmızı Tema"),
              onChanged: (_) {
                Provider.of<ThemeColorData>(context, listen: false)
                    .toggleTheme();
              },
              value: Provider.of<ThemeColorData>(context).isGreen,
            ),
            const Card(
              child: ListTile(
                title: Text("Yapılacaklar"),
                trailing: Icon(Icons.check_box),
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              child: const Text("Ekle"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}