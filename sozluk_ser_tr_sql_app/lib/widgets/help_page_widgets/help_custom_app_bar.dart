// 📃 <----- help_custom_app_bar.dart ----->

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/item_count_provider.dart';
import '../../../widgets/custom_app_bar.dart';

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
