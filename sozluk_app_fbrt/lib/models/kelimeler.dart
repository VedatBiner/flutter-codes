class Kelimeler {
  String kelime_id;
  String ingilizce;
  String turkce;

  // constructor
  Kelimeler(this.kelime_id, this.ingilizce, this.turkce);

  // parse işlemi
  factory Kelimeler.fromJson(String key, Map<dynamic, dynamic> json) {
    return Kelimeler(
      key,
      json["ingilizce"] as String,
      json["turkce"] as String,
    );
  }
}
