import '../models/notlar.dart';
import 'dbhelper.dart';

class Notlardao {

  // tüm notları alalım
  Future<List<Notlar>> tumNotlar() async {
    var db = await DbHelper.veritabaniErisim();
    // sorgulama yapalım - notlar tablosundaki tüm notları al
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM notlar");
    // notlar nesnelerine dönüştürüp, liste halinde oluşturalım
    return List.generate(maps.length, (i) {
      // maps içindeki bilgiler satır satır gelecek
      var satir = maps[i];
      // not nesnesi oluşturalım
      return Notlar(
        satir["notId"],
        satir["dersAdi"],
        satir["not1"],
        satir["not2"],
      );
    });
  }

  // Not ekleme metodu
  Future<void> notEkle(String dersAdi, int not1, int not2) async {
    var db = await DbHelper.veritabaniErisim();
    // map oluşturalım
    var bilgiler = Map<String, dynamic>();
    bilgiler["dersAdi"] = dersAdi;
    bilgiler["not1"] = not1;
    bilgiler["not2"] = not2;
    // notlar tablosuna bilgileri kaydedelim
    await db.insert("notlar", bilgiler);
  }

  // Güncelleme metodu
  Future<void> notGuncelle(int notId, String dersAdi, int not1, int not2) async {
    var db = await DbHelper.veritabaniErisim();
    // map oluşturalım
    var bilgiler = Map<String, dynamic>();
    bilgiler["dersAdi"] = dersAdi;
    bilgiler["not1"] = not1;
    bilgiler["not2"] = not2;
    // notlar tablosunda bilgileri güncelleyelim
    await db.update("notlar", bilgiler, where: "notId=?", whereArgs: [notId]);
  }

  // silme metodu
  Future<void> notSil(int notId) async {
    var db = await DbHelper.veritabaniErisim();
    await db.delete("notlar", where: "notId=?", whereArgs: [notId]);
  }

}








