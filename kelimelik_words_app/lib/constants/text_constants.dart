// 📃 <----- text_constants.dart ----->
// Sık kullanılan text formatlarını burada belirliyoruz.
// böylece tek noktadan tüm formata müdahale etme şansımız var.

import 'package:material_ui/material_ui.dart';

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

/// 📌 Kelime var text stili
final kelimeExistText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.orange.shade800,
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

/// 📌 Drawer Menü subtitle text stili
var drawerMenuSubtitleText = const TextStyle(
  color: Colors.white54,
  fontSize: 12,
);

/// 📌 Pie Chart text stili
var pieChartText = const TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

/// 📌 Kelime İstatistik liste text stili
final kelimeStatText = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

/// 📌 anlam İstatistik liste text stili
const anlamStatText = TextStyle(
  fontSize: 10,
  // fontWeight: FontWeight.bold,
  color: Colors.blue,
);

/// 📌 legend text stili
const legendText = TextStyle(
  fontSize: 8,
  // fontWeight: FontWeight.bold,
  color: Colors.blue,
);
