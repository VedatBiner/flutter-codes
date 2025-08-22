// 📃 <----- help_custom_app_bar.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

import '../../constants/info_constants.dart';

/// 📌 Yardımcı yüklemeler burada
// import '../../providers/word_count_provider.dart';
import '../custom_app_bar.dart';

PreferredSizeWidget buildHelpAppBar(BuildContext context) {
  // final wordCount = Provider.of<WordCountProvider>(context).count;

  return CustomAppBar(
    appBarName: appBarName,
    isSearching: false,
    searchController: TextEditingController(),
    onSearchChanged: (value) {},
    // onClearSearch: () {},
    // onStartSearch: () {},
    // itemCount: wordCount,
  );
}
