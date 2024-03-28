/// <----- settings_page.dart ----->
///
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import '../models/fs_words.dart';
import '../services/word_service.dart';
import 'home_page_parts/drawer_items.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late WordService _wordService;

  /// _wordService başlatılıyor
  @override
  void initState() {
    super.initState();
    _wordService = WordService(); // _wordService 'ı başlat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarSettingsTitle,
      ),
      drawer: buildDrawer(context),
      body: Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () async {
              /// Firestore verisinden JSON veri oluştur
              List<FsWords> words = await _wordService.fetchWords();
              String jsonData = _wordService.convertToJson(words);

              /// JSON verisini dosyaya yaz
              await _wordService.writeJsonToFile(jsonData);
            },
            child: const Text(jsonMsg),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text(sqfliteMsg),
          ),
        ],
      ),
    );
  }
}
