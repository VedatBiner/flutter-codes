import '../models/kisiler.dart';

class KisilerCevap {
  List<Kisiler> kisiler;
  int success;

  KisilerCevap({
    required this.kisiler,
    required this.success,
  });

  factory KisilerCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["kisiler"] as List;
    List<Kisiler> kisiler = jsonArray
        .map((jsonArrayNesnesi) => Kisiler.fromJson(jsonArrayNesnesi))
        .toList();
    return KisilerCevap(kisiler: kisiler, success: json["success"] as int);
  }
}

