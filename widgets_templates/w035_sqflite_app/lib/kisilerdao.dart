import '../veritabaniyardimcisi.dart';
import 'kisiler.dart';

class Kisilerdao {
  Future<List<Kisiler>> tumKisiler() async {
    // veri tabanına erişelim
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    // sorgu yapalım
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM kisiler");
    // alan bilgilerini alalım ve nesne oluşturalım
    return List.generate(maps.length, (i) {
      // maps içine gelen bilgileri satır satır alalım
      var satir = maps[i];
      // nesneye dönüştürelim
      return Kisiler(
        satir["kisi_id"],
        satir["kisi_ad"],
        satir["kisi_yas"],
      );
    });
  }

  // kayıt ekleme
  Future<void> kisiEkle(String kisi_ad, kisi_yas) async {
    // veri tabanına erişelim
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["kisi_ad"] = kisi_ad;
    bilgiler["kisi_yas"] = kisi_yas;
    await db.insert("kisiler", bilgiler);
  }

  // kayıt silme
  Future<void> kisiSil(int kisi_id) async {
    // veri tabanına erişelim
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    // silme işlemi
    await db.delete("kisiler", where: "kisi_id = ?", whereArgs: [kisi_id]);
  }

  // kayıt güncelleme
  Future<void> kisiGuncelle(int kisi_id, String kisi_ad, int kisi_yas) async {
    // veri tabanına erişelim
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["kisi_ad"] = kisi_ad;
    bilgiler["kisi_yas"] = kisi_yas;
    await db
        .update("kisiler", bilgiler, where: "kisi_id=?", whereArgs: [kisi_id]);
  }

  // kayıt kontrol
  Future<int> kayitKontrol(String kisi_ad) async {
    // veri tabanına erişelim
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    // sorgu yapalım
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT count(*) AS sonuc FROM kisiler WHERE kisi_ad='$kisi_ad'");
    return maps[0]["sonuc"];
  }

  // Tek kayıt getirme
  Future<Kisiler> kisiGetir(int kisi_id) async {
    // veri tabanına erişelim
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    // sorgu yapalım
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM kisiler WHERE kisi_id=$kisi_id");
    // maps içine gelen bilgileri satır satır alalım
    var satir = maps[0]; // bir tane bilgi geliyor. Bu ilk kayıt
    // nesneye dönüştürelim
    return Kisiler(
      satir["kisi_id"],
      satir["kisi_ad"],
      satir["kisi_yas"],
    );
  }

  // Kişi arama
  Future<List<Kisiler>> kisiArama(String aramaKelimesi) async {
    // veri tabanına erişelim
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    // sorgu yapalım
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM kisiler WHERE kisi_ad LIKE '%$aramaKelimesi%'");
    // alan bilgilerini alalım ve nesne oluşturalım
    return List.generate(maps.length, (i) {
      // maps içine gelen bilgileri satır satır alalım
      var satir = maps[i];
      // nesneye dönüştürelim
      return Kisiler(
        satir["kisi_id"],
        satir["kisi_ad"],
        satir["kisi_yas"],
      );
    });
  }

  // rasgele ve limitli arama
  Future<List<Kisiler>> rasgeleKisiGetir() async {
    // veri tabanına erişelim
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    // sorgu yapalım
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM kisiler ORDER BY RANDOM() LIMIT 2");
    // alan bilgilerini alalım ve nesne oluşturalım
    return List.generate(maps.length, (i) {
      // maps içine gelen bilgileri satır satır alalım
      var satir = maps[i];
      // nesneye dönüştürelim
      return Kisiler(
        satir["kisi_id"],
        satir["kisi_ad"],
        satir["kisi_yas"],
      );
    });
  }
}
