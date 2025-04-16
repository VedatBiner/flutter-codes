// 📃 <----- help_custom_app_bar.dart ----->

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../providers/word_count_provider.dart';

PreferredSizeWidget buildHelpAppBar(BuildContext context) {
  return CustomAppBar(
    isSearching: false,
    searchController: TextEditingController(),
    onSearchChanged: (value) {},
    onClearSearch: () {},
    onStartSearch: () {},
    itemCount: context.watch<WordCountProvider>().count, // ✅ Burada canlı değer
  );
}
