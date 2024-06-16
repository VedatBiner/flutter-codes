// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

/// kelimelerin modeli
/// Belge Kimliğini (wordId) Saklama İhtiyacı:
/// Eğer wordId 'yi sınıfınıza eklemezseniz, veritabanından okuduğunuz
/// belgelerin kimliklerine (ID) erişim zor olabilir.
/// wordId 'yi saklamak, belirli bir kelimeyi güncellemek veya silmek
/// gibi işlemler yaparken işinizi kolaylaştırır.
/// Örneğin, bir kelimenin güncellenmesi gerektiğinde, hangi belgeyi
/// güncelleyeceğinizi belirlemek için wordId 'yi kullanabilirsiniz.
///
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

  /// fromDocument fabrikası (factory) ile Firestore belgesinden
  /// FsWords nesnesi oluşturabilir ve wordId 'yi de nesneye dahil
  /// edebilirsiniz. Bu, özellikle veri güncelleme ve silme işlemlerinde
  /// belge kimliğine ihtiyaç duyduğunuzda işinizi kolaylaştıracaktır.
  ///
  /// Firestore belgesinden FsWords nesnesi oluşturma
  /// Fabrika Yöntemi: fromDocument adında bir fabrika yöntemi,
  /// Firestore 'dan gelen belgeyi FsWords nesnesine dönüştürür.
  /// Bu yöntem, Firestore belgesinin ID 'sini (doc.id) ve belge
  /// içeriğini (doc['sirpca'], doc['turkce'], doc['userEmail']) kullanarak
  /// yeni bir FsWords nesnesi oluşturur.
  factory FsWords.fromDocument(DocumentSnapshot doc) {
    return FsWords(
      wordId: doc.id,
      sirpca: doc['sirpca'],
      turkce: doc['turkce'],
      userEmail: doc['userEmail'],
    );
  }

  /// Firestore 'dan veri okuma ve yazma işlemlerinde JSON dönüşümleri
  /// yapmak için bu yöntemlerin sınıfınıza eklenmesi gerekmektedir.
  ///
  /// JSON verisinden FsWords nesnesi oluşturma
  factory FsWords.fromJson(Map<String, dynamic> json) {
    return FsWords(
      wordId: json['wordId'] as String,
      sirpca: json['sirpca'] as String,
      turkce: json['turkce'] as String,
      userEmail: json['userEmail'] as String,
    );
  }

  /// FsWords nesnesini JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'wordId': wordId,
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }
}

/*FsWords.fromJson(Map<String, Object?> json)
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
*/
