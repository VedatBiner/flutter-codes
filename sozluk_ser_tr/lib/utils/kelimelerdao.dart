import 'dbhelper.dart';
import '../models/kelimeler.dart';

class Kelimelerdao{

  // tüm kelimeleri alalım
  Future<List<Kelimeler>> tumKelimeler() async{
    var db = await DbHelper.veritabaniErisim();
    // sorgulama yapalım
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM kelimeler");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kelimeler(satir["kelimeId"], satir["ingilizce"], satir["turkce"]);
    });
  }

  // arama işlemi
  Future<List<Kelimeler>> kelimeAra(String aramaKelimesi) async{
    var db = await DbHelper.veritabaniErisim();
    // sorgulama yapalım
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM kelimeler WHERE ingilizce LIKE '%$aramaKelimesi%'");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kelimeler(satir["kelimeId"], satir["ingilizce"], satir["turkce"]);
    });
  }

  // ekleme işlemi için metod
  Future<void> kelimeEkle(String ingilizce, turkce) async {
    var db = await DbHelper.veritabaniErisim();
    var bilgiler = <String, dynamic>{};
    bilgiler["ingilizce"] = ingilizce;
    bilgiler["turkce"] = turkce;
    await db.insert("kelimeler", bilgiler);
  }


}