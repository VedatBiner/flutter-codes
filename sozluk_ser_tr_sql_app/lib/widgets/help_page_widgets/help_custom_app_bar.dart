// 📃 <----- help_custom_app_bar.dart ----->

import 'package:flutter/material.dart';

import '../../../widgets/custom_app_bar.dart';

PreferredSizeWidget buildHelpAppBar() {
  return CustomAppBar(
    isSearching: false,
    searchController: TextEditingController(),
    onSearchChanged: (value) {},
    onClearSearch: () {},
    onStartSearch: () {},
    itemCount: 0,
  );
}
