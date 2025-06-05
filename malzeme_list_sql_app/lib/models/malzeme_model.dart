// 📃 <----- malzeme_model.dart ----->

/// Malzeme sınıfı, her bir malzemenin ID, adı, açıklaması ve miktarını temsil eder.
/// SQLite veri tabanı ve JSON dönüşümleri için uygundur.
class Malzeme {
  /// Veritabanı için otomatik artan birincil anahtar (id). Nullable ’dır çünkü ekleme sırasında belli olmayabilir.
  final int? id;

  /// Malzemenin adı. Örneğin: "Çimento", "Kum"
  final String malzeme;

  /// Malzemenin açıklaması. Örneğin: "İnce taneli nehir kumu"
  final String? aciklama;

  /// Malzemenin miktarı (örneğin kilogram cinsinden).
  final int? miktar;

  /// Kurucu metot: Yeni bir Malzeme nesnesi oluşturur.
  Malzeme({
    this.id,
    required this.malzeme,
    this.aciklama,
    required this.miktar,
  });

  /// Bu metot, Malzeme nesnesini veritabanına yazmak için Map (anahtar-değer) yapısına çevirir.
  Map<String, dynamic> toMap() {
    final map = {'malzeme': malzeme, 'aciklama': aciklama, 'miktar': miktar};
    if (id != null) map['id'] = id;
    return map;
  }

  /// Bu fabrika metodu, veritabanından okunan Map verisini Malzeme nesnesine dönüştürür.
  factory Malzeme.fromMap(Map<String, dynamic> map) {
    return Malzeme(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()),
      malzeme: map['malzeme'] ?? '',
      aciklama: map['aciklama']?.toString(),
      miktar: map['miktar'] is int
          ? map['miktar']
          : int.tryParse(map['miktar'].toString()),
    );
  }

  /// JSON 'dan gelen veriyi (örneğin web 'den veya dosyadan) Malzeme nesnesine dönüştürür.
  /// fromMap metodunu çağırarak işlemi yapar.
  factory Malzeme.fromJson(Map<String, dynamic> json) => Malzeme.fromMap(json);

  /// Malzeme nesnesini JSON formatına (Map) çevirir.
  /// Genellikle JSON dosyasına yazmak veya dışarı aktarmak için kullanılır.
  Map<String, dynamic> toJson() => toMap();

  /// Mevcut bir Malzeme nesnesinin kopyasını oluşturur ve istenirse bazı alanlarını günceller.
  /// Bu yapı, immutable nesnelerde güncelleme yapmak için kullanışlıdır.
  Malzeme copyWith({int? id, String? malzeme, String? aciklama, int? miktar}) {
    return Malzeme(
      id: id ?? this.id,
      malzeme: malzeme ?? this.malzeme,
      aciklama: aciklama ?? this.aciklama,
      miktar: miktar ?? this.miktar,
    );
  }
}
