/// <----- constants.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_constants.dart';

TextStyle glutenFontText = TextStyle(
  fontFamily: GoogleFonts.gluten().fontFamily,
  fontSize: 24,
  color: const Color(0xFFFFD300),
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

/// kelime ekle/sil/düzelt mail
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

/// Kelime Giriş mesajı
const String wordEntryMsg = "kelime giriniz ... ";

/// Kelime karşılık mesajı
const String wordMeanInMsg = "karşılığını giriniz ... ";

/// update mesajı
const String updateMsg = " tarafından düzeltilmiştir...";

/// add mesajı
const String addMsg = " tarafından eklenmiştir...";

/// delete mesajı
const String deleteMsg = " tarafından silinmiştir...";

/// Settings Buton labels
const String jsonMsg = "Firestore verisini JSON verisine çevir";
const String sqfliteMsg = "JSON verisini Sqflite veri tabanına çevir";
const String blankMailMsg = "Boş mail adreslerini düzelt";

/// Dikkat mesaj
const String dikkatMsg = "Dikkat !!!";

/// Dikkat style
const dikkatText = TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.bold,
);

/// silme mesajı
const String silMsg = "Bu kelime Silinecektir!!!";

/// Sil style
const silText = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.blue,
  fontSize: 20,
);

/// Emin soru mesajı
const String eminMsg = "Emin misiniz?";

/// Emin text style
const eminText = TextStyle(
  fontSize: 18,
  color: Colors.red,
  fontWeight: FontWeight.bold,
);


