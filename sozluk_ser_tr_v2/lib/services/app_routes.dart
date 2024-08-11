/// <----- app_routes.dart ----->
///
library;

import 'package:flutter/material.dart';

import '../help_pages/sayfa_cinsiyet.dart';
import '../help_pages/sayfa_cogul.dart';
import '../help_pages/sayfa_fiiller_dict.dart';
import '../help_pages/sayfa_gecisli_donuslu_fiiller.dart';
import '../help_pages/sayfa_gelecek_zaman.dart';
import '../help_pages/sayfa_isaret_sifatlari.dart';
import '../help_pages/sayfa_kiril.dart';
import '../help_pages/sayfa_latin.dart';
import '../help_pages/sayfa_sahiplik_sifatlari.dart';
import '../help_pages/sayfa_simdiki_genis_zaman.dart';
import '../help_pages/sayfa_soru.dart';
import '../help_pages/sayfa_zamir.dart';
import '../models/fs_words.dart';
import '../screens/home_page.dart';
import '../screens/auth_page_parts/register_page.dart';
import '../screens/login_page.dart';
import '../screens/settings_page.dart';
import '../screens/splash_page.dart';

typedef AppRouteMapFunction = Widget Function(BuildContext context);

final class AppRoute {
  const AppRoute._();

  static String splash = "/";
  static String home = "/home";
  static String details = "/details";
  static String login = "/login";
  static String register = "/register";
  static String settings = "/settings";
  static String latin = "/home/latin";
  static String kiril = "/home/kiril";
  static String cinsiyet = "/home/cinsiyet";
  static String cogul = "/home/cogul";
  static String zamir = "/home/zamir";
  static String soru = "/home/soru";
  static String simdikiGenisZaman = "/home/simdikiGenisZaman";
  static String gecisliDonusluFiller = "/home/gecisliDonusluFiller";
  static String isaretSifatlari = "/home/isaretSifatlari";
  static String sahiplikSifatlari = "/home/sahiplikSifatlari";
  static String gelecekZaman = "/home/gelecekZaman";
  static String fiillerDict = "/home/fiilerDict";

  static FsWords? word;

  static Map<String, AppRouteMapFunction> routes = {
    home: (context) => const HomePage(),
    splash: (context) => const SplashView(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    settings: (context) => const SettingsPage(),
    latin: (context) => _buildSayfaLatin(context),
    kiril: (context) => _buildSayfaKiril(context),
    cinsiyet: (context) => _buildSayfaCinsiyet(context),
    cogul: (context) => _buildSayfaCogul(context),
    zamir: (context) => _buildSayfaZamir(context),
    soru: (context) => _buildSayfaSoru(context),
    simdikiGenisZaman: (context) => _buildSayfaSimdikiGenisZaman(context),
    gecisliDonusluFiller: (context) =>
        _buildSayfaGecisliDonusluFiiller(context),
    isaretSifatlari: (context) =>
        _buildIsaretSifatlari(context),
    sahiplikSifatlari: (context) =>
        _buildSahiplikSifatlari(context),
    gelecekZaman: (context) =>
        _buildGelecekZaman(context),
    fiillerDict: (context) =>
        _buildFiillerDict(context),
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

  static Widget _buildIsaretSifatlari(BuildContext context) {
    return const SayfaIsaretSifatlari();
  }

  static Widget _buildSahiplikSifatlari(BuildContext context) {
    return const SayfaSahiplikSifatlari();
  }

  static Widget _buildGelecekZaman(BuildContext context) {
    return const SayfaGelecekZaman();
  }

  static Widget _buildFiillerDict(BuildContext context) {
    return const SayfaFiillerDict();
  }

}
