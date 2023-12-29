import 'package:cloud_firestore/cloud_firestore.dart';

/// <----- words.dart ----->
class Words {
  String wordId;
  String sirpca;
  String turkce;

  Words(
    this.wordId,
    this.sirpca,
    this.turkce,
  );

  /// parse işlemi
  factory Words.fromJson(
    String key,
    Map<dynamic, dynamic> json,
  ) {
    return Words(
      key,
      json["sirpca"] as String,
      json["turkce"] as String,
    );
  }

  // Fabrika yöntemi
  factory Words.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Words(
      snapshot.id,
      data["sirpca"] as String,
      data["turkce"] as String,
    );
  }
}
