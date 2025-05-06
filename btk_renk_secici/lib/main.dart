// 📜 <----- main.dart ----->

import 'package:flutter/material.dart';

import '../pages/color_picker_page.dart';
import '../theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ColorPickerPage(),
    );
  }
}
