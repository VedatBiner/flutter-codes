/// <----- words.dart ----->
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constants/constants.dart';

class Words {
  String wordId;
  String sirpca;
  String turkce;
  String userEmail;

  Words(
    this.wordId,
    this.sirpca,
    this.turkce,
    this.userEmail,
  );

  /// parse işlemi
  factory Words.fromJson(
    String key,
    Map<dynamic, dynamic>? json,
  ) {
    if (json == null) {
      throw ArgumentError(
          "json cannot be null"); // Json null ise hata fırlatıyoruz
    }
    return Words(
      key,
      json[fsIkinciDil] as String? ?? "",
      json[fsBirinciDil] as String? ?? "",
      json[fsUserEmail] as String? ?? "",
    );
  }

  /// Fabrika yöntemi
  factory Words.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();

    if (data == null) {
      /// Data null ise hata fırlatıyoruz
      throw ArgumentError("data cannot be null");
    }

    return Words(
      snapshot.id,
      data[fsIkinciDil] as String ?? "",
      data[fsBirinciDil] as String? ?? "",
      data[fsUserEmail] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson(){
    return {
      fsIkinciDil: sirpca,
      fsBirinciDil: turkce,
      fsUserEmail: userEmail,
    };
  }
}
