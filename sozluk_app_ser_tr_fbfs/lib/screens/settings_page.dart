/// <----- settings_page.dart ----->
///
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import '../models/____fs_words.dart_iptal';
import '../services/word_service.dart';
import '../utils/generate_json.dart';
import 'home_page_parts/drawer_items_new.dart';

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
    _wordService = WordService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarSettingsTitle,
      ),
      drawer: buildDrawer(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
            ),
            onPressed: () async {
              /// Firestore verisinden JSON dosya oluşturup yazıyoruz
              await generateAndWriteJson(_wordService);
            },
            child: Text(
              jsonMsg,
              style: butonTextDialog,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
            ),
            onPressed: () {},
            child: Text(
              sqfliteMsg,
              style: butonTextDialog,
            ),
          ),
        ],
      ),
    );
  }
}
