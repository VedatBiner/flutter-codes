// 📃 <----- word_model.dart ----->
//
// Model sınıfı: Word
// - JSON/Map dönüşümleri (toMap/fromMap, toJson/fromJson)
// - Equatable ile değer eşitliği
// - copyWith ile immutability dostu kopyalama
//

import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final int? id;
  final String sirpca;
  final String turkce;
  final String userEmail;

  Word({
    this.id,
    required this.sirpca,
    required this.turkce,
    required this.userEmail,
  });

  /// ✅ Equatable: Değer eşitliği
  /// - id varsa: id üzerinden
  /// - id yoksa: (sirpca + userEmail) birleşimi üzerinden
  @override
  List<Object?> get props => [id ?? '${sirpca}__$userEmail'];

  /// ✅ Kopya oluşturma (immutable kullanım için)
  Word copyWith({int? id, String? sirpca, String? turkce, String? userEmail}) {
    return Word(
      id: id ?? this.id,
      sirpca: sirpca ?? this.sirpca,
      turkce: turkce ?? this.turkce,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  /// ✅ Map ’e (SQLite/Firestore yazımı için) dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }

  /// ✅ Map ’ten (SQLite/Firestore okuma için) nesneye dönüştürme
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'] is int ? map['id'] as int? : (map['id'] as num?)?.toInt(),
      sirpca: map['sirpca'] ?? '',
      turkce: map['turkce'] ?? '',
      userEmail: map['userEmail'] ?? '',
    );
  }

  /// ✅ JSON ’dan veri okumak için
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id:
          json['id'] is int
              ? json['id'] as int?
              : (json['id'] as num?)?.toInt(),
      sirpca: json['sirpca'],
      turkce: json['turkce'],
      userEmail: json['userEmail'],
    );
  }

  /// ✅ JSON ’a veri yazmak için
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }
}
