/// <----- app_routes.dart ----->

import 'package:flutter/material.dart';

import '../help_pages/sayfa_cinsiyet.dart';
import '../help_pages/sayfa_cogul.dart';
import '../help_pages/sayfa_gecisli_donuslu_fiiller.dart';
import '../help_pages/sayfa_kiril.dart';
import '../help_pages/sayfa_latin.dart';
import '../help_pages/sayfa_simdiki_genis_zaman.dart';
import '../help_pages/sayfa_soru.dart';
import '../help_pages/sayfa_zamir.dart';
import '../screens/home_page.dart';
import '../screens/login_page.dart';
import '../screens/splash_page.dart';

typedef AppRouteMapFunction = Widget Function(BuildContext context);

final class AppRoute {
  const AppRoute._();

  static String splash = "/";
  static String home = "/home";
  static String login ="/login";
  static String latin = "/home/latin";
  static String kiril = "/home/kiril";
  static String cinsiyet = "/home/cinsiyet";
  static String cogul = "/home/cogul";
  static String zamir = "/home/zamir";
  static String soru = "/home/soru";
  static String simdikiGenisZaman = "/home/simdikiGenisZaman";
  static String gecisliDonusluFiller = "/home/gecisliDonusluFiller";

  static Map<String, AppRouteMapFunction> routes = {
    home: (context) => const HomePage(),
    splash: (context) => const SplashView(),
    login : (context) => LoginPage(),
    latin: (context) => _buildSayfaLatin(context),
    kiril: (context) => _buildSayfaKiril(context),
    cinsiyet: (context) => _buildSayfaCinsiyet(context),
    cogul: (context) => _buildSayfaCogul(context),
    zamir: (context) => _buildSayfaZamir(context),
    soru: (context) => _buildSayfaSoru(context),
    simdikiGenisZaman: (context) => _buildSayfaSimdikiGenisZaman(context),
    gecisliDonusluFiller: (context) => _buildSayfaGecisliDonusluFiiller(context),
  };

  static Widget _buildSayfaLatin(BuildContext context) {
    return const SayfaLatin();
  }

  static Widget _buildSayfaKiril(BuildContext context) {
    return const SayfaKiril();
  }

  static Widget _buildSayfaCinsiyet(BuildContext context) {
    return const SayfaCinsiyet();
  }

  static Widget _buildSayfaCogul(BuildContext context) {
    return const SayfaCogul();
  }

  static Widget _buildSayfaZamir(BuildContext context) {
    return const SayfaZamir();
  }

  static Widget _buildSayfaSoru(BuildContext context) {
    return const SayfaSoru();
  }

  static Widget _buildSayfaSimdikiGenisZaman(BuildContext context) {
    return const SimdikiGenisZaman();
  }

  static Widget _buildSayfaGecisliDonusluFiiller(BuildContext context) {
    return const SayfaGecisliDonusluFiiller();
  }
}
