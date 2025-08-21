// 📃 <----- help_custom_drawer.dart ----->

import 'package:flutter/material.dart';

import '../custom_drawer.dart';

Widget buildHelpDrawer({
  String appVersion = '',
  Future<void> Function()? onReload,
}) {
  return CustomDrawer(
    appVersion: appVersion,
    onReload: onReload ?? () async {}, // fallback: boş no-op
  );
}
