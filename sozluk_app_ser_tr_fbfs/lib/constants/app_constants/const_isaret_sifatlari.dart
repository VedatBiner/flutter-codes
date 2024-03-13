/// <----- const_isaret_sifatlari.dart ----->
library;

/// Onaj, Taj, Ovaj İşaret sıfatları
final List<Map<String, String>> isaretSifatlariSampleA = [
  {
    'işaret': 'işaret',
    'eril': 'eril',
    'dişil': 'dişil',
    'nötr': 'nötr',
  },
  {
    'işaret': 'bu',
    'eril': 'ovaj',
    'dişil': 'ova',
    'nötr': 'ovo',
  },
  {
    'işaret': 'şu',
    'eril': 'taj',
    'dişil': 'ta',
    'nötr': 'to',
  },
  {
    'işaret': 'o',
    'eril': 'onaj',
    'dişil': 'ona',
    'nötr': 'ono',
  },
  {
    'işaret': 'bunlar',
    'eril': 'ovi',
    'dişil': 'ove',
    'nötr': 'ova',
  },
  {
    'işaret': 'şunlar',
    'eril': 'ti',
    'dişil': 'te',
    'nötr': 'ta',
  },
  {
    'işaret': 'onlar',
    'eril': 'oni',
    'dişil': 'one',
    'nötr': 'ona',
  },
];

/// Onaj, Taj, Ovaj İşaret sıfatları - Örnek
final List<Map<String, String>> isaretSifatlariSampleB = [
  {
    'kelime1': 'Pas (Köpek)',
    'kelime2': 'Škola (Okul)',
    'kelime3': 'Selo (Köy)',
  },
  {
    'kelime1': 'Ovo pas',
    'kelime2': 'Ova škola',
    'kelime3': 'Ovo selo',
  },
  {
    'kelime1': 'Taj pas',
    'kelime2': 'Ta škola',
    'kelime3': 'To selo',
  },
  {
    'kelime1': 'Onaj pas',
    'kelime2': 'Ona škola',
    'kelime3': 'Ono selo',
  },
  {
    'kelime1': 'Ovi psi',
    'kelime2': 'Ove škole',
    'kelime3': 'Ova sela',
  },
  {
    'kelime1': 'Ti psi',
    'kelime2': 'Te škole',
    'kelime3': 'Ta sela',
  },
  {
    'kelime1': 'Oni psi',
    'kelime2': 'One škole',
    'kelime3': 'Ona sela',
  },
];

/// Bu / şu / o nedir ?
final List<Map<String, String>> isaretSifatlariSampleC = [
  {
    'soru': 'soru',
    'cevap': 'cevap',
  },
  {
    'soru': 'Šta je ovo? (bu nedir ?)',
    'cevap': 'Ovo je jabuka (Bu bir elmadır)',
  },
  {
    'soru': 'Šta je to? (şu nedir?)',
    'cevap': 'To je kivi (bu bir kivi)',
  },
  {
    'soru': 'Šta je ono? (o nedir?)',
    'cevap': 'Ono je jagoda (Bu bir çilek)',
  },
];

/// Bu / şu / o - devam
final List<Map<String, String>> isaretSifatlariSampleD = [
  {
    'soru': 'soru',
    'anlamı': 'anlamı',
  },
  {
    'soru': 'Da li ovo kupus?',
    'anlamı': 'Bu lahana mı?',
  },
  {
    'soru': 'Je li ovo praziluk?',
    'anlamı': 'Bu pırasa mı?',
  },
  {
    'soru': 'Da li to paradajz?',
    'anlamı': 'Şu bir domates mi?',
  },
  {
    'soru': 'Da li ono patlidžan?',
    'anlamı': 'O patlıcan mı?',
  },
];

/// Bu / şu / o - olumsuz sorular
final List<Map<String, String>> isaretSifatlariSampleE = [
  {
    'soru': 'soru',
    'anlamı': 'anlamı',
  },
  {
    'soru': 'Nije li ovo banana?',
    'anlamı': 'Bu muz değil mi?',
  },
  {
    'soru': 'Zar nije to škola?',
    'anlamı': 'Şu okul değil mi? ',
  },
  {
    'soru': 'Nije li ono avion?',
    'anlamı': 'O uçak değil mi?',
  },
];

/// Burada / Şurada / Orada
final List<Map<String, String>> isaretSifatlariSampleF = [
  {
    'soru': 'soru',
    'cevap': 'cevap',
  },
  {
    'soru': 'Gdje je knjiga? (kitap nerede?)',
    'cevap': 'Knjiga je ovde (kitap burada)',
  },
  {
    'soru': 'Gdje su kniga? (kitaplar nerede?)',
    'cevap': 'Knjiga je tamo (kitap orada)',
  },
];

/// Burada / Şurada / Orada örnekler
final List<Map<String, String>> isaretSifatlariSampleG = [
  {
    'ifade': 'ifade',
    'anlam': 'anlam',
  },
  {
    'ifade': 'Ovdje je čaša',
    'anlam': 'burada bardak var',
  },
  {
    'ifade': 'Tamo je čaša',
    'anlam': 'burada bardak var',
  },
  {
    'ifade': 'onamo je čaša',
    'anlam': 'orada bardak var',
  },
  {
    'ifade': 'Ovde su čaše',
    'anlam': 'burada bardaklar var',
  },
  {
    'ifade': 'Tamo su čaše',
    'anlam': 'burada bardaklar var',
  },
  {
    'ifade': 'onamo su čaše',
    'anlam': 'orada bardaklar var',
  },
  {
    'ifade': 'ovde nisu čaša ',
    'anlam': 'burada bardak yok',
  },
  {
    'ifade': 'Gdje je čaša?',
    'anlam': 'bardak nerede?',
  },
  {
    'ifade': 'Gdje su čaše?',
    'anlam': 'bardaklar nerede?',
  },
];

/// Burada / Şurada / Orada örnekler - Cevaplar
final List<Map<String, String>> isaretSifatlariSampleH = [
  {
    'ifade': 'ifade',
    'anlam': 'anlam',
  },
  {
    'ifade': 'Čaša je ovdje / tamo / onamo',
    'anlam': 'Bardak Burada / orada / şurada',
  },
  {
    'ifade': 'Čaše su ovdje / tamo / onamo',
    'anlam': 'Bardaklar Burada / orada / şurada',
  },
];

/// Burada / Şurada / Orada konum belirten sorular
final List<Map<String, String>> isaretSifatlariSampleI = [
  {
    'ifade': 'ifade',
    'anlam': 'anlam',
  },
  {
    'ifade': 'Da li čaša ovdje / tamo / onamo ?',
    'anlam': 'Bardak burada mı?',
  },
  {
    'ifade': 'Da čaša je ovdje / tamo /onamo',
    'anlam': 'Evet, bardak burada',
  },
  {
    'ifade': 'Ne čaša nije ovdje / tamo / onamo',
    'anlam': 'Hayır, bardak burada değil',
  },
  {
    'ifade': 'Ovdeje je čaša',
    'anlam': 'burada bardak yok',
  },
  {
    'ifade': 'Da li je ovdje čaša ? ',
    'anlam': 'burada bardak var mi? ',
  },
];

/// Burada / Şurada / Orada konum belirten sorular
final List<Map<String, String>> isaretSifatlariSampleJ = [
  {
    'işaret': 'işaret',
    'erkek': 'erkek',
    'dişi': 'dişi',
    'nötr': 'nötr',
  },
  {
    'işaret': 'bu > bunlar',
    'erkek': 'ovaj > ovi',
    'dişi': 'ova > ove',
    'nötr': 'Ovo > ova',
  },
  {
    'işaret': 'şu > şunlar',
    'erkek': 'taj > ti',
    'dişi': 'ta > te',
    'nötr': 'to > ta',
  },
  {
    'işaret': 'o > onlar',
    'erkek': 'onaj > oni',
    'dişi': 'ona > one',
    'nötr': 'ono > ona',
  },
];

/// Burada / Şurada / Orada konum belirten sorular
/// most / jabuka / selo örnekleri
final List<Map<String, String>> isaretSifatlariSampleK = [
  {
    'most': 'işaret',
    'jabuka': 'erkek',
    'selo': 'dişi',
  },
  {
    'most': 'ovi mostovi',
    'jabuka': 'ove jabuke',
    'selo': 'ova sela',
  },
  {
    'most': 'ti mostovi',
    'jabuka': 'Te jabuke',
    'selo': 'Ova sela',
  },
  {
    'most': 'Oni mostovi',
    'jabuka': 'One jabuke',
    'selo': 'Ona sela',
  },
];
