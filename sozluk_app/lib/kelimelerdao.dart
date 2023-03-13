import 'package:sozluk_app/dbhelper.dart';
import 'kelimeler.dart';

class Kelimlerdao{

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
}
