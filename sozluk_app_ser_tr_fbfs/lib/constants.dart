/// <----- constants.dart ----->

import 'package:flutter/material.dart';

const detailTextRed = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 40,
  color: Colors.red,
);

const detailTextBlue = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 40,
  color: Colors.blue,
);

const baslikTextWhite = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const baslikTextBlack = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const baslikTextBlack87 =  TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.black87,
);

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

final List<Map> cinsiyetSample = [
  {'erkek': 'erkek', 'dişi': 'dişi', 'nötr': 'nötr'},
  {
    'erkek': 'ormar (dolap)',
    'dişi': 'stolica (sandalye)',
    'nötr': 'računalo (bilgisayar -Hırvatça)'
  },
  {
    'erkek': 'računar (bilgisayar)',
    'dişi': 'banana (muz)',
    'nötr': 'more (deniz)'
  },
];

/// Çoğul örnekleri - sessiz harfle bitenler
final List<Map<String, String>> cogulSampleA = [
  {'tekil': 'tekil', 'çoğul': 'çoğul',},
  {
    'tekil': 'jezik (dil)',
    'çoğul': 'jezici (diller)',
  },
  {
    'tekil': 'ekran (ekran)',
    'çoğul': 'ekrani (ekranlar)',
  },
  {
    'tekil': 'psiholog (psikolog)',
    'çoğul': 'psiholozi (psikologlar)',
  },
  {
    'tekil': 'prozor (pencere)',
    'çoğul': 'prozori (pencereler)',
  },
  {
    'tekil': 'neuspjeh (başarısızlık)',
    'çoğul': 'neuspjesi (başarısızlıklar)',
  },
  {
    'tekil': 'prijately (arkadaş)',
    'çoğul': 'prijatelji (arkadaşlar)',
  },
];

/// Çoğul örnekleri - a harfi ile bitenler
final List<Map<String, String>> cogulSampleB = [
  {'tekil': 'tekil', 'çoğul': 'çoğul',},
  {
    'tekil': 'jabuka (elma)',
    'çoğul': 'jabuke (elmalar)',
  },
  {
    'tekil': 'boja (renk)',
    'çoğul': 'boje (renkler)',
  },
  {
    'tekil': 'škola (okul)',
    'çoğul': 'škole (okullar)',
  },
  {
    'tekil': 'mačka (kedi)',
    'çoğul': 'mačke (kediler)',
  },
  {
    'tekil': 'igra (oyun)',
    'çoğul': 'igre (oyunlar)',
  },
  {
    'tekil': 'lubenica (karpuz)',
    'çoğul': 'lubenice (karpuzlar)',
  },
];

/// Çoğul örnekleri - "o" veya "e" harfi ile bitenler
final List<Map<String, String>> cogulSampleC = [
  {'tekil': 'tekil', 'çoğul': 'çoğul',},
  {
    'tekil': 'selo (köy)',
    'çoğul': 'sela (köyler)',
  },
  {
    'tekil': 'jaje (yumurta)',
    'çoğul': 'jaja (yumurtalar)',
  },
  {
    'tekil': 'pismo (mektup)',
    'çoğul': 'pisma (mektuplar)',
  },
  {
    'tekil': 'lice (yüz)',
    'çoğul': 'lica (yüzler)',
  },
  {
    'tekil': 'staklo (cam)',
    'çoğul': 'stakla (camlar)',
  },
  {
    'tekil': 'razočaranje (hayal kırıklığı)',
    'çoğul': 'razočaranja (hayal kırıklıkları)',
  },
];

/// Çoğul örnekleri - "ac" ile bitip, "a" düşen "i" eklenenler
final List<Map<String, String>> cogulSampleD = [
  {'tekil': 'tekil', 'çoğul': 'çoğul',},
  {
    'tekil': 'Muškarac (adam)',
    'çoğul': 'Muškarci (adamlar)',
  },
  {
    'tekil': 'Bosanac (Boşnak adam)',
    'çoğul': 'Bosanci (Boşnak Adamlar)',
  },
  {
    'tekil': 'Blizanac (İkiz erkek)',
    'çoğul': 'Blizanci (ikiz erkekler)',
  },
];

/// Çoğul örnekleri - tek heceli erkek cins isimlerde son harfe "
/// "göre -ovi / -evi (-	C / Č / Ć / Đ / Ž / Š / J / LJ / NJ ile "
/// "bitenlere) eklerinden biri eklenir.
final List<Map<String, String>> cogulSampleE = [
  {'tekil': 'tekil', 'çoğul': 'çoğul',},
  {
    'tekil': 'Nož (Bıçak)',
    'çoğul': 'Noževi (Bıçaklar)',
  },
  {
    'tekil': 'Čaj (Çay)',
    'çoğul': 'Čajevi (Çaylar)',
  },
  {
    'tekil': 'Spoj (Bağlantı)',
    'çoğul': 'Spojevi (Bağlantılar)',
  },
  {
    'tekil': 'Led (buz)',
    'çoğul': 'Ledovi (Buzlar)',
  },
  {
    'tekil': 'Slon (Fil)',
    'çoğul': 'Slonovi (Filler)',
  },
  {
    'tekil': 'Brod (Gemi)',
    'çoğul': 'Brodovi (Gemiler)',
  },
];