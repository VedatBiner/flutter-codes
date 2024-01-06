/// <----- app_routes.dart ----->

import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import '../screens/splash_page.dart';

typedef AppRouteMapFunction = Widget Function(BuildContext context);

final class AppRoute {
  const AppRoute._();

  static String splash = "/";
  static String home = "/home";

  static Map<String, AppRouteMapFunction> routes = {
    home: (context) => const HomePage(),
    splash: (context) => const SplashView(),
  };
}
