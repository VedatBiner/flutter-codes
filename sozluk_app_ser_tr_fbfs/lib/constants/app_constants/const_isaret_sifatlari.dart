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
