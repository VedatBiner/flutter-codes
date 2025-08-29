// 📃 <----- text_constants.dart ----->
// Sık kullanılan text formatlarını burada belirliyoruz.
// böylece tek noktadan tüm formata müdahale etme şansımız var.

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import 'color_constants.dart';

/// 📌 Kelime text stili
const kelimeText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

/// 📌 Kelime eklendi text stili
const kelimeAddText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.blueAccent,
);

/// 📌 Kelime güncellendi text stili
final kelimeUpdateText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.green.shade800,
);

/// 📌 Kelime var text stili
final kelimeExistText = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.amber,
);

/// 📌 anlam text stili
const anlamText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.blue,
);

/// 📌 Edit Button Text  stili
const editButtonText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.amberAccent,
);

/// 📌 Siyah Text  stili
const normalBlackText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

/// 📌 Dialog Başlığı
var dialogTitle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: menuColor,
);

/// 📌 Drawer menü stil
const drawerMenuText = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

/// 📌 Versiyon stili
const versionText = TextStyle(
  fontSize: 12,
  color: Colors.amberAccent,
  fontWeight: FontWeight.bold,
);

/// 📌 name stili
var nameText = TextStyle(fontSize: 12, color: menuColor);

/// 📌 Veri Yükleniyor stili
const veriYukleniyor = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

/// 📌 Veri Yüzdesi stili
const veriYuzdesi = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.blueAccent,
);

/// 📌 Arama kutusu hint text stili
const hintStil = TextStyle(color: Colors.grey, fontSize: 16);

/// 📌 AppBar Item Count text stili
var itemCountStil = TextStyle(
  color: menuColor,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

/// 📌 Loading Card word text stili
var loadingWordText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.red[700],
);

/// 📌 Word Count başlık text stili
var dbLoadingMsgText = TextStyle(
  color: menuColor,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

/// 📌 Drawer Menü başlık text stili
var drawerMenuTitleText = TextStyle(
  color: menuColor,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

/// 📌 detay başlığı text stili
const detailTextBlue = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 24,
  color: Colors.blue,
);

/// 📌 Tablo başlığı Text  stili
const tableHeaderText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

/// 📌 Notification Başlığı Text stili
const notificationTitle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

/// 📌 Notification Maddeleri Text stili
const notificationItem = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.blue,
);

/// 📌 Notification info Text stili
const notificationText = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.black54,
);

/// 📌 AppBar altındaki yazı
var subtitleText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: menuColor,
  backgroundColor: drawerColor,
);
