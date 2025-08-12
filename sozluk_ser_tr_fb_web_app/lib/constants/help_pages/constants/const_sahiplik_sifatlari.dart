// 📜 <----- const_Sahiplik_sifatlari.dart ----->

/// Sahiplik sıfatları
final List<Map<String, String>> sahiplikSifatlariSampleA = [
  {'şahıs': 'şahıs', 'erkek': 'erkek', 'dişi': 'dişi', 'nötr': 'nötr'},
  {'şahıs': 'benim', 'erkek': 'moj', 'dişi': 'moja', 'nötr': 'moje'},
  {'şahıs': 'senin', 'erkek': 'tvoj', 'dişi': 'tvoja', 'nötr': 'tvoje'},
  {
    'şahıs': 'onun (erkek)',
    'erkek': 'njegov',
    'dişi': 'njegova',
    'nötr': 'njegove',
  },
  {'şahıs': 'onun (dişi)', 'erkek': 'njen', 'dişi': 'njena', 'nötr': 'njeno'},
  {'şahıs': 'bizim', 'erkek': 'naš', 'dişi': 'naša', 'nötr': 'naše'},
  {'şahıs': 'sizin', 'erkek': 'vaš', 'dişi': 'vaša', 'nötr': 'vaše'},
  {'şahıs': 'onların', 'erkek': 'njihov', 'dişi': 'njihova', 'nötr': 'njihovo'},
];

/// Örnek - 1 - Život (hayat) Erkek cins isim
final List<Map<String, String>> sahiplikSifatlariSampleB = [
  {'sırpça': 'sırpça', 'türkçe': 'türkçe'},
  {'sırpça': 'Moj život', 'türkçe': 'Benim hayatım'},
  {'sırpça': 'Tvoj život', 'türkçe': 'Senin hayatın'},
  {'sırpça': 'Njegov život', 'türkçe': 'Onun hayatı (o Erkek)'},
  {'sırpça': 'Njen život', 'türkçe': 'Onun hayatı (o dişi)'},
];

/// Örnek - 2 - Škola (okul) Dişi cins isim
final List<Map<String, String>> sahiplikSifatlariSampleC = [
  {'sırpça': 'sırpça', 'türkçe': 'türkçe'},
  {'sırpça': 'Moja škola', 'türkçe': 'Benim okulum'},
  {'sırpça': 'tvoja škola', 'türkçe': 'Senin okulun'},
  {'sırpça': 'Njegova škola', 'türkçe': 'Onun okulu (o Erkek)'},
  {'sırpça': 'Njena škola', 'türkçe': 'Onun okulu (o dişi)'},
];

/// Örnek - 3- Selo (köy) Nötr cins isim
final List<Map<String, String>> sahiplikSifatlariSampleD = [
  {'sırpça': 'sırpça', 'türkçe': 'türkçe'},
  {'sırpça': 'Moje selo', 'türkçe': 'Benimköyüm'},
  {'sırpça': 'tvoje selo', 'türkçe': 'Senin köyün'},
  {'sırpça': 'Njegova selo', 'türkçe': 'Onun köyü (o Erkek)'},
  {'sırpça': 'Njena selo', 'türkçe': 'Onun köyü (o dişi)'},
];

/// Örnek - 4 - Škola (okul) Dişi cins isim (çoğul)
final List<Map<String, String>> sahiplikSifatlariSampleE = [
  {'sırpça': 'sırpça', 'türkçe': 'türkçe'},
  {'sırpça': 'Naša škola', 'türkçe': 'Bizim okulumuz'},
  {'sırpça': 'vaša škola', 'türkçe': 'Sizin okulunuz'},
  {'sırpça': 'njihova škola', 'türkçe': 'Onların okulu '},
];

/// Sahiplik sıfatları (çoğul)
final List<Map<String, String>> sahiplikSifatlariSampleF = [
  {
    'şahıs': 'şahıs',
    'erkek': 'erkek (T/Ç)',
    'dişi': 'dişi (T/Ç)',
    'nötr': 'nötr (T/Ç)',
  },
  {
    'şahıs': 'benim',
    'erkek': 'Moj – moji',
    'dişi': 'Moja - moje',
    'nötr': 'Moje – moja',
  },
  {
    'şahıs': 'senin',
    'erkek': 'Tvoj – tvoji',
    'dişi': 'Tvoja – tvoje',
    'nötr': 'Tvoje – tvoja',
  },
  {
    'şahıs': 'onun (erkek)',
    'erkek': 'Njegov – njegovi',
    'dişi': 'Njegova – njegove',
    'nötr': 'Njegove – njegova',
  },
  {
    'şahıs': 'onun (dişi)',
    'erkek': 'Njen – njeni',
    'dişi': 'Njena – njene',
    'nötr': 'Njeno – njena',
  },
  {
    'şahıs': 'bizim',
    'erkek': 'Naš - Naši',
    'dişi': 'Naša - Naše',
    'nötr': 'Naše - Naša',
  },
  {
    'şahıs': 'sizin',
    'erkek': 'Vaš - vaši',
    'dişi': 'Vaša - vaše',
    'nötr': 'Vaše – vaša',
  },
  {
    'şahıs': 'onların',
    'erkek': 'Njihov - njihovi',
    'dişi': 'Njihova - njihove',
    'nötr': 'Njihovo - njihova',
  },
];

/// Örnek - Sahiplik sıfatları (çoğul)
final List<Map<String, String>> sahiplikSifatlariSampleG = [
  {'tekil': 'şahıs', 'çoğul': 'erkek (T/Ç)', 'türkçe (çoğul)': 'dişi (T/Ç)'},
  {
    'tekil': 'Moja sestra',
    'çoğul': 'Moje sestre',
    'türkçe (çoğul)': 'Benim kız kardeşlerim',
  },
  {
    'tekil': 'Tvoja sestra',
    'çoğul': 'Tvoje sestre',
    'türkçe (çoğul)': 'Senin kız kardeşlerin',
  },
  {
    'tekil': 'Njegova sestra',
    'çoğul': 'Njegove sestre',
    'türkçe (çoğul)': 'Onun kız kardeşleri (erkek)',
  },
  {
    'tekil': 'Njena sestra',
    'çoğul': 'Njene sestre',
    'türkçe (çoğul)': 'Onun kız kardeşleri (dişi)',
  },
  {
    'tekil': 'Naša sestra',
    'çoğul': 'Naše sestre',
    'türkçe (çoğul)': 'Bizim kız kardeşlerimiz',
  },
  {
    'tekil': 'Vaša sestra',
    'çoğul': 'Vaše sestre',
    'türkçe (çoğul)': 'Sizin kız kardeşleriniz',
  },
  {
    'tekil': 'Njihova sestra',
    'çoğul': 'Njihove sestre',
    'türkçe (çoğul)': 'Onların kız kardeşleri',
  },
];

/// Örnekler
final List<Map<String, String>> sahiplikSifatlariSampleH = [
  {'türkçe': 'türkçe', 'sırpça': 'sırpça'},
  {
    'türkçe': 'Arkadaşım konuşmayı sever',
    'sırpça': 'moj prijatelj voli govoriti',
  },
  {'türkçe': 'Oyuncakların nerede?', 'sırpça': 'gdje su tvoje igračke'},
  {'türkçe': 'Onların köyü uzak ', 'sırpça': 'njihovo selo je daleko'},
  {
    'türkçe': 'Onun (kız) kitapları burada mı?',
    'sırpça': 'Da li su njene knjige ovdje?',
  },
];
