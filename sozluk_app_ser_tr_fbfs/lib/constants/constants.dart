/// <----- constants.dart ----->

import 'package:flutter/material.dart';

Color drawerColor = const Color(0xFF4C3398);

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

const baslikTextBlack87 = TextStyle(
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
  {
    'tekil': 'tekil',
    'çoğul': 'çoğul',
  },
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
  {
    'tekil': 'tekil',
    'çoğul': 'çoğul',
  },
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
  {
    'tekil': 'tekil',
    'çoğul': 'çoğul',
  },
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
  {
    'tekil': 'tekil',
    'çoğul': 'çoğul',
  },
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
  {
    'tekil': 'tekil',
    'çoğul': 'çoğul',
  },
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

/// Çoğul Kelime Örnekleri
final List<Map<String, String>> cogulSampleF = [
  {
    'tekil': 'tekil',
    'çoğul': 'çoğul',
  },
  {
    'tekil': 'Nož (Bıçak)',
    'çoğul': 'Noževi (Bıçaklar)',
  },
  {
    'tekil': 'Čaj (Çay)',
    'çoğul': 'Čajevi (Çaylar)',
  },
  {
    'tekil': 'Avion (Uçak)',
    'çoğul': 'Avioni (Uçaklar)',
  },
  {
    'tekil': 'Voz (Tren)',
    'çoğul': 'Vozovi (Trenler)',
  },
  {
    'tekil': 'Maslina (Zeytin)',
    'çoğul': 'Masline (Zeytinler)',
  },
  {
    'tekil': 'Žito (Tahıl)',
    'çoğul': 'Žita (Tahıllar)',
  },
  {
    'tekil': 'Krompir (Patates)',
    'çoğul': 'Krompiri (patatesler)',
  },
  {
    'tekil': 'Kapa (Başlık)',
    'çoğul': 'Kape (başlıklar)',
  },
  {
    'tekil': 'Zvono (Zil)',
    'çoğul': 'Zvona (ziller)',
  },
  {
    'tekil': 'Ogledalo (Ayna)',
    'çoğul': 'Ogledala (aynalar)',
  },
];

/// Çoğul Kelime Örnekleri
final List<Map<String, String>> zamirlerSample = [
  {
    'tekil': 'tekil',
    'çoğul': 'çoğul',
  },
  {
    'tekil': 'Ja (ben)',
    'çoğul': 'Mi (biz)',
  },
  {
    'tekil': 'Ti (sen)',
    'çoğul': 'Vi (siz)',
  },
  {
    'tekil': 'On (erkek o) / Ona (dişi o) / Ono (Nötr)',
    'çoğul': 'Oni (Erkek onlar) / One (Dişi onlar) / Ona (Nötr)',
  },
];

/// olmak fili - olumlu/ olumsuz /soru kalıbı
final List<Map<String, String>> olmakSampleTr = [
  {
    'olumlu': 'olumlu',
    'olumsuz': 'olumsuz',
    'soru': 'soru',
  },
  {
    'olumlu': 'ben öğrenciyim.',
    'olumsuz': 'ben öğrenci değilim.',
    'soru': 'ben öğrenci miyim ?',
  },
  {
    'olumlu': 'sen öğrencisin.',
    'olumsuz': 'sen öğrenci değilsin.',
    'soru': 'sen öğrenci misin?',
  },
  {
    'olumlu': 'o öğrenci.',
    'olumsuz': 'o öğrenci değil.',
    'soru': 'o öğrenci mi?',
  },
  {
    'olumlu': 'biz öğrenciyiz.',
    'olumsuz': 'biz öğrenci değiliz.',
    'soru': 'biz öğrenci miyiz ?',
  },
  {
    'olumlu': 'siz öğrencisiniz.',
    'olumsuz': 'siz öğrenci değilsiniz.',
    'soru': 'siz öğrenci misiniz?',
  },
  {
    'olumlu': 'onlar öğrenci.',
    'olumsuz': 'onlar öğrenci değil.',
    'soru': 'onlar öğrenci mi?',
  },
];

/// Biti - olmak fili - vurgulu / vurgusuz
final List<Map<String, String>> olmakSampleSer = [
  {
    'zamir': 'zamir',
    'vurgulu': 'vurgulu',
    'vurgusuz': 'vurgusuz',
  },
  {
    'zamir': 'ja',
    'vurgulu': 'sam',
    'vurgusuz': 'jesam',
  },
  {
    'zamir': 'ti',
    'vurgulu': 'si',
    'vurgusuz': 'jesi',
  },
  {
    'zamir': 'on / ona / ono',
    'vurgulu': 'je',
    'vurgusuz': 'jest(e)',
  },
  {
    'zamir': 'mi',
    'vurgulu': 'smo',
    'vurgusuz': 'jesmo',
  },
  {
    'zamir': 'vi',
    'vurgulu': 'ste',
    'vurgusuz': 'jeste',
  },
  {
    'zamir': 'oni / one / ona',
    'vurgulu': 'su',
    'vurgusuz': 'jesu',
  },
];

/// Şahıs zamirleri olumlu / olumsuz
final List<Map<String, String>> zamirlerSampleA = [
  {
    'olumlu': 'olumlu',
    'olumsuz': 'olumsuz',
  },
  {
    'olumlu': 'ja',
    'olumsuz': 'nisam',
  },
  {
    'olumlu': 'ti',
    'olumsuz': 'nisi',
  },
  {
    'olumlu': 'on / ona /ono',
    'olumsuz': 'nije',
  },
  {
    'olumlu': 'mi',
    'olumsuz': 'nismo',
  },
  {
    'olumlu': 'vi',
    'olumsuz': 'niste',
  },
  {
    'olumlu': 'oni / one / ona',
    'olumsuz': 'nisu',
  },
];

/// Olmak fiili olumlu cümleler
final List<Map<String, String>> zamirlerSampleB = [
  {
    'özne': 'özne',
    'fiil': 'fiil',
    'isim / nesne': ' isim / nesne',
  },
  {
    'özne': 'ja',
    'fiil': 'sam',
    'isim / nesne': 'student (öğrenciyim',
  },
  {
    'özne': 'ti',
    'fiil': 'si',
    'isim / nesne': 'student (öğrencisin)',
  },
  {
    'özne': 'on / ona /ono',
    'fiil': 'je',
    'isim / nesne': 'student (öğrenci)',
  },
  {
    'özne': 'mi',
    'fiil': 'smo',
    'isim / nesne': 'studenti (öğrenciyiz)',
  },
  {
    'özne': 'vi',
    'fiil': 'ste',
    'isim / nesne': 'studenti (öğrencisiniz)',
  },
  {
    'özne': 'oni / one / ono',
    'fiil': 'su',
    'isim / nesne': 'studenti (öğrenciler)',
  },
];

/// Olmak fiili olumlu cümleler (kız)
final List<Map<String, String>> zamirlerSampleC = [
  {
    'özne': 'özne',
    'fiil': 'fiil',
    'isim / nesne': ' isim / nesne',
  },
  {
    'özne': 'ja',
    'fiil': 'sam',
    'isim / nesne': 'studentica (öğrenciyim)',
  },
  {
    'özne': 'ti',
    'fiil': 'si',
    'isim / nesne': 'studentica (öğrencisin)',
  },
  {
    'özne': 'on / ona /ono',
    'fiil': 'je',
    'isim / nesne': 'studentica (öğrenci)',
  },
  {
    'özne': 'mi',
    'fiil': 'smo',
    'isim / nesne': 'studentice (öğrenciyiz)',
  },
  {
    'özne': 'vi',
    'fiil': 'ste',
    'isim / nesne': 'studentice (öğrencisiniz)',
  },
  {
    'özne': 'oni / one / ono',
    'fiil': 'su',
    'isim / nesne': 'studentice (öğrenciler)',
  },
];

/// kako si olumlu cümleler
final List<Map<String, String>> zamirlerSampleD = [
  {
    'özne': 'özne',
    'fiil': 'fiil',
    'isim / nesne': ' isim / nesne',
  },
  {
    'özne': 'ja',
    'fiil': 'sam',
    'isim / nesne': 'dobro (iyiyim)',
  },
  {
    'özne': 'ti',
    'fiil': 'si',
    'isim / nesne': 'dobro (iyisin)',
  },
  {
    'özne': 'on / ona /ono',
    'fiil': 'je',
    'isim / nesne': 'dobro (iyi)',
  },
  {
    'özne': 'mi',
    'fiil': 'smo',
    'isim / nesne': 'dobro (iyiyiz)',
  },
  {
    'özne': 'vi',
    'fiil': 'ste',
    'isim / nesne': 'dobro (iyisiniz)',
  },
  {
    'özne': 'oni / one / ono',
    'fiil': 'su',
    'isim / nesne': 'dobro (iyiler)',
  },
];

/// kako si olumsuz cümleler
final List<Map<String, String>> zamirlerSampleE = [
  {
    'özne': 'özne',
    'fiil': 'fiil',
    'isim / nesne': ' isim / nesne',
  },
  {
    'özne': 'ja',
    'fiil': 'nisam',
    'isim / nesne': 'dobro (iyi değilim)',
  },
  {
    'özne': 'ti',
    'fiil': 'nisi',
    'isim / nesne': 'dobro (iyi değilsin)',
  },
  {
    'özne': 'on / ona /ono',
    'fiil': 'nije',
    'isim / nesne': 'dobro (iyi değil)',
  },
  {
    'özne': 'mi',
    'fiil': 'nismo',
    'isim / nesne': 'dobro (iyi değiliz)',
  },
  {
    'özne': 'vi',
    'fiil': 'niste',
    'isim / nesne': 'dobro (iyi değilsiniz)',
  },
  {
    'özne': 'oni / one / ono',
    'fiil': 'nisu',
    'isim / nesne': 'dobro (iyi değiller)',
  },
];

/// Soru Cümleleri
final List<Map<String, String>> sorularSample = [
  {
    'cümle': 'cümle',
    'soru (li)': 'soru (li)',
    'soru (da li)': 'soru (da li)',
  },
  {
    'cümle': 'ja sam student',
    'soru (li)': 'jesam li (ja) student ?',
    'soru (da li)': 'da li sam ja student?',
  },
  {
    'cümle': 'ti si student',
    'soru (li)': 'jesi li (ti) student ?',
    'soru (da li)': 'da li si ti student?',
  },
  {
    'cümle': 'On / ona je student ',
    'soru (li)': 'je li (on) student ?',
    'soru (da li)': 'da li je on student ? ',
  },
];
