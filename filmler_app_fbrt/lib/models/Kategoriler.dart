class Kategoriler {
  String kategori_id;
  String kategori_ad;

  // constructor
  Kategoriler(this.kategori_id, this.kategori_ad);

  // JsonParse metodu
  factory Kategoriler.fromJson(String key, Map<dynamic, dynamic> json) {
    return Kategoriler(key, json["kategori_id"] as String);
  }
}
