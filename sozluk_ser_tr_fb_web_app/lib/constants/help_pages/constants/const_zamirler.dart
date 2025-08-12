/// Zamirler
final List<Map<String, String>> zamirlerSample = [
  {'tekil': 'tekil', 'çoğul': 'çoğul'},
  {'tekil': 'Ja (ben)', 'çoğul': 'Mi (biz)'},
  {'tekil': 'Ti (sen)', 'çoğul': 'Vi (siz)'},
  {
    'tekil': 'On (erkek o) / Ona (dişi o) / Ono (Nötr)',
    'çoğul': 'Oni (Erkek onlar) / One (Dişi onlar) / Ona (Nötr)',
  },
];

/// olmak fili - olumlu/ olumsuz /soru kalıbı
final List<Map<String, String>> olmakSampleTr = [
  {'olumlu': 'olumlu', 'olumsuz': 'olumsuz', 'soru': 'soru'},
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
  {'zamir': 'zamir', 'vurgulu': 'vurgulu', 'vurgusuz': 'vurgusuz'},
  {'zamir': 'ja', 'vurgulu': 'sam', 'vurgusuz': 'jesam'},
  {'zamir': 'ti', 'vurgulu': 'si', 'vurgusuz': 'jesi'},
  {'zamir': 'on / ona / ono', 'vurgulu': 'je', 'vurgusuz': 'jest(e)'},
  {'zamir': 'mi', 'vurgulu': 'smo', 'vurgusuz': 'jesmo'},
  {'zamir': 'vi', 'vurgulu': 'ste', 'vurgusuz': 'jeste'},
  {'zamir': 'oni / one / ona', 'vurgulu': 'su', 'vurgusuz': 'jesu'},
];

/// Şahıs zamirleri olumlu / olumsuz
final List<Map<String, String>> zamirlerSampleA = [
  {'olumlu': 'olumlu', 'olumsuz': 'olumsuz'},
  {'olumlu': 'ja', 'olumsuz': 'nisam'},
  {'olumlu': 'ti', 'olumsuz': 'nisi'},
  {'olumlu': 'on / ona /ono', 'olumsuz': 'nije'},
  {'olumlu': 'mi', 'olumsuz': 'nismo'},
  {'olumlu': 'vi', 'olumsuz': 'niste'},
  {'olumlu': 'oni / one / ona', 'olumsuz': 'nisu'},
];

/// Olmak fiili olumlu cümleler
final List<Map<String, String>> zamirlerSampleB = [
  {'özne': 'özne', 'fiil': 'fiil', 'isim / nesne': ' isim / nesne'},
  {'özne': 'ja', 'fiil': 'sam', 'isim / nesne': 'student (öğrenciyim'},
  {'özne': 'ti', 'fiil': 'si', 'isim / nesne': 'student (öğrencisin)'},
  {'özne': 'on / ona /ono', 'fiil': 'je', 'isim / nesne': 'student (öğrenci)'},
  {'özne': 'mi', 'fiil': 'smo', 'isim / nesne': 'studenti (öğrenciyiz)'},
  {'özne': 'vi', 'fiil': 'ste', 'isim / nesne': 'studenti (öğrencisiniz)'},
  {
    'özne': 'oni / one / ono',
    'fiil': 'su',
    'isim / nesne': 'studenti (öğrenciler)',
  },
];

/// Olmak fiili olumlu cümleler (kız)
final List<Map<String, String>> zamirlerSampleC = [
  {'özne': 'özne', 'fiil': 'fiil', 'isim / nesne': ' isim / nesne'},
  {'özne': 'ja', 'fiil': 'sam', 'isim / nesne': 'studentica (öğrenciyim)'},
  {'özne': 'ti', 'fiil': 'si', 'isim / nesne': 'studentica (öğrencisin)'},
  {
    'özne': 'on / ona /ono',
    'fiil': 'je',
    'isim / nesne': 'studentica (öğrenci)',
  },
  {'özne': 'mi', 'fiil': 'smo', 'isim / nesne': 'studentice (öğrenciyiz)'},
  {'özne': 'vi', 'fiil': 'ste', 'isim / nesne': 'studentice (öğrencisiniz)'},
  {
    'özne': 'oni / one / ono',
    'fiil': 'su',
    'isim / nesne': 'studentice (öğrenciler)',
  },
];

/// kako si olumlu cümleler
final List<Map<String, String>> zamirlerSampleD = [
  {'özne': 'özne', 'fiil': 'fiil', 'isim / nesne': ' isim / nesne'},
  {'özne': 'ja', 'fiil': 'sam', 'isim / nesne': 'dobro (iyiyim)'},
  {'özne': 'ti', 'fiil': 'si', 'isim / nesne': 'dobro (iyisin)'},
  {'özne': 'on / ona /ono', 'fiil': 'je', 'isim / nesne': 'dobro (iyi)'},
  {'özne': 'mi', 'fiil': 'smo', 'isim / nesne': 'dobro (iyiyiz)'},
  {'özne': 'vi', 'fiil': 'ste', 'isim / nesne': 'dobro (iyisiniz)'},
  {'özne': 'oni / one / ono', 'fiil': 'su', 'isim / nesne': 'dobro (iyiler)'},
];

/// kako si olumsuz cümleler
final List<Map<String, String>> zamirlerSampleE = [
  {'özne': 'özne', 'fiil': 'fiil', 'isim / nesne': ' isim / nesne'},
  {'özne': 'ja', 'fiil': 'nisam', 'isim / nesne': 'dobro (iyi değilim)'},
  {'özne': 'ti', 'fiil': 'nisi', 'isim / nesne': 'dobro (iyi değilsin)'},
  {
    'özne': 'on / ona /ono',
    'fiil': 'nije',
    'isim / nesne': 'dobro (iyi değil)',
  },
  {'özne': 'mi', 'fiil': 'nismo', 'isim / nesne': 'dobro (iyi değiliz)'},
  {'özne': 'vi', 'fiil': 'niste', 'isim / nesne': 'dobro (iyi değilsiniz)'},
  {
    'özne': 'oni / one / ono',
    'fiil': 'nisu',
    'isim / nesne': 'dobro (iyi değiller)',
  },
];

/// zar ne yapısı
final List<Map<String, String>> zamirlerSampleF = [
  {'da li': '', 'şahıs zamiri': '', 'normal fiil': '', 'info': ''},
  {
    'da li': 'da li',
    'şahıs zamiri': 'şahıs zamiri',
    'normal fiil': 'normal fiil',
    'info': '',
  },
  {
    'da li': 'da li',
    'şahıs zamiri': 'olmak fiili',
    'normal fiil': 'şahıs zamiri',
    'info': '',
  },
  {
    'da li': 'ja',
    'şahıs zamiri': 'vidim',
    'normal fiil': 'kuću',
    'info': 'evi görüyorum',
  },
  {
    'da li': 'vidim li',
    'şahıs zamiri': '(ja)',
    'normal fiil': 'kuću',
    'info': 'evi görüyor muyum?',
  },
  {
    'da li': 'da li',
    'şahıs zamiri': '(ja)',
    'normal fiil': 'vidim kuću',
    'info': 'evi görüyor muyum?',
  },
];

final List<Map<String, String>> zamirlerSampleG = [
  {'sırpça': '', 'türkçe': ''},
  {'sırpça': 'mi smo studenti ', 'türkçe': 'biz öğrenciyiz'},
  {'sırpça': 'Jesmo li (mi) studenti ?', 'türkçe': 'biz öğrenci miyiz ?'},
  {'sırpça': 'Da li smo (mi) studenti ?', 'türkçe': 'biz öğrenci miyiz ?'},
];

/// zar ne örnekleri
final List<Map<String, String>> zamirlerSampleH = [
  {'sırpça': '', 'türkçe': ''},
  {'sırpça': 'Zar ne dolaziš ?', 'türkçe': 'gelmiyor musun?'},
  {'sırpça': 'Dolaziš, zar ne?', 'türkçe': 'geliyorsun değil mi?'},
  {'sırpça': 'Ne dolaziš, zar ne ? ', 'türkçe': 'yürümüyorsun, değil mi?'},
  {'sırpça': 'Zar ne hodaš? ,', 'türkçe': 'yürümüyor musun?'},
  {'sırpça': 'hodaš, zar ne?', 'türkçe': 'yürüyorsun değil mi?'},
  {'sırpça': 'Ne hodaš, zar ne ?', 'türkçe': 'yürümüyorsun, değil mi?'},
];
