/// <----- firestore_services.dart ----->
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore ile bağlantı kuralım ve bir değişkene atayalım.
FirebaseFirestore firestore = FirebaseFirestore.instance;

/// Okuma İşlemi (READ)
/// users koleksiyonunun referansı
Future<void> reads() async {
  CollectionReference users = firestore.collection("users");

  /// dokümanlar koleksiyonları oluşturuyor
  /// bu nedenle koleksiyon altındaki dokümanlara da
  /// referans verebiliriz.
  DocumentReference vedatbiner =
      firestore.collection("users").doc("vedatbiner");

  /// Get metodu ile veri çekme yönteminde
  /// veri çekilir ve bir listeye aktarılır.
  /// koleksiyona git, veriyi getir (get)
  /// veriyi değişkene al (then)
  FirebaseFirestore.instance
      .collection("users")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      print(doc["first_name"]);
    }
  });

  /// QuerySnapshot ile verilerin anlık görüntüsünü görürüz.
  Stream collectionStream =
      FirebaseFirestore.instance.collection("users").snapshots();
  Stream documentStream = FirebaseFirestore.instance
      .collection("users")
      .doc("vedatbiner")
      .snapshots();
}


