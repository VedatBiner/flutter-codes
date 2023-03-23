import 'dart:convert';

class Notlar {
  String not_id;
  String ders_adi;
  int not1;
  int not2;

  // constructor
  Notlar(
    this.not_id,
    this.ders_adi,
    this.not1,
    this.not2,
  );

  // parse metodu
  factory Notlar.fromJson(String key, Map<dynamic, dynamic> json) {
    return Notlar(
      key,
      json["ders_adi"] as String,
      json["not1"] as int,
      json["not2"] as int,
    );
  }
}
