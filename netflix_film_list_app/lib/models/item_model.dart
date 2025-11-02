// 📃 <----- item_model.dart ----->

import 'package:equatable/equatable.dart';

class NetflixItem extends Equatable {
  final int? id;
  final String netflixItemName;
  final String watchDate;

  const NetflixItem({
    this.id,
    required this.netflixItemName,
    required this.watchDate,
  });

  /// 📌 Equatable karşılaştırması için kullanılacak alanlar
  @override
  List<Object?> get props => [id, netflixItemName, watchDate];

  /// 📌 Kolay güncelleme için yardımcı (opsiyonel ama faydalı)
  NetflixItem copyWith({int? id, String? netflixItemName, String? watchDate}) {
    return NetflixItem(
      id: id ?? this.id,
      netflixItemName: netflixItemName ?? this.netflixItemName,
      watchDate: watchDate ?? this.watchDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'netflixItemName': netflixItemName,
      'watchDate': watchDate,
    };
  }

  factory NetflixItem.fromMap(Map<String, dynamic> map) {
    return NetflixItem(
      id: map['id'],
      netflixItemName: map['netflixItemName'],
      watchDate: map['watchDate'],
    );
  }

  /// ✅ JSON ’dan veri okumak için
  factory NetflixItem.fromJson(Map<String, dynamic> json) {
    return NetflixItem(
      id: json['id'],
      netflixItemName: json['netflixItemName'] ?? json['Title'] ?? '',
      watchDate: json['watchDate'] ?? json['Date'] ?? '',
    );
  }

  /// ✅ JSON ’a veri yazmak için
  Map<String, dynamic> toJson() {
    return {'netflixItemName': netflixItemName, 'watchDate': watchDate};
  }
}
