// 📃 <----- db.dart ----->

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
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
}
