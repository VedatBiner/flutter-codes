/// <----- home_view.dart ----->
import 'package:flutter/material.dart';

import '../../constant/app_const.dart';
import '../../core/extension/context_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = AppConst.listener.themeNotifier;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${context.language ? AppConst.home.themeText.tr : AppConst.home.themeText.en}",
        ),
        actions: [
          IconButton(
            onPressed: () {
              AppConst.listener.language.changeLang();
            },
            icon: const Icon(Icons.language),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => AppConst.listener.themeNotifier.changeTheme(),
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
            Text(
                "${context.language ? AppConst.home.welcome.tr : AppConst.home.welcome.en}"),
          ],
        ),
      ),
    );
  }
}
