// 📃 <----- help_custom_drawer.dart ----->

import 'package:flutter/material.dart';

import '../../../widgets/custom_drawer.dart';

Widget buildHelpDrawer() {
  return CustomDrawer(
    onDatabaseUpdated: () {},
    appVersion: '',
    isFihristMode: true,
    onToggleViewMode: () {},
    onLoadJsonData: ({required BuildContext context}) async {},
  );
}
