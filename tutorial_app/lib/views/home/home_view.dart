/// <----- home_view.dart ----->
library;

import 'package:flutter/material.dart';

import '../../config/route/app_routes.dart';
import '../../constant/app_const.dart';
import '../../core/extension/context_extension.dart';

/// parts field
part "body/home_body.dart";
// part "appbar/home_appbar.dart";

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = AppConst.listener.themeNotifier;

    /// Bir önceki ekrana dönüşü engellemek için adım 1.
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${context.language ? AppConst.home.themeText.tr : AppConst.home.themeText.en}",
          ),
          /// Bir önceki ekrana dönüşü engellemek için adım 2.
          automaticallyImplyLeading: false,
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
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoute.splash),
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
          ],
        ),
        body: const _HomeBody(),
      ),
    );
  }
}
