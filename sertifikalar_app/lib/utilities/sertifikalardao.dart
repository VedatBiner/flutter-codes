import '../models/sertifikalar.dart';
import '../utilities/dbhelper.dart';

class Sertifikalardao {
  // Tüm kişileri listeleyen metod
  Future<List<Sertifikalar>> tumSertifikalar() async {
    var db = await DbHelper.veritabaniErisim();
    List<Map<String, dynamic>> maps =
    await db.rawQuery("SELECT * FROM sertifikalar");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Sertifikalar(
        satir["sertId"],
        satir["sertTarih"],
        satir["sertKurum"],
        satir["sertKonu"],
        satir["sertDetay"],
        satir["sertLink"],
      );
    });
  }

  // arama işlemi için metod
  Future<List<Sertifikalar>> konuArama(String aramaKelimesi) async {
    var db = await DbHelper.veritabaniErisim();
    List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM sertifikalar WHERE sertKonu LIKE '%$aramaKelimesi%'");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Sertifikalar(
        satir["sertId"],
        satir["sertTarih"],
        satir["sertKurum"],
        satir["sertKonu"],
        satir["sertDetay"],
        satir["sertLink"],
      );
    });
  }

  // ekleme işlemi için metod
  Future<void> sertifikaEkle(String sertTarih, sertKurum, sertKonu, sertDetay, sertLink) async {
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["sertTarih"] = sertTarih;
    bilgiler["sertKurum"] = sertKurum;
    bilgiler["sertKonu"] = sertKonu;
    bilgiler["sertDetay"] = sertDetay;
    bilgiler["sertLink"] = sertLink;
    await db.insert("sertifikalar", bilgiler);
  }

  // güncelleme işlemi için metod
  Future<void> sertfikaGuncelle(int sertId, String sertTarih, sertKurum, sertKonu, sertDetay, sertLink) async {
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["sertTarih"] = sertTarih;
    bilgiler["sertKurum"] = sertKurum;
    bilgiler["sertKonu"] = sertKonu;
    bilgiler["sertDetay"] = sertDetay;
    bilgiler["sertLink"] = sertLink;

    await db
        .update("sertifikalar", bilgiler, where: "sertId=?", whereArgs: [sertId]);
  }

  // silme işlemi için metod
  Future<void> sertifikaSil(int sertId) async {
    var db = await DbHelper.veritabaniErisim();
    await db.delete("sertifikalar", where: "sertId=?", whereArgs: [sertId]);
  }

}
