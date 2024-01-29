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

  /// Yazma / Güncelleme işlemi (WRITE)
  /// users koleksiyonuna git
  /// add metodu ile ID otomatik ekle ve verileri yaz
  Future<void> addUser() {
    /// ekleme fonksiyonu
    return firestore
        .collection("users")
        .add({
          "full_name": "Vedat Biner",
          "company": "Flutter Developer",
          "age": 59,
        })
        .then((value) => print("Kullanıcı eklendi"))
        .catchError(
          (error) => print("Hata oluştu : $error"),
        );
  }

  /// set metodu ile doküman ID manuel ekleniyor
  /// users koleksiyonuna gidilir.
  /// vedatbiner dokümanı seçilir.
  /// doküman yoksa oluştur ve verileri yaz
  Future<void> addUserSet() {
    return firestore
        .collection("users")
        .doc("vedatbiner")
        .set({
          "full_name": "Zeynep Biner",
          "company": "Secretary",
          "age": 58,
        })
        .then((value) => print("Kullanıcı eklendi"))
        .catchError(
          (error) => print("Hata oluştu : $error"),
        );
  }

  /// Güncelleme (UPDATE)
  /// users koleksiyonuna git
  /// vedatbiner seç map içindeki verileri güncelle
  Future<void> updateUser() {
    return firestore
        .collection("users")
        .doc("vedatbiner")
        .update({"company": "Home"})
        .then((value) => print("Kullanıcı güncellendi"))
        .catchError(
          (error) => print("Güncelleme sırasında hata oluştu: $error"),
        );
  }

  /// Silme (DELETE)
  /// doküman silme
  Future<void> deleteUser() {
    return firestore
        .collection("users")
        .doc("vedatbiner")
        .delete()
        .then((value) => print("Kullanıcı silinmiştir"))
        .catchError(
          (error) => print("Kullanıcı silinirken hata oluştu"),
        );
  }

  /// Doküman içindeki bir alanı silme
  /// alan adı kalır içindeki veri silinir.
  Future<void> deleteField() {
    return firestore
        .collection("users")
        .doc("vedatbiner")
        .update({"age": FieldValue.delete()})
        .then((value) => print("Alan verisi silimiştir"))
        .catchError(
          (error) => print("Alan veri silinirken hata oluştu : $error"),
        );
  }

  /// Query (Sorgulama)
  /// filtreleme - where metodu
  /// users koleksiyonu içinde age 20 'den büyük
  /// olanları getir
  firestore
      .collection("users")
      .where(
        "age",
        isGreaterThan: 20,
      )
      .get();

  /// limitlendirme .limit()
  /// ilk iki belgeyi getir.
  firestore.collection("users").limit(2).get();

  /// son iki belge
  firestore.collection("users").orderBy("age").limitToLast(2).get();

  /// Sıralama (Sayısal ve Tarih - Saat bilgileri için)
  firestore.collection("users").orderBy("age", descending: true).get();
}
