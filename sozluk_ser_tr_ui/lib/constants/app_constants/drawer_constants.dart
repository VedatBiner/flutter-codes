import '../../services/app_routes.dart';

/// Drawer Items
final List<Map<String, dynamic>> drawerItems = [
  {"title": "Alfabe (Latin)", "page": AppRoute.latin},
  {"title": "Alfabe (Kiril)", "page": AppRoute.kiril},
  {"title": "İsimlerde Cinsiyet", "page": AppRoute.cinsiyet},
  {"title": "İsimlerde Çoğul Kullanım", "page": AppRoute.cogul},
  {"title": "Şahıs Zamirleri", "page": AppRoute.zamir},
  {"title": "Soru Cümleleri", "page": AppRoute.soru},
  {"title": "Şimdiki Geniş Zaman", "page": AppRoute.simdikiGenisZaman},
  {
    "title": "Geçişli ve Dönüşlü Fiiller",
    "page": AppRoute.gecisliDonusluFiller
  },
  {"title": "İşaret Sıfatları", "page": AppRoute.isaretSifatlari},
  {"title": "Sahiplik Sıfatları", "page": AppRoute.sahiplikSifatlari},
  {"title": "Gelecek Zaman", "page": AppRoute.gelecekZaman},
];

/// Drawer titles
const String drawerTitle = "Yardımcı Bilgiler";
const String appBarMainTitleSecond = "Sırpça-Türkçe Sözlük";
const String appBarMainTitleFirst = "Türkçe-Sırpça Sözlük";
const String appBarDetailsTitle = "Details Page";
const String appBarLatinTitle = "Sırpça 'da Latin Harfleri";
const String appBarKirilTitle = "Sırpça 'da Kiril Harfleri";
const String appBarCogulTitle = "İsimlerin Çoğul Halleri";
const String appBarCinsiyetTitle = "İsimlerde Cinsiyet";
const String appBarZamirTitle = "Şahıs Zamirleri";
const String appbarSoruTitle = "Soru Cümleleri";
const String appBarSimdikiGenisZamanTitle = "Şimdiki Geniş Zaman";
const String appBarGecisliDonusluFillerTitle = "Geçişli ve Dönüşlü Fiiller";
const String appBarIsaretSifatlariTitle = "İşaret Sıfatları";
const String appBarSahiplikSifatlariTitle = "Sahiplik Sıfatları";
const String appBarGelecekZamanTitle = "Gelecek Zaman";
const String appBarSettingsTitle = "Settings Page";