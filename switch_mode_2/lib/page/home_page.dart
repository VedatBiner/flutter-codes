import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../main.dart';
import '../widget/change_theme_button_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? "DarkTheme"
        : "LightTheme";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(MyApp.title),
        actions: const [
          ChangeThemeButtonWidget(),
        ],
      ),
      body: Center(
        child: Text(
          "Hello $text!",
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
