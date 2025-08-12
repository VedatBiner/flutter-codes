// 📃 <----- help_custom_app_bar.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../providers/word_count_provider.dart';
import '../custom_app_bar.dart';

PreferredSizeWidget buildHelpAppBar(BuildContext context) {
  final wordCount = Provider.of<WordCountProvider>(context).count;

  return CustomAppBar(
    isSearching: false,
    searchController: TextEditingController(),
    onSearchChanged: (value) {},
    onClearSearch: () {},
    onStartSearch: () {},
    itemCount: wordCount,
  );
}
