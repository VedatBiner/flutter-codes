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
  /// Burada null kontrolü yaparak eksik alanları boşlukla dolduruyoruz
  factory FsWords.fromDocument(DocumentSnapshot doc) {
    return FsWords(
      wordId: doc.id,
      sirpca: doc['sirpca'] ?? "",
      turkce: doc['turkce'] ?? "",
      userEmail: doc['userEmail'] ?? "",
    );
  }

  /// Firestore 'dan veri okuma ve yazma işlemlerinde JSON dönüşümleri
  /// yapmak için bu yöntemlerin sınıfınıza eklenmesi gerekmektedir.
  ///
  /// JSON verisinden FsWords nesnesi oluşturma
  factory FsWords.fromJson(Map<String, dynamic> json) {
    return FsWords(
      wordId: json['wordId'] ?? "",
      sirpca: json['sirpca'] ?? "",
      turkce: json['turkce'] ?? "",
      userEmail: json['userEmail'] ?? "",
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
