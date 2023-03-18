import 'kisiler.dart';

class KisilerCevap {
  int scuccess;
  List<Kisiler> kisilerListesi;

  KisilerCevap(this.scuccess, this.kisilerListesi);

  factory KisilerCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["kisiler"] as List;
    List<Kisiler> kisilerListesi = jsonArray
        .map((jsonArrayNesnesi) => Kisiler.fromJson(jsonArrayNesnesi))
        .toList();
    return KisilerCevap(json["success"] as int, kisilerListesi);
  }
}
