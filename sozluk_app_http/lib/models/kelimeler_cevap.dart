import '../models/kelimeler.dart';

class KelimelerCevap {
  int success;
  List<Kelimeler> kelimelerListesi;

  // constructor oluşturduk
  KelimelerCevap(
    this.success,
    this.kelimelerListesi,
  );

  // parse metodu
  factory KelimelerCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["kelimeler"] as List;
    List<Kelimeler> kelimelerListesi = jsonArray
        .map((jsonArrayNesnesi) => Kelimeler.fromJson(jsonArrayNesnesi))
        .toList();
    return KelimelerCevap(
      json["success"] as int,
      kelimelerListesi,
    );
  }
}
