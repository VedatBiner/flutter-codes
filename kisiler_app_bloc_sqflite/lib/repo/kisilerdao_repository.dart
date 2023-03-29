import 'dart:developer';
import '../utilities/dbhelper.dart';

import '../models/kisiler.dart';

class KisilerDaoRepository {
  // Kayıt metodu
  Future<void> kisiKayit(String kisi_ad, String kisi_tel) async {
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = Map<String, dynamic>();
    bilgiler["kisi_ad"] = kisi_ad;
    bilgiler["kisi_tel"] = kisi_tel;
    await db.insert("kisiler", bilgiler);
  }

  // Güncelleme metodu
  Future<void> kisiGuncelle(
    int kisi_id,
    String kisi_ad,
    String kisi_tel,
  ) async {
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = Map<String, dynamic>();
    bilgiler["kisi_ad"] = kisi_ad;
    bilgiler["kisi_tel"] = kisi_tel;
    await db.update(
      "kisiler",
      bilgiler,
      where: "kisi_id=?",
      whereArgs: [kisi_id],
    );
  }

  // tüm kişileri listeleyelim
  Future<List<Kisiler>> tumKisileriAl() async {
    var db = await DbHelper.veritabaniErisim();
    // verileri satır satır alalım
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM kisiler");
    // her satırı kişi nesnesine dönüştürelim
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kisiler(
        kisi_id: satir["kisi_id"],
        kisi_ad: satir["kisi_ad"],
        kisi_tel: satir["kisi_tel"],
      );
    });
  }

  // arama işlemi
  // bu bölüm tüm kişileri listeleme ile aynı sadece sorgu cümlesi değişik
  Future<List<Kisiler>> kisiAra(String aramaKelimesi) async {
    var db = await DbHelper.veritabaniErisim();
    // verileri satır satır alalım
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM kisiler WHERE kisi_ad LIKE '%$aramaKelimesi%'");
    // her satırı kişi nesnesine dönüştürelim
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kisiler(
        kisi_id: satir["kisi_id"],
        kisi_ad: satir["kisi_ad"],
        kisi_tel: satir["kisi_tel"],
      );
    });
  }

  // silme işlemi
  Future<void> kisiSil(int kisi_id) async {
    var db = await DbHelper.veritabaniErisim();
    await db.delete("kisiler", where: "kisi_id", whereArgs: [kisi_id]);
  }
}
