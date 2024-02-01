/// <----- splash_page.dart ----->

import 'package:flutter/material.dart';
import 'dart:async';

import '../constants/app_constants/constants.dart';
import '../constants/base_constants/app_const.dart';
import '../services/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with _SplashViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConst.splash.appBarTitle),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/maymuncuk.jpg",
              width: 400,
              height: 400,
              fit: BoxFit.cover,
            ),
            Text(
              "Welcome My App",
              style: glutenFontText,
            ),
          ],
        ),
      ),
    );
  }
}

mixin _SplashViewMixin on State<SplashView> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer(
      AppConst.splash.splashDuration,
      goToHome,
    );
    super.initState();
  }

  Future<void> goToHome() async {
    /// Buradan login sayfasına gidilecek
   // await Navigator.pushNamed(context, AppRoute.home);
    await Navigator.pushNamed(context, AppRoute.login);
  }
}