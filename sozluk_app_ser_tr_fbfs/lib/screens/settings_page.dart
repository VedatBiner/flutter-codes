/// <----- settings_page.dart ----->
///
library;
import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../help_pages/help_parts/custom_appbar.dart';
import 'home_page_parts/drawer_items.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: appBarSettingsTitle,
      ),
      drawer: buildDrawer(context),

    );
  }
}
