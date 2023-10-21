// splash_view.dart
import 'package:flutter/material.dart';
import 'dart:async';

import '../../config/route/app_routes.dart';
import '../../core/app_const.dart';

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
        title: const Text("Splash View"),
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smart_display_sharp,
              size: 256,
            ),
            Text("Welcome My App"),
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
    timer = Timer(AppConst.splashDuration, goToHome,);
    super.initState();
  }

  Future<void> goToHome() async {
    await Navigator.pushNamed(context, AppRoute.home);
  }
}
