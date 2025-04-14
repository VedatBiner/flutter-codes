// 📃 <----- routes.dart ----->
// Navigasyon buradan yapılacak.
//
import 'package:flutter/material.dart';

import 'constants/help_pages/pages/page_cinsiyet.dart';
import 'constants/help_pages/pages/page_cogul.dart';
import 'constants/help_pages/pages/page_fiiller.dart';
import 'constants/help_pages/pages/page_gecisli_donuslu_fiiler.dart';
import 'constants/help_pages/pages/page_gelecek_zaman.dart';
import 'constants/help_pages/pages/page_isaret_sifatlari.dart';
import 'constants/help_pages/pages/page_kiril.dart';
import 'constants/help_pages/pages/page_latin.dart';
import 'constants/help_pages/pages/page_sahiplik_sifatlari.dart';
import 'constants/help_pages/pages/page_simdiki_genis_zaman.dart';
import 'constants/help_pages/pages/page_soru.dart';
import 'constants/help_pages/pages/page_uzun_kisa_kelimeler.dart';
import 'constants/help_pages/pages/page_zamirler.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/sayfaKiril': (context) => const SayfaKiril(),
  '/sayfaLatin': (context) => const SayfaLatin(),
  '/sayfaCinsiyet': (context) => const SayfaCinsiyet(),
  '/sayfaCogul': (context) => const SayfaCogul(),
  '/sayfaZamir': (context) => const SayfaZamir(),
  '/sayfaSoru': (context) => const SayfaSoru(),
  '/sayfaFiiller': (context) => const SayfaFiillerDict(),
  '/sayfaGecisliDonuslu': (context) => const SayfaGecisliDonusluFiiller(),
  '/sayfaGelecekZaman': (context) => const SayfaGelecekZaman(),
  '/sayfaIsaretSifatlari': (context) => const SayfaIsaretSifatlari(),
  '/sayfaSahiplikSifatlari': (context) => const SayfaSahiplikSifatlari(),
  '/sayfaSimdikiGenisZaman': (context) => const SayfaSimdikiGenisZaman(),
  '/sayfaUzunKisa': (context) => const SayfaUzunKisaKelimeler(),
};
