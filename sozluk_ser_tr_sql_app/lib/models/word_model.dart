// 📃 <----- word_model.dart ----->
// Word veri modeli

class Word {
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

  // 🔄 Nesneyi Map’e dönüştür (SQLite / Firestore yazmak için)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }

  // 🔄 SQLite’ta okunan Map’ten nesne üret
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'], // ✅ id artık okunuyor
      sirpca: map['sirpca'] ?? '',
      turkce: map['turkce'] ?? '',
      userEmail: map['userEmail'] ?? '',
    );
  }

  /// ✅ JSON ’dan veri okumak için
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
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

  // 🔧 Kolay güncelleme için copyWith
  Word copyWith({int? id, String? sirpca, String? turkce, String? userEmail}) {
    return Word(
      id: id ?? this.id,
      sirpca: sirpca ?? this.sirpca,
      turkce: turkce ?? this.turkce,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  // 🐞 Debug kolaylığı
  @override
  String toString() =>
      'Word(id: $id, sirpca: $sirpca, turkce: $turkce, userEmail: $userEmail)';

  // 🔁 Koleksiyon karşılaştırmaları için
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Word &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sirpca == other.sirpca &&
          turkce == other.turkce &&
          userEmail == other.userEmail;

  @override
  int get hashCode =>
      id.hashCode ^ sirpca.hashCode ^ turkce.hashCode ^ userEmail.hashCode;
}
