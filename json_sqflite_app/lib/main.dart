/// <----- main.dart ----->
///
library;
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(HomePage());
}

