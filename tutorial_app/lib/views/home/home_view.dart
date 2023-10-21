// home_view.dart
import 'package:flutter/material.dart';
import '../../core/app_const.dart';
import '../../core/extension/context_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = AppConst.themeNotifier;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme Mode"),
        actions: [
          IconButton(
            onPressed: () => themeNotifier.changeTheme(),
            icon: Icon(
              themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.brightness_3,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Icon(
              Icons.home,
              size: 256,
            ),
            Container(
              color: context.theme.cardColor,
              height: 200,
              width: 200,
            ),
            const Text("Welcome Home"),
          ],
        ),
      ),
    );
  }
}
