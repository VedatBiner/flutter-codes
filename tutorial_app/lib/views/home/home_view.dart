import 'package:flutter/material.dart';

import '../../core/app_const.dart';
import '../../core/extension/context_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme Mode"),
        actions: [
          IconButton(
            onPressed: () => AppConst.themeNotifier.changeTheme(),
            icon: const Icon(
              Icons.sunny,
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
