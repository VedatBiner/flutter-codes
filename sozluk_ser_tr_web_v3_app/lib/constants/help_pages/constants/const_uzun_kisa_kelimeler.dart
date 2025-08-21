// 📜 <----- const_uzun_kisa_kelimeler.dart ----->

/// Uzun Kısa Kelimeler
final List<Map<String, String>> uzunKisaSampleA = [
  {
    'şahıs': 'şahıs',
    'kısa': 'çekim',
    'uzun': 'kısa çekim',
    'olumsuz': 'olumsuz',
  },
  {'şahıs': 'Ja', 'kısa': 'Sam', 'uzun': 'Jesam', 'olumsuz': 'nisam'},
  {'şahıs': 'Ti', 'kısa': 'Si', 'uzun': 'Jesi', 'olumsuz': 'nisi'},
  {'şahıs': 'On / Ona', 'kısa': 'Je', 'uzun': 'Jeste', 'olumsuz': 'nije'},
  {'şahıs': 'Mi', 'kısa': 'Smo', 'uzun': 'Jesmo', 'olumsuz': 'nismo'},
  {'şahıs': 'Vi', 'kısa': 'Ste', 'uzun': 'Jeste', 'olumsuz': 'niste'},
  {'şahıs': 'Oni / One', 'kısa': 'Su', 'uzun': 'Jesu', 'olumsuz': 'nisu'},
];

/// Şahıs zamirli ve zamirsiz kullanım
final List<Map<String, String>> uzunKisaSampleB = [
  {'zamirli': 'zamirli', 'zamirsiz': 'zamirsiz', 'turkce': 'turkce'},
  {'zamirli': 'Ja sam dobro', 'zamirsiz': 'Dobro sam', 'turkce': 'iyiyim'},
  {'zamirli': 'Ti si dobro', 'zamirsiz': 'Dobro si', 'turkce': 'iyisin'},
  {'zamirli': 'On / ona je dobro', 'zamirsiz': 'Dobro je', 'turkce': 'iyi'},
  {'zamirli': 'Mi smo dobro', 'zamirsiz': 'Dobro smo', 'turkce': 'iyiyiz'},
  {'zamirli': 'Vi ste dobro', 'zamirsiz': 'Dobro ste', 'turkce': 'iyisiniz'},
  {'zamirli': 'Oni / one su dobro', 'zamirsiz': 'Dobro su', 'turkce': 'iyiler'},
];

/// Da li ve fiil + li kullanım
final List<Map<String, String>> uzunKisaSampleC = [
  {'da li': 'da li', 'fiil + li': 'fiil + li', 'turkce': 'turkce'},
  {
    'da li': 'Da li sam dobro?',
    'fiil + li': 'Jesam li dobro?',
    'turkce': 'İyi miyim?',
  },
  {
    'da li': 'Da li si dobro?',
    'fiil + li': 'Jesi li dobro?',
    'turkce': 'İyi misin?',
  },
  {
    'da li': 'Da li je dobro?',
    'fiil + li': 'Je li dobro?',
    'turkce': 'İyi mi?',
  },
  {
    'da li': 'Da li smo dobro?',
    'fiil + li': 'Jesmo li dobro?',
    'turkce': 'İyi miyiz?',
  },
  {
    'da li': 'Da li ste dobro?',
    'fiil + li': 'Jeste li dobro?',
    'turkce': 'İyi misiniz?',
  },
  {
    'da li': 'Da li su dobro?',
    'fiil + li': 'Jesu li dobro?',
    'turkce': 'İyiler mi?',
  },
];

/// Olumsuz kullanım Fiil + li kalıbı
final List<Map<String, String>> uzunKisaSampleD = [
  {'fiil + li': 'fiil + li', 'turkce': 'turkce'},
  {'fiil + li': 'Nisam li dobro', 'turkce': 'İyi değil miyim?'},
  {'fiil + li': 'Nisi li dobro', 'turkce': 'İyi değil misin?'},
  {'fiil + li': 'Nije li dobro', 'turkce': 'İyi değil mi?'},
  {'fiil + li': 'Nismo li dobro', 'turkce': 'İyi değil miyiz?'},
  {'fiil + li': 'Niste li dobro', 'turkce': 'İyi değil misiniz?'},
  {'fiil + li': 'Nisu li dobro', 'turkce': 'İyi değiller mi?'},
];

/// Uzun Kısa devam
final List<Map<String, String>> uzunKisaSampleE = [
  {'şahıs': 'şahıs', 'kısa': 'kısa', 'uzun': 'uzun', 'olumsuz': 'olumsuz'},
  {'şahıs': 'Ja', 'kısa': 'Ću', 'uzun': 'Hoću', 'olumsuz': 'Neću'},
  {'şahıs': 'ti', 'kısa': 'Ćeš', 'uzun': 'Hoćeš', 'olumsuz': 'Nećeš'},
  {'şahıs': 'on / ona', 'kısa': 'Će', 'uzun': 'Hoće', 'olumsuz': 'Nece'},
  {'şahıs': 'mi', 'kısa': 'Ćemo', 'uzun': 'Hoćemo', 'olumsuz': 'Nećemo'},
  {'şahıs': 'vi', 'kısa': 'Ćete', 'uzun': 'Hoćete', 'olumsuz': 'Nećete'},
  {'şahıs': 'oni / one', 'kısa': 'će', 'uzun': 'hoće', 'olumsuz': 'Neće'},
];
