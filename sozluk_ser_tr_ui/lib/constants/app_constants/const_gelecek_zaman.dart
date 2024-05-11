/// <----- const_gelecek_zaman.dart ----->
library;

/// Gelecek Zaman - Genel yapı
final List<Map<String, String>> gelecekZamanSampleA = [
  {
    'şahıs': 'şahıs',
    'çekim': 'çekim',
    'kısa çekim': 'kısa çekim',
    'olumsuz': 'olumsuz',
  },
  {
    'şahıs': 'ja',
    'çekim': 'hoću',
    'kısa çekim': 'ću',
    'olumsuz': 'neću',
  },
  {
    'şahıs': 'ti',
    'çekim': 'hoćeš',
    'kısa çekim': 'ćeš',
    'olumsuz': 'nećeš',
  },
  {
    'şahıs': 'on / ona',
    'çekim': 'hoće',
    'kısa çekim': 'će',
    'olumsuz': 'neće',
  },
  {
    'şahıs': 'mi',
    'çekim': 'hoćemo',
    'kısa çekim': 'ćemo',
    'olumsuz': 'nećemo',
  },
  {
    'şahıs': 'vi',
    'çekim': 'hoćete',
    'kısa çekim': 'ćete',
    'olumsuz': 'nećete',
  },
  {
    'şahıs': 'oni / one',
    'çekim': 'hoće',
    'kısa çekim': 'će',
    'olumsuz': 'neće',
  },
];

/// Örnek - razumjeti (anlamak) fiili
final List<Map<String, String>> gelecekZamanSampleB = [
  {
    'şahıs': 'şahıs',
    'kısa çekim': 'kısa çekim',
    'fiil': 'fiil',
    'türkçe': 'türkçe',
  },
  {
    'şahıs': 'ja',
    'kısa çekim': 'ću',
    'fiil': 'razumjeti',
    'türkçe': 'Anlayacağım',
  },
  {
    'şahıs': 'ti',
    'kısa çekim': 'ćeš',
    'fiil': 'razumjeti',
    'türkçe': 'Anlayacaksın',
  },
  {
    'şahıs': 'on / ona',
    'kısa çekim': 'će',
    'fiil': 'razumjeti',
    'türkçe': 'Anlayacak',
  },
  {
    'şahıs': 'mi',
    'kısa çekim': 'ćemo',
    'fiil': 'razumjeti',
    'türkçe': 'Anlayacağız',
  },
  {
    'şahıs': 'vi',
    'kısa çekim': 'ćete',
    'fiil': 'razumjeti',
    'türkçe': 'Anlayacaksınız',
  },
  {
    'şahıs': 'oni / one',
    'kısa çekim': 'će',
    'fiil': 'razumjeti',
    'türkçe': 'Anlayacaklar',
  },
];

/// Örnek cümleler
final List<Map<String, String>> gelecekZamanSampleC = [
  {
    'türkçe': 'türkçe',
    'sırpça': 'sırpça',
  },
  {
    'türkçe': 'kitap okuyacaklar',
    'sırpça': 'Oni /  one će ćitati knjigu',
  },
  {
    'türkçe': 'Ne zaman görüşeceğiz?',
    'sırpça': 'Kada ćemo se vidjeti?',
  },
  {
    'türkçe': 'Oynayacak mı?',
    'sırpça': 'Hoće li igrati? / da li će igrati?',
  },
  {
    'türkçe': 'Gelmeyecekler mi?',
    'sırpça': 'zar nece doći? / nece li doći?',
  },
];

/// Örnek - biti (olmak)
final List<Map<String, String>> gelecekZamanSampleD = [
  {
    'uzun': 'uzun',
    'boşnakça-hırvatça': 'boşnakça-hırvatça',
    'sırpça': 'sırpça',
  },
  {
    'uzun': 'Ja ću biti',
    'boşnakça-hırvatça': 'bit ću',
    'sırpça': 'biću',
  },
  {
    'uzun': 'Ti ćeš biti',
    'boşnakça-hırvatça': 'bit ćeš',
    'sırpça': 'bićeš',
  },
  {
    'uzun': 'On / ona će biti',
    'boşnakça-hırvatça': 'bit će',
    'sırpça': 'biće',
  },
  {
    'uzun': 'Mi ćemo biti',
    'boşnakça-hırvatça': 'bit ćemo',
    'sırpça': 'bićemo',
  },
  {
    'uzun': 'Vi ćete biti',
    'boşnakça-hırvatça': 'bit ćete',
    'sırpça': 'bićete',
  },
  {
    'uzun': 'Oni / one će biti',
    'boşnakça-hırvatça': 'bit će',
    'sırpça': 'biće',
  },
];

/// Örnek - govoriti (konuşmak)
final List<Map<String, String>> gelecekZamanSampleE = [
  {
    'uzun': 'uzun',
    'boşnakça-hırvatça': 'boşnakça-hırvatça',
    'sırpça': 'sırpça',
  },
  {
    'uzun': 'Ja ću govoriti',
    'boşnakça-hırvatça': 'govorit ću',
    'sırpça': 'govoriću',
  },
  {
    'uzun': 'Ti ćeš govoriti',
    'boşnakça-hırvatça': 'govorit ćeš',
    'sırpça': 'govorićeš',
  },
  {
    'uzun': 'On / ona će govoriti',
    'boşnakça-hırvatça': 'govorit će',
    'sırpça': 'govoriće',
  },
  {
    'uzun': 'Mi ćemo govoriti',
    'boşnakça-hırvatça': 'govorit ćemo',
    'sırpça': 'govorićemo',
  },
  {
    'uzun': 'Vi ćete govoriti',
    'boşnakça-hırvatça': 'govorit ćete',
    'sırpça': 'govorićete',
  },
  {
    'uzun': 'Oni / one će govoriti',
    'boşnakça-hırvatça': 'govorit će',
    'sırpça': 'govoriće',
  },
];

/// Örnek - hodati (yürümek)
final List<Map<String, String>> gelecekZamanSampleF = [
  {
    'uzun': 'uzun',
    'boşnakça-hırvatça': 'boşnakça-hırvatça',
    'sırpça': 'sırpça',
  },
  {
    'uzun': 'Ja ću hodati',
    'boşnakça-hırvatça': 'hodat ću',
    'sırpça': 'hodaću',
  },
  {
    'uzun': 'Ti ćeš hodati',
    'boşnakça-hırvatça': 'hodat ćeš',
    'sırpça': 'hodaćeš',
  },
  {
    'uzun': 'On / ona će hodati',
    'boşnakça-hırvatça': 'hodat će',
    'sırpça': 'hodaće',
  },
  {
    'uzun': 'Mi ćemo hodati',
    'boşnakça-hırvatça': 'hodat ćemo',
    'sırpça': 'hodaćemo',
  },
  {
    'uzun': 'Vi ćete hodati',
    'boşnakça-hırvatça': 'hodat ćete',
    'sırpça': 'hodaćete',
  },
  {
    'uzun': 'Oni / one će hodati',
    'boşnakça-hırvatça': 'hodat će',
    'sırpça': 'hodaće',
  },
];

/// Örnek - Reći (demek)
final List<Map<String, String>> gelecekZamanSampleG = [
  {
    'uzun': 'uzun',
    'kısa': 'kısa',
  },
  {
    'uzun': 'Ja ću Reći',
    'kısa': 'Reći ću',
  },
  {
    'uzun': 'Ti ćeš Reći',
    'kısa': 'Reći ćeš',
  },
  {
    'uzun': 'On / ona će Reći',
    'kısa': 'Reći će',
  },
  {
    'uzun': 'Mi ćemo Reći',
    'kısa': 'Reći ćemo',
  },
  {
    'uzun': 'Vi ćete Reći',
    'kısa': 'Reći ćete',
  },
  {
    'uzun': 'Oni / one će Reći',
    'kısa': 'Reći će',
  },
];

/// Özne düşürmeden kullanım
final List<Map<String, String>> gelecekZamanSampleH = [
  {
    'özne': 'özne',
    'çekim': 'çekim',
    'isim': 'isim',
  },
  {
    'özne': 'ja',
    'çekim': 'sam',
    'isim': 'dobro',
  },
  {
    'özne': 'ti',
    'çekim': 'si',
    'isim': 'dobro',
  },
  {
    'özne': 'on / ona',
    'çekim': 'je',
    'isim': 'dobro',
  },
  {
    'özne': 'mi',
    'çekim': 'smo',
    'isim': 'dobro',
  },
  {
    'özne': 'vi',
    'çekim': 'ste',
    'isim': 'dobro',
  },
  {
    'özne': 'oni / one',
    'çekim': 'su',
    'isim': 'dobro',
  },
];

/// Özne düşürerek kullanım
final List<Map<String, String>> gelecekZamanSampleI = [
  {
    'isim': 'isim',
    'çekim': 'çekim',
  },
  {
    'isim': 'dobro',
    'çekim': 'sam',
  },
  {
    'isim': 'dobro',
    'çekim': 'si',
  },
  {
    'isim': 'dobro',
    'çekim': 'je',
  },
  {
    'isim': 'dobro',
    'çekim': 'smo',
  },
  {
    'isim': 'dobro',
    'çekim': 'ste',
  },
  {
    'isim': 'dobro',
    'çekim': 'su',
  },
];