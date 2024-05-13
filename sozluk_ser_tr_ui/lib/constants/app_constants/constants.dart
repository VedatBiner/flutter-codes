/// <----- constants.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/app_routes.dart';

Color drawerColor = const Color(0xFF4C3398);
Color menuColor = const Color(0xFFFFD300);
Color cardDarkMode = const Color(0xFF0C2F7A);
Color cardLightMode = const Color(0xFFCFE9DF);
Color cardLightModeText1 = Colors.red.shade400;
Color cardLightModeText2 = Colors.indigo.shade900;
Color cardDarkModeText1 = Colors.amberAccent.shade400;
Color cardDarkModeText2 = Colors.lightBlueAccent.shade200;

TextStyle glutenFontText = TextStyle(
  fontFamily: GoogleFonts.gluten().fontFamily,
  fontSize: 24,
  color: Colors.indigoAccent,
);

const listTextRed = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: Colors.red,
);

const listTextBlue = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.blue,
);

/// Girilen kelime sayısı mesaj stili
const noOfWordsText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

/// Girilen kelime sayısı
const noOfWordsCount = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.indigo,
);

/// detay sayfası text stili
const detailTextRed = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 28,
  color: Colors.red,
);

/// detay sayfası text stili
const detailTextBlue = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 28,
  color: Colors.blue,
);

/// kelime ekleme / düzeltme stili
TextStyle butonTextDialog = TextStyle(
  fontWeight: FontWeight.bold,
  color: menuColor,
);

const baslikTextWhite = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

/// Giriş ve Kaydol buton Stili
TextStyle buttonRL = TextStyle(
  fontWeight: FontWeight.bold,
  color: menuColor,
  fontSize: 18,
);

/// Android için stil
const TextStyle androidTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: Colors.blueAccent,
);

/// Web için stil
const TextStyle webTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: Colors.blue,
);

/// kelime ekle/dil/düzelt stili
const TextStyle kelimeStil = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.red,
  fontSize: 16,
);

/// kelime ekle/sil/düzelt maail
const TextStyle userStil = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.blue,
  fontSize: 16,
);

const baslikTextBlack = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const baslikTextBlack87 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.black87,
);

TextStyle baslikTextDrawer = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: menuColor,
);

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

/// Message Constants
const String wrongMailFormat = "email adresiniz doğru formatta değil !!!";
const String blankMailAndPassword =
    "E-mail ve şifre alanları boş bırakılamaz !!!";
const String passwordSize = "Şifreler sekiz (8) karakterden küçük olamaz !!!";
const String registrationOk =
    "Kayıt başarıyla tamamlandı. Giriş yapabilirsiniz.";
const String checkPasswords = "Şifreler eşleşmiyor ...";
const String googleSignInMsg = "Google ile Giriş";
const String googleSignInFailMsg = "Google ile oturum açma işlemi başarısız.";

/// Hint Text Constants
const String hintEmail = "e-mail adresi";
const String hintPassword = "parola";
const String hintCheckPassword = "parola tekrar";

/// diller - Burada amaç dil adını sadece
/// buradan verip, değişimi tek yerden kontrol etmek
const String birinciDil = "Türkçe";
const String fsBirinciDil = "turkce";
const String firstCountry = "TR";
const String ikinciDil = "Sırpça";
const String fsIkinciDil = "sirpca";
const String secondCountry = "RS";

/// koleksiyon adını burada belirtelim
const String collectionName = 'kelimeler';

/// mail adresi
const String fsUserEmail = "userEmail";

/// girilen kelime sayısı
const String noOfWordsEntered = "Girilen kelime sayısı: ";

/// Girilen kelime sayısı bulunamadı hatası
const String noOfWordsErrorMsg = 'Girilen kelime sayısı: Hesaplanamadı';

/// update mesajı
const String updateMsg = " tarafından düzeltilmiştir...";

/// add mesajı
const String addMsg = " tarafından eklenmiştir...";

/// delete mesajı
const String deleteMsg = " tarafından silinmiştir...";

/// Settings Buton labels
const String jsonMsg = "Firestore verisini JSON verisine çevir";
const String sqfliteMsg = "JSON verisini Sqflite veri tabanına  çevir";

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

/// Latin Harfleri
final List<Map<String, String>> latinAlphabet = [
  {'turkce': "Türkçe Harfler", 'sirpca': 'Sırpça Karşılıkları'},
  {'turkce': "A", 'sirpca': 'A a'},
  {'turkce': "B", 'sirpca': 'B b'},
  {'turkce': "C", 'sirpca': 'Dž dž - C gibi okunur'},
  {'turkce': "C", 'sirpca': 'Đ đ - C gibi okunur'},
  {'turkce': "Ç", 'sirpca': 'Ć ć - Ç gibi okunur'},
  {'turkce': "Ç", 'sirpca': 'Č ć - Ç gibi okunur'},
  {'turkce': "D", 'sirpca': 'D d'},
  {'turkce': "E", 'sirpca': 'E e'},
  {'turkce': "F", 'sirpca': 'F f'},
  {'turkce': "G", 'sirpca': 'G g'},
  {'turkce': "Ğ", 'sirpca': '- -'},
  {'turkce': "H", 'sirpca': 'H h'},
  {'turkce': "I", 'sirpca': '- -'},
  {'turkce': "İ", 'sirpca': 'I i'},
  {'turkce': "J", 'sirpca': 'Ž ž - J gibi okunur'},
  {'turkce': "K", 'sirpca': 'K k'},
  {'turkce': "L", 'sirpca': 'L l'},
  {'turkce': "M", 'sirpca': 'M m'},
  {'turkce': "N", 'sirpca': 'N n'},
  {'turkce': "O", 'sirpca': 'O o'},
  {'turkce': "Ö", 'sirpca': '- -'},
  {'turkce': "P", 'sirpca': 'P p'},
  {'turkce': "R", 'sirpca': 'R r'},
  {'turkce': "S", 'sirpca': 'S s'},
  {'turkce': "Ş", 'sirpca': 'Š š - Ş okunur'},
  {'turkce': "T", 'sirpca': 'T t'},
  {'turkce': "U", 'sirpca': 'U u'},
  {'turkce': "Ü", 'sirpca': 'ju - yu gibi kullanılır ama normalde yok'},
  {'turkce': "V", 'sirpca': 'V v'},
  {'turkce': "Y", 'sirpca': 'J j - Y okunur'},
  {'turkce': "Z", 'sirpca': 'Z z'},
  {'turkce': "TS", 'sirpca': 'C c - ts okunur'},
  {'turkce': "LY", 'sirpca': 'LJ lj - ly okunur'},
  {'turkce': "NY", 'sirpca': 'NJ nj - ny okunur'},
];

/// Kiril Harfleri
final List<Map<String, String>> kirilAlphabet = [
  {'turkce': "Türkçe Harfler", 'sirpca': 'Sırpça Karşılıkları'},
  {'turkce': "A", 'sirpca': 'A a'},
  {'turkce': "B", 'sirpca': 'Б б'},
  {'turkce': "C", 'sirpca': 'Џ џ - C gibi okunur'},
  {'turkce': "C", 'sirpca': 'Ђ ђ - C gibi okunur'},
  {'turkce': "Ç", 'sirpca': 'Ћ ћ - Ç gibi okunur'},
  {'turkce': "Ç", 'sirpca': 'Ч ч - Ç gibi okunur'},
  {'turkce': "D", 'sirpca': 'Д д'},
  {'turkce': "E", 'sirpca': 'E e'},
  {'turkce': "F", 'sirpca': 'Ф ф'},
  {'turkce': "G", 'sirpca': 'Г г'},
  {'turkce': "Ğ", 'sirpca': '- -'},
  {'turkce': "H", 'sirpca': 'Х х'},
  {'turkce': "I", 'sirpca': '- -'},
  {'turkce': "İ", 'sirpca': 'И и'},
  {'turkce': "J", 'sirpca': 'Ж ж - J gibi okunur'},
  {'turkce': "K", 'sirpca': 'К к'},
  {'turkce': "L", 'sirpca': 'Л л'},
  {'turkce': "M", 'sirpca': 'М м'},
  {'turkce': "N", 'sirpca': 'Н н'},
  {'turkce': "O", 'sirpca': 'О о'},
  {'turkce': "Ö", 'sirpca': '- -'},
  {'turkce': "P", 'sirpca': 'П п'},
  {'turkce': "R", 'sirpca': 'Р р'},
  {'turkce': "S", 'sirpca': 'С с'},
  {'turkce': "Ş", 'sirpca': 'Ш ш - Ş okunur'},
  {'turkce': "T", 'sirpca': 'Т т'},
  {'turkce': "U", 'sirpca': 'U u'},
  {'turkce': "Ü", 'sirpca': 'Ју ју - yu gibi kullanılır ama normalde yok'},
  {'turkce': "V", 'sirpca': 'В в'},
  {'turkce': "Y", 'sirpca': 'J j - Y okunur'},
  {'turkce': "Z", 'sirpca': 'З з'},
  {'turkce': "TS", 'sirpca': 'Ц ц - ts okunur'},
  {'turkce': "LY", 'sirpca': 'Љ љ - ly okunur'},
  {'turkce': "NY", 'sirpca': 'Њ њ - ny okunur'},
];

final List<Map<String, String>> cinsiyetSample = [
  {'erkek': 'erkek', 'dişi': 'dişi', 'nötr': 'nötr'},
  {
    'erkek': 'ormar (dolap)',
    'dişi': 'stolica (sandalye)',
    'nötr': 'računalo (bilgisayar -Hırvatça)'
  },
  {
    'erkek': 'računar (bilgisayar)',
    'dişi': 'banana (muz)',
    'nötr': 'more (deniz)',
  },
];
