/// <----- app_routes.dart ----->
library;

import 'package:flutter/material.dart';

import '../../views/home/home_view.dart';
import '../../views/splash/splash_view.dart';

typedef AppRouteMapFunction = Widget Function(BuildContext context);

final class AppRoute {
  const AppRoute._();

  static String splash = "/";
  static String home = "/home";

  static Map<String, AppRouteMapFunction> routes = {
    home: (context) => const HomeView(),
    splash: (context) => const SplashView(),
  };
}

