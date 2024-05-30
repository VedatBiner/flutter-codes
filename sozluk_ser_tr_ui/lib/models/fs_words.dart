import 'package:cloud_firestore/cloud_firestore.dart';

/// kelimelerin modeli
class FsWords {
  final String wordId;
  final String sirpca;
  final String turkce;
  final String userEmail;

  FsWords({
    required this.wordId,
    required this.sirpca,
    required this.turkce,
    required this.userEmail,
  });

  FsWords.fromJson(Map<String, Object?> json)
      : this(
          wordId: json['wordId'].toString(),
          sirpca: json['sirpca'].toString(),
          turkce: json['turkce'].toString(),
          userEmail: json['userEmail'].toString(),
        );

  Map<String, Object?> toJson() {
    return {
      'wordId': wordId,
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail
    };
  }

  @override
  String toString() {
    return 'FsWords{sirpca: $sirpca, turkce: $turkce, userEmail: $userEmail,}';
  }

  factory FsWords.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return FsWords(
      wordId: data["wordId"].toString(),
      sirpca: data["sirpca"].toString(),
      turkce: data["turkce"].toString(),
      userEmail: data["userEmail"].toString(),
    );
  }

  /// orderBy metodu
  static Future<QuerySnapshot<Object?>> orderBy(String field) async {
    final CollectionReference words =
        FirebaseFirestore.instance.collection("kelimeler");
    return await words.orderBy(field).get();
  }
}
