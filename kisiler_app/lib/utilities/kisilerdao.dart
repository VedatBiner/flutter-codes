import '../models/kisiler.dart';
import '../utilities/dbhelper.dart';

class Kisilerdao {
  // Tüm kişileri listeleyen metod
  Future<List<Kisiler>> tumKisiler() async {
    var db = await DbHelper.veritabaniErisim();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM kisiler");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kisiler(
        satir["kisiId"],
        satir["kisiAd"],
        satir["kisiTel"],
      );
    });
  }

  // arama işlemi için metod
  Future<List<Kisiler>> kisiArama(String aramaKelimesi) async {
    var db = await DbHelper.veritabaniErisim();
    List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM kisiler WHERE kisiAd LIKE '%$aramaKelimesi%'");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kisiler(
        satir["kisiId"],
        satir["kisiAd"],
        satir["kisiTel"],
      );
    });
  }

  // ekleme işlemi için metod
  Future<void> kisiEkle(String kisiAd, kisiTel) async {
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{}; // Map yeni format
    bilgiler["kisiAd"] = kisiAd;
    bilgiler["kisiTel"] = kisiTel;
    await db.insert("kisiler", bilgiler);
  }

  // güncelleme işlemi için metod
  Future<void> kisiGuncelle(int kisiId, String kisiAd, String kisiTel) async {
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{}; // Map yeni format
    bilgiler["kisiAd"] = kisiAd;
    bilgiler["kisiTel"] = kisiTel;
    await db
        .update("kisiler", bilgiler, where: "kisiId=?", whereArgs: [kisiId]);
  }

  // silme işlemi için metod
  Future<void> kisiSil(int kisiId) async {
    var db = await DbHelper.veritabaniErisim();
    await db.delete("kisiler", where: "kisiId=?", whereArgs: [kisiId]);
  }
}
























